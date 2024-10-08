//
//  AuthButton.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 05.09.24.
//

import SwiftUI

// MARK: - AuthButton

/**
 Die `AuthButton`-Struktur ist eine SwiftUI-View-Komponente, die einen primären Aktionsbutton darstellt.
 
 Dieser Button wird in der `AuthenticationView` verwendet, um Aktionen wie Anmelden oder Registrieren auszuführen.

 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct AuthButton: View {
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            // Text, der auf dem Button angezeigt wird
            Text(title)
                .font(.body)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.yellow)
                
                
        }
        
        .padding(.vertical, 12)
        .background(Color.green)
        .cornerRadius(16)
    }
}

// MARK: - Erweiterung für spezifische Logik

extension AuthButton {
    @MainActor static func authenticationButton(userViewModel: UserViewModel, showAlert: Binding<Bool>) -> AuthButton {
        return AuthButton(title: userViewModel.mode.title) {
            // Überprüfung, ob die Authentifizierung deaktiviert ist
            if userViewModel.disableAuthentication {
                // Fehlerbehandlung und entsprechende Fehlermeldungen
                if userViewModel.email.isEmpty {
                    userViewModel.errorMessage = "Bitte geben Sie einen Namen ein."
                }else if userViewModel.mode == .register && userViewModel.city.isEmpty {
                    userViewModel.errorMessage = "Bitte geben Sie eine Stadt ein."
                }
                else if userViewModel.password.isEmpty {
                    userViewModel.errorMessage = "Bitte geben Sie ein Passwort ein."
                } else if userViewModel.mode == .register && userViewModel.confirmPassword.isEmpty {
                    userViewModel.errorMessage = "Bitte wiederholen Sie das Passwort."
                } else if userViewModel.mode == .register && userViewModel.password != userViewModel.confirmPassword {
                    userViewModel.errorMessage = "Die Passwörter stimmen nicht überein."
                }
                showAlert.wrappedValue = true
            } else {
                // Authentifizierungsvorgang starten
                userViewModel.authenticate()
                // Eingabefelder leeren nach der Authentifizierung
                userViewModel.clearFields()
            }
        }
    }
}

// MARK: - Vorschau

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(title: "Login") { }
    }
}
