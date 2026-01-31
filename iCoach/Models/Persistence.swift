//
//  Persistence.swift
//  iCoach
//
//  Configuration du stack Core Data pour l'application
//

import CoreData

/// Contrôleur de persistence pour gérer le stack Core Data
struct PersistenceController {
    /// Instance partagée pour l'utilisation dans l'application
    static let shared = PersistenceController()

    /// Contrôleur de preview pour SwiftUI Previews avec données en mémoire
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Créer des données de test pour les previews
        
        // Joueurs de test
        let joueur1 = Joueur(context: viewContext)
        joueur1.id = UUID()
        joueur1.nom = "Dupont"
        joueur1.prenom = "Jean"
        joueur1.dateNaissance = Calendar.current.date(byAdding: .year, value: -15, to: Date())!
        joueur1.categorie = "U15"
        
        let joueur2 = Joueur(context: viewContext)
        joueur2.id = UUID()
        joueur2.nom = "Martin"
        joueur2.prenom = "Pierre"
        joueur2.dateNaissance = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
        joueur2.categorie = "U16"
        
        let joueur3 = Joueur(context: viewContext)
        joueur3.id = UUID()
        joueur3.nom = "Bernard"
        joueur3.prenom = "Marie"
        joueur3.dateNaissance = Calendar.current.date(byAdding: .year, value: -14, to: Date())!
        joueur3.categorie = "U14"
        
        // Compétitions de test
        let competition1 = Competition(context: viewContext)
        competition1.id = UUID()
        competition1.nom = "Championnat U15"
        competition1.equipe = "Équipe A"
        competition1.categorie = "U15"
        competition1.saison = "2025-2026"
        
        let competition2 = Competition(context: viewContext)
        competition2.id = UUID()
        competition2.nom = "Coupe Régionale U16"
        competition2.equipe = "Équipe B"
        competition2.categorie = "U16"
        competition2.saison = "2025-2026"
        
        // Matchs de test
        let match1 = Match(context: viewContext)
        match1.id = UUID()
        match1.date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        match1.heure = Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!
        match1.lieu = "Stade Municipal"
        match1.typeTerrain = "Synthétique"
        match1.categorie = "U15"
        match1.equipe = "Équipe A"
        match1.competition = competition1
        
        let match2 = Match(context: viewContext)
        match2.id = UUID()
        match2.date = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        match2.heure = Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
        match2.lieu = "Terrain d'Honneur"
        match2.typeTerrain = "Pelouse"
        match2.categorie = "U16"
        match2.equipe = "Équipe B"
        match2.competition = competition2
        
        // Convocations de test
        let convocation1 = Convocation(context: viewContext)
        convocation1.id = UUID()
        convocation1.statut = "Confirmé"
        convocation1.dateConvocation = Date()
        convocation1.joueur = joueur1
        convocation1.match = match1
        
        let convocation2 = Convocation(context: viewContext)
        convocation2.id = UUID()
        convocation2.statut = "En attente"
        convocation2.dateConvocation = Date()
        convocation2.joueur = joueur2
        convocation2.match = match2
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erreur lors de la création des données de preview: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    /// Container Core Data
    let container: NSPersistentContainer

    /// Initialise le contrôleur de persistence
    /// - Parameter inMemory: Si true, utilise un store en mémoire (pour les tests)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ConvocationsFootball")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // En production, il faudrait gérer cette erreur de manière appropriée
                fatalError("Erreur lors du chargement du store Core Data: \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
