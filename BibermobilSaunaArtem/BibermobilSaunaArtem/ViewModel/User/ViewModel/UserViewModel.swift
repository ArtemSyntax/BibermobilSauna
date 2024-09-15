//
//  UserViewModel.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 05.09.24.
//
import Foundation
import FirebaseAuth
import SwiftUI



/**
 Das `UserViewModel` verwaltet die Benutzer-Authentifizierung und hält den Anwendungszustand bezüglich der Benutzerinformationen.
 
 Diese Klasse implementiert `ObservableObject`, um SwiftUI-Views über Änderungen der Benutzerinformationen zu informieren. Die Authentifizierungsmethoden umfassen Anmeldung, Registrierung und Abmeldung.
 
 - Eigenschaften:
 - `user`: Optionaler `FireUser`, der den aktuell authentifizierten Benutzer darstellt.
 - `mode`: Der aktuelle Authentifizierungsmodus (`login` oder `register`).
 - `name`: Benutzername oder E-Mail-Adresse für die Authentifizierung.
 - `password`: Passwort für die Authentifizierung.
 - `confirmPassword`: Bestätigung des Passworts bei der Registrierung.
 - `errorMessage`: Fehlermeldung bei Authentifizierungsfehlern.
 - `authenticationError`: Optionaler `AuthenticationError`, der spezifische Authentifizierungsfehler beschreibt.
 
 - Computed Properties:
 - `userIsLoggedIn`: Boolescher Wert, der angibt, ob ein Benutzer angemeldet ist.
 - `disableAuthentication`: Boolescher Wert, der angibt, ob die Authentifizierung deaktiviert ist (abhängig vom Modus und den Eingabefeldern).
 - `userId`: Optionaler String, der die UID des aktuell authentifizierten Benutzers enthält.
 - `nameDisplay`: Benutzername des aktuell authentifizierten Benutzers oder ein leerer String.
 
 - Funktionen:
 - `login(username:password:)`: Führt die Benutzeranmeldung durch.
 - `register(name:username:password:)`: Führt die Benutzerregistrierung durch.
 - `switchAuthenticationMode()`: Wechselt zwischen den Authentifizierungsmodi.
 - `authenticate()`: Führt die Authentifizierung basierend auf dem aktuellen Modus aus.
 - `clearFields()`: Leert die Eingabefelder für die Authentifizierung.
 - `logout()`: Meldet den aktuell authentifizierten Benutzer ab.
 - `deleteAccount()`: Löscht den aktuell authentifizierten Benutzer und dessen Daten.
 -
 */
@MainActor
class UserViewModel: ObservableObject {
    
    /// Initialisiert das `UserViewModel` und überprüft den Authentifizierungsstatus.
    init() {
        checkAuth()
    }
    
    // MARK: - Variables
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var user: FireUser?
    @Published var mode: AuthenticationMode = .login
    @Published var email: String = ""
    @Published var fullname: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var street: String = ""
    @Published var houseNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var authenticationError: AuthenticationError?
    
    
    
    

    
    // MARK: - Computed Properties
    
    /// Gibt an, ob ein Benutzer angemeldet ist.
    var userIsLoggedIn: Bool {
        user != nil
    }
    
    /// Gibt an, ob die Authentifizierung deaktiviert ist.
    var disableAuthentication: Bool {
        if mode == .register {
            return email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
        } else {
            return email.isEmpty || password.isEmpty
        }
    }
    
    /// Gibt die UID des aktuell authentifizierten Benutzers zurück.
    var userId: String? {
        firebaseManager.auth.currentUser?.uid
    }
    
    /// Gibt den Benutzernamen des aktuell authentifizierten Benutzers zurück.
    var nameDisplay: String {
        user?.fullname ?? ""
    }
    
    // MARK: - Functions
    
    /**
     Meldet den Benutzer mit dem angegebenen Benutzernamen und Passwort an.
     
     - Parameters:
     - username: Der Benutzername oder die E-Mail-Adresse.
     - password: Das Passwort.
     */
    func login(email: String, password: String) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Versucht, den Benutzer mit der angegebenen E-Mail und Passwort anzumelden
        firebaseManager.auth.signIn(withEmail: trimmedEmail, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.handleAuthError(error)
                return
            }
            
            guard let authResult = authResult else { return }
            
            // Ruft die Benutzerdaten nach erfolgreicher Authentifizierung ab
            self.fetchUser(with: authResult.user.uid)
        }
    }
    
    /**
     Registriert einen neuen Benutzer mit dem angegebenen Namen, Benutzernamen und Passwort.
     
     - Parameters:
     - name: Der Name des Benutzers.
     - username: Der Benutzername oder die E-Mail-Adresse.
     - password: Das Passwort.
     */
    
    
    func register(fullname: String, city: String, postalcode: String, street: String, housenumber: Int, email: String, password: String) {
        // Versucht, einen neuen Benutzer mit der angegebenen E-Mail und Passwort zu erstellen
        firebaseManager.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.handleAuthError(error)
                return
            }

            guard let authResult = authResult else { return }

            // Erstellt einen neuen Benutzereintrag in der Firestore-Datenbank
            self.createUser(with: authResult.user.uid, email: email, fullname: fullname, city: city, postalCode: postalcode, street: street, houseNumber: housenumber)

            // Meldet den neu registrierten Benutzer direkt an
            self.login(email: email, password: password)
        }
    }
    
    /**
     Löscht den aktuell authentifizierten Benutzer und dessen Daten.
     */
       func deleteAccount() {
           guard let currentUser = firebaseManager.auth.currentUser else {
               self.errorMessage = "Kein Benutzer angemeldet."
               return
           }
           
           // Löscht das Benutzer-Dokument aus Firestore
           firebaseManager.database.collection("users").document(currentUser.uid).delete { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                   self.errorMessage = "Fehler beim Löschen der Benutzerdaten: \(error.localizedDescription)"
                   return
               }
               
               // Löscht den Benutzer aus Firebase Authentication
               currentUser.delete { error in
                   if let error = error {
                       self.errorMessage = "Fehler beim Löschen des Benutzerkontos: \(error.localizedDescription)"
                   } else {
                       self.user = nil
                       self.errorMessage = "Account erfolgreich gelöscht"
                    
                       
                   }
               }
           }
       }
    
    /// Wechselt zwischen den Authentifizierungsmodi (`login` und `register`).
    func switchAuthenticationMode() {
        
        self.mode = self.mode == .login ? .register : .login
        self.clearFields()
        
    }
    
    func authenticate() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch mode {
        case .login:
            login(email: trimmedEmail, password: password)
        case .register:
            // Alle benötigten Felder für die Registrierung übergeben
            register(
                fullname: fullname,
                city: city,
                postalcode: postalCode,
                street: street,
                housenumber: Int(houseNumber) ?? 0, // Sicherstellen, dass housenumber konvertiert wird
                email: trimmedEmail,
                password: password
            )
        }
    }
    
    /// Leert die Eingabefelder für die Authentifizierung.
    ///
    ///
    // MUSS BEARBEITET WERDEN
    func clearFields() {
        
        self.email = ""
        self.city = ""
        self.password = ""
        self.confirmPassword = ""
        
        
    }
    
    /// Meldet den aktuell authentifizierten Benutzer ab.
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            
            self.user = nil
            
            
        } catch {
            DispatchQueue.main.async {
                self.handleAuthError(error as NSError)
            }
        }
    }
    
    
 
    

    
    
    
    
}

// MARK: - Private Methods

extension UserViewModel {
    
    /**
     Überprüft den Authentifizierungsstatus des Benutzers und ruft die Benutzerdaten ab, falls angemeldet.
     */
    private func checkAuth() {
        guard let currentUser = firebaseManager.auth.currentUser else {
            
           
            
            return
        }
        
        
        self.fetchUser(with: currentUser.uid)
        
    }
    
    /**
     Erstellt einen neuen Benutzer in der Firestore-Datenbank.
     
     - Parameters:
     - id: Die Benutzer-ID.
     - name: Der Name des Benutzers.
     */
    
    
    private func createUser(with id: String, email: String, fullname: String, city: String, postalCode: String, street: String, houseNumber: Int) {
        let user = FireUser(id: id, email: email, fullname: fullname, city: city, postalcode: postalCode, street: street, housenumber: houseNumber, registeredAt: Date())

        do {
            try firebaseManager.database.collection("users").document(id).setData(from: user)
        } catch let error {
            self.errorMessage = "Fehler beim Speichern des Users: \(error)"
        }
    }
    
    /**
     Behandelt Authentifizierungsfehler und setzt entsprechende Fehlermeldungen.
     
     - Parameter error: Der aufgetretene Fehler.
     */
    private func handleAuthError(_ error: NSError) {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            
            self.authenticationError = .unknownError
            self.errorMessage = "Ein unbekannter Fehler ist aufgetreten: \(error.localizedDescription)"
            print("Unbekannter Fehler: \(error.localizedDescription)")
            
            return
        }
        
        
        print("Auth Error Code: \(error.code)")
        print("Auth Error Description: \(error.localizedDescription)")
        
        switch errorCode {
        case .wrongPassword, .userNotFound, .invalidCredential:
            self.authenticationError = .invalidEmailOrPassword
            self.errorMessage = AuthenticationError.invalidEmailOrPassword.errorDescription!
        case .invalidEmail:
            self.authenticationError = .invalidEmailOrPassword
            self.errorMessage = AuthenticationError.invalidEmailOrPassword.errorDescription!
        case .emailAlreadyInUse:
            self.authenticationError = .emailAlreadyInUse
            self.errorMessage = AuthenticationError.emailAlreadyInUse.errorDescription!
        case .networkError:
            self.authenticationError = .networkError
            self.errorMessage = AuthenticationError.networkError.errorDescription!
        case .userTokenExpired:
            self.authenticationError = .sessionExpired
            self.errorMessage = AuthenticationError.sessionExpired.errorDescription!
        case .tooManyRequests:
            self.authenticationError = .tooManyRequests
            self.errorMessage = AuthenticationError.tooManyRequests.errorDescription!
        default:
            self.authenticationError = .unknownError
            self.errorMessage = AuthenticationError.unknownError.errorDescription!
            print("Nicht erkannter Fehlercode: \(error.code)")
        }
        
    }
    
    
    /**
     Ruft die Benutzerdaten aus der Firestore-Datenbank ab.
     
     - Parameter id: Die Benutzer-ID.
     */
    private func fetchUser(with id: String) {
        firebaseManager.database.collection("users").document(id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                
                self.errorMessage = "Fetching user failed: \(error.localizedDescription)"
                
                return
            }
            
            guard let document = document else {
                
                self.errorMessage = "Dokument existiert nicht!"
                
                return
            }
            
            do {
                let user = try document.data(as: FireUser.self)
                
                self.user = user
                
            } catch {
                
                self.errorMessage = "Dokument ist kein User: \(error.localizedDescription)"
                
            }
        }
    }
}
