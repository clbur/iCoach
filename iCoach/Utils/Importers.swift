//
//  Importers.swift
//  iCoach
//
//  Classes pour importer des données depuis CSV et JSON
//

import Foundation
import CoreData

// MARK: - Joueur CSV Importer
/// Importateur de joueurs depuis un fichier CSV
class JoueurCSVImporter {
    /// Importe les joueurs depuis un fichier CSV
    /// - Parameters:
    ///   - url: URL du fichier CSV
    ///   - context: NSManagedObjectContext pour sauvegarder les données
    /// - Returns: Nombre de joueurs importés
    /// - Throws: Erreur en cas de problème d'import
    static func importJoueurs(from url: URL, context: NSManagedObjectContext) throws -> Int {
        // Lire le contenu du fichier
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        guard lines.count > 1 else {
            throw ImportError.emptyFile
        }
        
        // Ignorer la première ligne (en-têtes)
        let dataLines = Array(lines.dropFirst())
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var importCount = 0
        
        for line in dataLines {
            let components = line.components(separatedBy: ",")
            
            guard components.count >= 4 else {
                continue // Ignorer les lignes mal formatées
            }
            
            let nom = components[0].trimmingCharacters(in: .whitespaces)
            let prenom = components[1].trimmingCharacters(in: .whitespaces)
            let dateNaissanceStr = components[2].trimmingCharacters(in: .whitespaces)
            let categorie = components[3].trimmingCharacters(in: .whitespaces)
            
            guard let dateNaissance = dateFormatter.date(from: dateNaissanceStr) else {
                continue // Ignorer si la date n'est pas valide
            }
            
            // Créer le joueur
            let joueur = Joueur(context: context)
            joueur.id = UUID()
            joueur.nom = nom
            joueur.prenom = prenom
            joueur.dateNaissance = dateNaissance
            joueur.categorie = categorie
            
            importCount += 1
        }
        
        // Sauvegarder
        try context.save()
        
        return importCount
    }
}

// MARK: - Competition JSON Importer
/// Importateur de compétitions depuis un fichier JSON
class CompetitionJSONImporter {
    struct CompetitionData: Codable {
        let nom: String
        let equipe: String
        let categorie: String
        let saison: String
    }
    
    /// Importe les compétitions depuis un fichier JSON
    /// - Parameters:
    ///   - url: URL du fichier JSON
    ///   - context: NSManagedObjectContext pour sauvegarder les données
    /// - Returns: Nombre de compétitions importées
    /// - Throws: Erreur en cas de problème d'import
    static func importCompetitions(from url: URL, context: NSManagedObjectContext) throws -> Int {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let competitions = try decoder.decode([CompetitionData].self, from: data)
        
        var importCount = 0
        
        for compData in competitions {
            let competition = Competition(context: context)
            competition.id = UUID()
            competition.nom = compData.nom
            competition.equipe = compData.equipe
            competition.categorie = compData.categorie
            competition.saison = compData.saison
            
            importCount += 1
        }
        
        // Sauvegarder
        try context.save()
        
        return importCount
    }
}

// MARK: - Match JSON Importer
/// Importateur de matchs depuis un fichier JSON
class MatchJSONImporter {
    struct MatchData: Codable {
        let date: String
        let heure: String
        let lieu: String
        let typeTerrain: String
        let categorie: String
        let equipe: String
        let competition: String
    }
    
    /// Importe les matchs depuis un fichier JSON
    /// - Parameters:
    ///   - url: URL du fichier JSON
    ///   - context: NSManagedObjectContext pour sauvegarder les données
    /// - Returns: Nombre de matchs importés
    /// - Throws: Erreur en cas de problème d'import
    static func importMatchs(from url: URL, context: NSManagedObjectContext) throws -> Int {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let matchs = try decoder.decode([MatchData].self, from: data)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let heureFormatter = DateFormatter()
        heureFormatter.locale = Locale(identifier: "fr_FR")
        heureFormatter.dateFormat = "HH:mm"
        
        var importCount = 0
        
        for matchData in matchs {
            guard let date = dateFormatter.date(from: matchData.date) else {
                continue // Ignorer si la date n'est pas valide
            }
            
            guard let heure = heureFormatter.date(from: matchData.heure) else {
                continue // Ignorer si l'heure n'est pas valide
            }
            
            // Rechercher la compétition correspondante
            let fetchRequest: NSFetchRequest<Competition> = Competition.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "nom == %@", matchData.competition)
            let competitions = try context.fetch(fetchRequest)
            
            let match = Match(context: context)
            match.id = UUID()
            match.date = date
            match.heure = heure
            match.lieu = matchData.lieu
            match.typeTerrain = matchData.typeTerrain
            match.categorie = matchData.categorie
            match.equipe = matchData.equipe
            
            // Associer la compétition si elle existe
            if let competition = competitions.first {
                match.competition = competition
            }
            
            importCount += 1
        }
        
        // Sauvegarder
        try context.save()
        
        return importCount
    }
}

// MARK: - Import Error
enum ImportError: LocalizedError {
    case emptyFile
    case invalidFormat
    case fileNotReadable
    
    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "Le fichier est vide"
        case .invalidFormat:
            return "Format de fichier invalide"
        case .fileNotReadable:
            return "Impossible de lire le fichier"
        }
    }
}
