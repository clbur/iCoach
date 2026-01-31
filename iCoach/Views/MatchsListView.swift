//
//  MatchsListView.swift
//  iCoach
//
//  Vue de liste des matchs avec détails
//

import SwiftUI
import CoreData

struct MatchsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Match.date, ascending: true)],
        animation: .default)
    private var matchs: FetchedResults<Match>
    
    var body: some View {
        List {
            ForEach(matchs, id: \.id) { match in
                NavigationLink(destination: MatchDetailView(match: match)) {
                    MatchRowView(match: match)
                }
            }
            .onDelete(perform: deleteMatchs)
        }
        .navigationTitle("Matchs")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .overlay {
            if matchs.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "sportscourt")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Aucun match")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Importez des matchs pour commencer")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func deleteMatchs(offsets: IndexSet) {
        withAnimation {
            offsets.map { matchs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Erreur lors de la suppression: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Match Row View
struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Équipe et catégorie
            HStack {
                Text(match.equipe ?? "")
                    .font(.headline)
                
                Spacer()
                
                Text(match.categorie ?? "")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Date et heure
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.orange)
                Text(match.dateFormatee)
                    .font(.subheadline)
                
                Image(systemName: "clock")
                    .foregroundColor(.orange)
                    .padding(.leading, 8)
                Text(match.heureFormatee)
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
            
            // Lieu et terrain
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.red)
                Text(match.lieu ?? "")
                    .font(.subheadline)
                
                Spacer()
                
                Text(match.typeTerrain ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Compétition
            if let competition = match.competition {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                    Text(competition.nom ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Match Detail View
struct MatchDetailView: View {
    let match: Match
    
    var body: some View {
        List {
            Section("Informations générales") {
                DetailRow(label: "Équipe", value: match.equipe ?? "")
                DetailRow(label: "Catégorie", value: match.categorie ?? "")
                DetailRow(label: "Date", value: match.dateFormatee)
                DetailRow(label: "Heure", value: match.heureFormatee)
            }
            
            Section("Lieu") {
                DetailRow(label: "Stade", value: match.lieu ?? "")
                DetailRow(label: "Type de terrain", value: match.typeTerrain ?? "")
            }
            
            if let competition = match.competition {
                Section("Compétition") {
                    DetailRow(label: "Nom", value: competition.nom ?? "")
                    DetailRow(label: "Saison", value: competition.saison ?? "")
                }
            }
            
            Section("Convocations") {
                if match.convocationsArray.isEmpty {
                    Text("Aucune convocation pour ce match")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(match.convocationsArray, id: \.id) { convocation in
                        HStack {
                            Text(convocation.joueur?.nomComplet ?? "")
                            Spacer()
                            Text(convocation.statut ?? "")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(colorForStatut(convocation.statut ?? ""))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Détails du match")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func colorForStatut(_ statut: String) -> Color {
        switch statut {
        case "Confirmé":
            return Color.green.opacity(0.2)
        case "En attente":
            return Color.orange.opacity(0.2)
        case "Refusé":
            return Color.red.opacity(0.2)
        default:
            return Color.gray.opacity(0.2)
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

#Preview {
    NavigationView {
        MatchsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
