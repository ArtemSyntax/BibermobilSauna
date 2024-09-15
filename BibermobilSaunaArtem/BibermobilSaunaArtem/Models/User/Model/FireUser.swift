//
//  FireUser.swift
//  BibermobilSaunaArtem
//
//  Created by Artem Kaschinski on 05.09.24.
//


import Foundation

/**
 Das `FireUser`-Modell repräsentiert einen Benutzer in der Firestore-Datenbank.

 Es enthält grundlegende Benutzerinformationen und implementiert das `Codable`-Protokoll, um eine einfache Speicherung und einen einfachen Abruf aus Firestore zu ermöglichen.

 - Eigenschaften:
    - `id`: Die eindeutige Benutzer-ID (String).
    - `name`: Der Name des Benutzers (String).
    - `registeredAt`: Das Datum, an dem der Benutzer sich registriert hat (Date)
    - `city`: Der Wohnort des Benutzers (String)
        

 - Bemerkungen:
    - Diese Struktur folgt dem `Codable`-Protokoll, das es ermöglicht, sie einfach in und aus Firestore-Dokumenten zu konvertieren.
    - Die `registeredAt`-Eigenschaft ist ein `Date`-Objekt, das das Registrierungsdatum des Benutzers speichert.
 */
struct FireUser: Codable {
    /// Die eindeutige Benutzer-ID.
    var id: String
    
    var email: String
    
    /// Der Name des Benutzers.
    var fullname: String
    
    var city: String
    
    var postalcode : String
    
    var street : String
    
    var housenumber : Int
    
    /// Das Datum, an dem der Benutzer sich registriert hat.
    var registeredAt: Date
    
    /**
     Initialisiert eine neue `FireUser`-Instanz.
     
     - Parameter id: Die eindeutige Benutzer-ID.
     - Parameter name: Der Name des Benutzers.
     - Parameter city: Der Wohnort des Benutzers.
     - Parameter registeredAt: Das Datum, an dem der Benutzer sich registriert hat.
     */
    init(id: String,email:String, fullname: String,city: String,postalcode: String ,street: String,housenumber: Int , registeredAt: Date) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.city = city
        self.postalcode = postalcode
        self.street = street
        self.housenumber = housenumber
        self.registeredAt = registeredAt
        
    }
}
