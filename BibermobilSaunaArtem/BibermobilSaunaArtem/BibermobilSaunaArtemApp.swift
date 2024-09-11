//
//  BibermobilSaunaArtemApp.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 03.09.24.
//

import SwiftUI

@main




// MARK: - Initializer

/**
 Initialisiert die App und konfiguriert Firebase.
 */
init() {
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()
    requestNotificationAuthorization()
   
}

// MARK: - Variables

@StateObject private var userViewModel = UserViewModel()


// MARK: - Private Methods

/**
     Fordert die Berechtigung für Benachrichtigungen vom Benutzer an.
     */
private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            print(granted)
        }
    }

// MARK: - Body

var body: some Scene {
    WindowGroup {
        // Entscheidet, welche View basierend auf dem Anmeldestatus des Benutzers angezeigt wird
        
        /*
        if userViewModel.userIsLoggedIn {
            // Zeigt die HomeView an, wenn der Benutzer angemeldet ist
            withAnimation(.easeInOut(duration: 0.7)) {
                HomeView()
                    .transition(.move(edge: .leading))
                    .environmentObject(userViewModel)
                    .environmentObject(cityViewModel)
            }
        } else {
         */
            withAnimation(.easeInOut(duration: 0.7)) {
                // Zeigt die AuthenticationView an, wenn der Benutzer nicht angemeldet ist
                AuthenticationView()
                    .transition(.move(edge: .leading))
                    .environmentObject(userViewModel)
                    
            }
        }
    }







