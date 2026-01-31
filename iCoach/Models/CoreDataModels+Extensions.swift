//
//  CoreDataModels+Extensions.swift
//  iCoach
//
//  Extensions pour les entités Core Data générées automatiquement
//

import Foundation
import CoreData

// MARK: - Joueur Extensions
extension Joueur {
    /// FetchRequest pour récupérer tous les joueurs triés par nom
    static func fetchRequest() -> NSFetchRequest<Joueur> {
        let request = NSFetchRequest<Joueur>(entityName: "Joueur")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Joueur.nom, ascending: true)]
        return request
    }
    
    /// Nom complet du joueur (prénom + nom)
    var nomComplet: String {
        "\(prenom ?? "") \(nom ?? "")"
    }
    
    /// Calcule l'âge du joueur à partir de sa date de naissance
    var age: Int {
        guard let dateNaissance = dateNaissance else { return 0 }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateNaissance, to: Date())
        return ageComponents.year ?? 0
    }
    
    /// Tableau des convocations trié par date
    var convocationsArray: [Convocation] {
        let set = convocations as? Set<Convocation> ?? []
        return set.sorted {
            ($0.dateConvocation ?? Date.distantPast) > ($1.dateConvocation ?? Date.distantPast)
        }
    }
}

// MARK: - Match Extensions
extension Match {
    /// FetchRequest pour récupérer tous les matchs triés par date
    static func fetchRequest() -> NSFetchRequest<Match> {
        let request = NSFetchRequest<Match>(entityName: "Match")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Match.date, ascending: true)]
        return request
    }
    
    /// Date et heure complète formatée
    var dateComplete: String {
        guard let date = date, let heure = heure else { return "Date non définie" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStr = dateFormatter.string(from: date)
        
        let heureFormatter = DateFormatter()
        heureFormatter.locale = Locale(identifier: "fr_FR")
        heureFormatter.dateFormat = "HH:mm"
        let heureStr = heureFormatter.string(from: heure)
        
        return "\(dateStr) à \(heureStr)"
    }
    
    /// Date formatée (sans heure)
    var dateFormatee: String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    /// Heure formatée
    var heureFormatee: String {
        guard let heure = heure else { return "" }
        let heureFormatter = DateFormatter()
        heureFormatter.locale = Locale(identifier: "fr_FR")
        heureFormatter.dateFormat = "HH:mm"
        return heureFormatter.string(from: heure)
    }
    
    /// Tableau des convocations trié
    var convocationsArray: [Convocation] {
        let set = convocations as? Set<Convocation> ?? []
        return set.sorted {
            ($0.joueur?.nom ?? "") < ($1.joueur?.nom ?? "")
        }
    }
}

// MARK: - Competition Extensions
extension Competition {
    /// FetchRequest pour récupérer toutes les compétitions triées par nom
    static func fetchRequest() -> NSFetchRequest<Competition> {
        let request = NSFetchRequest<Competition>(entityName: "Competition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Competition.nom, ascending: true)]
        return request
    }
    
    /// Tableau des matchs trié par date
    var matchsArray: [Match] {
        let set = matchs as? Set<Match> ?? []
        return set.sorted {
            ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast)
        }
    }
    
    /// Nombre de matchs de la compétition
    var nombreMatchs: Int {
        matchsArray.count
    }
}

// MARK: - Convocation Extensions
extension Convocation {
    /// FetchRequest pour récupérer toutes les convocations triées par date
    static func fetchRequest() -> NSFetchRequest<Convocation> {
        let request = NSFetchRequest<Convocation>(entityName: "Convocation")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Convocation.dateConvocation, ascending: false)]
        return request
    }
    
    /// Couleur du statut pour l'affichage
    var statutCouleur: String {
        switch statut {
        case "Confirmé":
            return "green"
        case "En attente":
            return "orange"
        case "Refusé":
            return "red"
        default:
            return "gray"
        }
    }
}
