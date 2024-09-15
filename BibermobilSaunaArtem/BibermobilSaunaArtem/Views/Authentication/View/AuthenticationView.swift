//
//  AuthenticationView.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 05.09.24.
//

import SwiftUI

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
                    .foregroundStyle(.yellow)
                    .font(.largeTitle)
            }
            .padding(.top, 50)
            
            // MARK: - Eingabefelder in ScrollView
            ScrollView {
                VStack(spacing: 12) {
                    // Eingabefeld für den Namen
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                    .frame(height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.yellow, lineWidth: 2)
                                    )
                        
                        TextField("E-Mail", text: $userViewModel.email)
                            .padding()
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    
                    // Wenn der Modus des Benutzer-ViewModels "register" ist, zeige die zusätzlichen Felder an.
                    if userViewModel.mode == .register {
                        // Eingabefeld für die Stadt
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                        .frame(height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                                
                            
                            TextField("Vollständiger Name ", text: $userViewModel.fullname)
                                .padding()
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                        .frame(height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                                
                            
                            TextField("Stadt", text: $userViewModel.city)
                                .padding()
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        
                        // Eingabefeld für Postleitzahl
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                        .frame(height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                            
                            TextField("Postleitzahl", text: $userViewModel.postalCode)
                                .padding()
                                .font(.headline)
                                .foregroundStyle(.black)
                                .keyboardType(.numberPad)
                        }
                        
                        // Eingabefeld für Straße
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                        .frame(height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                            
                            TextField("Straße", text: $userViewModel.street)
                                .padding()
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        
                        // Eingabefeld für Hausnummer
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                                        .frame(height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                            
                            TextField("Hausnummer", text: $userViewModel.houseNumber)
                                .padding()
                                .font(.headline)
                                .foregroundStyle(.black)
                                .keyboardType(.numberPad)
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
                .padding(.horizontal, 36) // Optional: Anpassung des Innenabstands
            }
            .frame(maxHeight: 300) // Optional: Setze eine maximale Höhe für die ScrollView
            .padding(.horizontal, -36) // Korrigiert die zusätzliche horizontale Einrückung durch ScrollView
            
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
        .background(Image("Background")) // Hier wird der Hintergrund gesetzt
        .edgesIgnoringSafeArea(.all)
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            showAlert = !errorMessage.isEmpty
        }
    }
}













