//
//  CompetitionsListView.swift
//  iCoach
//
//  Vue de liste des compétitions
//

import SwiftUI
import CoreData

struct CompetitionsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Competition.nom, ascending: true)],
        animation: .default)
    private var competitions: FetchedResults<Competition>
    
    var body: some View {
        List {
            ForEach(competitions, id: \.id) { competition in
                NavigationLink(destination: CompetitionDetailView(competition: competition)) {
                    CompetitionRowView(competition: competition)
                }
            }
            .onDelete(perform: deleteCompetitions)
        }
        .navigationTitle("Compétitions")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .overlay {
            if competitions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "trophy")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Aucune compétition")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Importez des compétitions pour commencer")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func deleteCompetitions(offsets: IndexSet) {
        withAnimation {
            offsets.map { competitions[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Erreur lors de la suppression: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Competition Row View
struct CompetitionRowView: View {
    let competition: Competition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Nom de la compétition
            Text(competition.nom ?? "")
                .font(.headline)
            
            // Équipe et catégorie
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.blue)
                Text(competition.equipe ?? "")
                    .font(.subheadline)
                
                Spacer()
                
                Text(competition.categorie ?? "")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .foregroundColor(.secondary)
            
            // Saison et nombre de matchs
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.orange)
                Text(competition.saison ?? "")
                    .font(.subheadline)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "sportscourt")
                        .font(.caption)
                    Text("\(competition.nombreMatchs) match\(competition.nombreMatchs > 1 ? "s" : "")")
                        .font(.caption)
                }
                .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Competition Detail View
struct CompetitionDetailView: View {
    let competition: Competition
    
    var body: some View {
        List {
            Section("Informations") {
                DetailRow(label: "Nom", value: competition.nom ?? "")
                DetailRow(label: "Équipe", value: competition.equipe ?? "")
                DetailRow(label: "Catégorie", value: competition.categorie ?? "")
                DetailRow(label: "Saison", value: competition.saison ?? "")
                DetailRow(label: "Nombre de matchs", value: "\(competition.nombreMatchs)")
            }
            
            Section("Matchs") {
                if competition.matchsArray.isEmpty {
                    Text("Aucun match pour cette compétition")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(competition.matchsArray, id: \.id) { match in
                        NavigationLink(destination: MatchDetailView(match: match)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(match.equipe ?? "")
                                    .font(.headline)
                                
                                HStack {
                                    Text(match.dateFormatee)
                                    Text("•")
                                    Text(match.heureFormatee)
                                    Text("•")
                                    Text(match.lieu ?? "")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(competition.nom ?? "Compétition")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        CompetitionsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
