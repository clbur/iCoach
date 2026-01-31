//
//  JoueursListView.swift
//  iCoach
//
//  Vue de liste des joueurs avec recherche et filtres
//

import SwiftUI
import CoreData

struct JoueursListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Joueur.nom, ascending: true)],
        animation: .default)
    private var joueurs: FetchedResults<Joueur>
    
    @State private var searchText = ""
    @State private var selectedCategorie = "Tous"
    
    let categories = ["Tous", "U14", "U15", "U16", "U17", "U18", "U19"]
    
    var filteredJoueurs: [Joueur] {
        joueurs.filter { joueur in
            let matchesSearch = searchText.isEmpty ||
                (joueur.nom?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (joueur.prenom?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesCategorie = selectedCategorie == "Tous" ||
                joueur.categorie == selectedCategorie
            
            return matchesSearch && matchesCategorie
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filtre par catégorie
            Picker("Catégorie", selection: $selectedCategorie) {
                ForEach(categories, id: \.self) { categorie in
                    Text(categorie).tag(categorie)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Liste des joueurs
            List {
                ForEach(filteredJoueurs, id: \.id) { joueur in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(joueur.nomComplet)
                            .font(.headline)
                        
                        HStack {
                            Text("\(joueur.age) ans")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(joueur.categorie ?? "")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteJoueurs)
            }
            .searchable(text: $searchText, prompt: "Rechercher par nom ou prénom")
        }
        .navigationTitle("Joueurs")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    private func deleteJoueurs(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredJoueurs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Erreur lors de la suppression: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    NavigationView {
        JoueursListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
