//
//  AuthenticationView.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 05.09.24.
//

import SwiftUI

/**
 Die `AuthenticationView`-Struktur ist eine SwiftUI-View, die die Benutzeroberfläche für die Benutzer-Authentifizierung darstellt.
 
 Diese View ermöglicht es dem Benutzer, sich anzumelden oder zu registrieren, basierend auf dem aktuellen Modus im `UserViewModel`.
 
 - Eigenschaften:
 - `userViewModel`: Das `UserViewModel`-Objekt, das die Authentifizierungslogik und -daten verwaltet.
 - `isPasswordVisible`: Boolean-Wert, der angibt, ob das Passwort sichtbar ist.
 - `isConfirmPasswordVisible`: Boolean-Wert, der angibt, ob das Bestätigungspasswort sichtbar ist.
 - `showAlert`: Boolean-Wert, der angibt, ob ein Alert angezeigt werden soll.
 */
struct AuthenticationView: View {
    
    // MARK: - Properties
    
    // Zugriff auf das UserViewModel (verwaltet Benutzerdaten und Anmelde-/Registrierungslogik)
    @EnvironmentObject private var userViewModel: UserViewModel
    
    // Zustandsvariablen für die Sichtbarkeit von Passwörtern und Fehlermeldungen
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showAlert = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Logo und Header
            Spacer()
            VStack(spacing: 12) {
                // Anzeige des Logos der App
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                // Header-Text, der je nach Modus entweder "Anmelden" oder "Registrieren" anzeigt
                Text(userViewModel.mode.headerText)
                    .foregroundStyle(.blue)
                    .font(Fonts.largeTitle)
            }
            .padding(.top, 50)
            
            // MARK: - Eingabefelder
            VStack(spacing: 12) {
                // Eingabefeld für den Namen
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(height: 50)
                    
                    TextField("Name", text: $userViewModel.name)
                        .padding()
                        .font(Fonts.headline)
                }
                
                // Wenn der Modus des Benutzer-ViewModels "register" ist, zeige das folgende UI-Element an.
                if userViewModel.mode == .register {
                    // Eingabefeld für den Wohnort
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(height: 50)
                        
                        TextField("Wohnort", text: $userViewModel.city)
                            .padding()
                            .font(Fonts.headline)
                    }
                    
                    // Eingabefelder für das Passwort und die Bestätigung bei der Registrierung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                    PasswordField(title: "Passwort wiederholen", text: $userViewModel.confirmPassword, isVisible: $isConfirmPasswordVisible)
                } else {
                    // Eingabefeld für das Passwort bei der Anmeldung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                }
            }
            .textInputAutocapitalization(.never)
            
            // MARK: - Authentifizierungsbutton
            AuthButton.authenticationButton(userViewModel: userViewModel, showAlert: $showAlert)
                .alert(isPresented: $showAlert) {
                    // Anzeige eines Alerts bei Fehlern
                    Alert(title: Text("Fehler"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
            Spacer()
            
            // MARK: - Modus wechseln
            AuthModeSwitchButton.switchModeButton(userViewModel: userViewModel)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 36)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color("Background")) // Hier wird der Hintergrund gesetzt
        .edgesIgnoringSafeArea(.all)
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            showAlert = !errorMessage.isEmpty
        }
    }
}

// MARK: - Vorschau

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())
    }
}













