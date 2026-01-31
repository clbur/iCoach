//
//  ConvocationsFootballApp.swift
//  iCoach
//
//  Point d'entrée de l'application avec configuration Core Data
//

import SwiftUI

@main
struct ConvocationsFootballApp: App {
    // Persistence controller partagé
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
