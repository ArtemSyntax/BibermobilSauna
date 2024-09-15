//
//  BibermobilSaunaArtemApp.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 03.09.24.
//

import SwiftUI
import Firebase

@main
struct BibermobilSaunaArtemApp: App {
    
    // MARK: - Initializer
    init() {
        // Firebase konfigurieren
        FirebaseApp.configure()
        requestNotificationAuthorization()
    }
    
    // MARK: - State Objects
    @StateObject private var userViewModel = UserViewModel()
    
    // MARK: - Private Methods
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Fehler bei der Benachrichtigungsberechtigung: \(error)")
            } else {
                print("Benachrichtigungsberechtigung erteilt: \(granted)")
            }
        }
    }
    
    // MARK: - Body
    var body: some Scene {
       WindowGroup {
           /**
            // Überprüft den Anmeldestatus des Benutzers
            if userViewModel.userIsLoggedIn {
                // Zeigt die HomeView an, wenn der Benutzer angemeldet ist
                HomeView()
                    .transition(.move(edge: .leading))
                    .environmentObject(userViewModel)
            } else {**/
                // Zeigt die AuthenticationView an, wenn der Benutzer nicht angemeldet ist
                AuthenticationView()
                    .transition(.move(edge: .trailing))
                    .environmentObject(userViewModel)
            }
        }
    }
//}





