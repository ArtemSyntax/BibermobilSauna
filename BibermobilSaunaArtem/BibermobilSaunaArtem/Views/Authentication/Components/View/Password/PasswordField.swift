//
//  PasswordField.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 06.09.24.
//

import SwiftUI

/**
 Die `PasswordField`-Struktur ist eine SwiftUI-View-Komponente, die ein Eingabefeld für Passwörter darstellt.
 
 Diese Komponente bietet die Möglichkeit, das Passwort sichtbar oder unsichtbar zu machen, indem ein Button verwendet wird, der das Symbol eines Auges anzeigt.
 
 - Eigenschaften:
 - `title`: Der Platzhaltertext für das Eingabefeld.
 - `text`: Die gebundene Variable, die den eingegebenen Text speichert.
 - `isVisible`: Eine gebundene Variable, die angibt, ob das Passwort sichtbar ist.
 */
struct PasswordField: View {
    
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Hintergrund des Passwortfelds
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial) // Verwende Material als Füllung
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow, lineWidth: 2)
                        )
            
            HStack {
                // Bedingte Anzeige des Textfelds basierend auf `isVisible`
                if isVisible {
                    // Normales Textfeld, wenn das Passwort sichtbar ist
                    TextField(title, text: $text)
                        .padding()
                        .font(.headline)
                        .foregroundStyle(.black)
                } else {
                    // Sicheres Textfeld, wenn das Passwort unsichtbar ist
                    SecureField(title, text: $text)
                        .padding()
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                // Button, um die Sichtbarkeit des Passworts umzuschalten
                Button(action: {
                    isVisible.toggle()
                }) {
                    // Symbol, das die aktuelle Sichtbarkeit des Passworts anzeigt
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundStyle(.yellow)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

// MARK: - Vorschau
struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(title: "Passwort", text: .constant(""), isVisible: .constant(false))
    }
}
