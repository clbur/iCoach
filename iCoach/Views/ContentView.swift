//
//  ContentView.swift
//  iCoach
//
//  Vue principale avec navigation et boutons d'import
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // États pour les file importers
    @State private var showingJoueursImporter = false
    @State private var showingCompetitionsImporter = false
    @State private var showingMatchsImporter = false
    
    // États pour les alerts
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationView {
            List {
                // Section Import de données
                Section(header: Text("📥 Import de données")) {
                    Button(action: {
                        showingJoueursImporter = true
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.blue)
                            Text("Importer des joueurs (CSV)")
                        }
                    }
                    
                    Button(action: {
                        showingCompetitionsImporter = true
                    }) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                            Text("Importer des compétitions (JSON)")
                        }
                    }
                    
                    Button(action: {
                        showingMatchsImporter = true
                    }) {
                        HStack {
                            Image(systemName: "sportscourt.fill")
                                .foregroundColor(.green)
                            Text("Importer des matchs (JSON)")
                        }
                    }
                }
                
                // Section Gestion
                Section(header: Text("⚽ Gestion")) {
                    NavigationLink(destination: JoueursListView()) {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.blue)
                            Text("Joueurs")
                        }
                    }
                    
                    NavigationLink(destination: MatchsListView()) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.orange)
                            Text("Matchs")
                        }
                    }
                    
                    NavigationLink(destination: CompetitionsListView()) {
                        HStack {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.red)
                            Text("Compétitions")
                        }
                    }
                    
                    NavigationLink(destination: ConvocationsView()) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.purple)
                            Text("Convocations")
                        }
                    }
                }
            }
            .navigationTitle("iCoach")
            .fileImporter(
                isPresented: $showingJoueursImporter,
                allowedContentTypes: [.commaSeparatedText, .plainText],
                allowsMultipleSelection: false
            ) { result in
                handleJoueursImport(result: result)
            }
            .fileImporter(
                isPresented: $showingCompetitionsImporter,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                handleCompetitionsImport(result: result)
            }
            .fileImporter(
                isPresented: $showingMatchsImporter,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                handleMatchsImport(result: result)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Import Handlers
    
    private func handleJoueursImport(result: Result<[URL], Error>) {
        do {
            let url = try result.get().first!
            
            // Sécuriser l'accès au fichier
            guard url.startAccessingSecurityScopedResource() else {
                showAlert(title: "Erreur", message: "Impossible d'accéder au fichier")
                return
            }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            let count = try JoueurCSVImporter.importJoueurs(from: url, context: viewContext)
            showAlert(title: "Succès", message: "\(count) joueur(s) importé(s) avec succès")
        } catch {
            showAlert(title: "Erreur d'import", message: error.localizedDescription)
        }
    }
    
    private func handleCompetitionsImport(result: Result<[URL], Error>) {
        do {
            let url = try result.get().first!
            
            guard url.startAccessingSecurityScopedResource() else {
                showAlert(title: "Erreur", message: "Impossible d'accéder au fichier")
                return
            }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            let count = try CompetitionJSONImporter.importCompetitions(from: url, context: viewContext)
            showAlert(title: "Succès", message: "\(count) compétition(s) importée(s) avec succès")
        } catch {
            showAlert(title: "Erreur d'import", message: error.localizedDescription)
        }
    }
    
    private func handleMatchsImport(result: Result<[URL], Error>) {
        do {
            let url = try result.get().first!
            
            guard url.startAccessingSecurityScopedResource() else {
                showAlert(title: "Erreur", message: "Impossible d'accéder au fichier")
                return
            }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            let count = try MatchJSONImporter.importMatchs(from: url, context: viewContext)
            showAlert(title: "Succès", message: "\(count) match(s) importé(s) avec succès")
        } catch {
            showAlert(title: "Erreur d'import", message: error.localizedDescription)
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
