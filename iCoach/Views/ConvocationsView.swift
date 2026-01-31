//
//  ConvocationsView.swift
//  iCoach
//
//  Vue de liste des convocations
//

import SwiftUI
import CoreData

struct ConvocationsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Convocation.dateConvocation, ascending: false)],
        animation: .default)
    private var convocations: FetchedResults<Convocation>
    
    var body: some View {
        List {
            ForEach(convocations, id: \.id) { convocation in
                ConvocationRowView(convocation: convocation)
            }
            .onDelete(perform: deleteConvocations)
        }
        .navigationTitle("Convocations")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .overlay {
            if convocations.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Aucune convocation")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Les convocations apparaîtront ici")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func deleteConvocations(offsets: IndexSet) {
        withAnimation {
            offsets.map { convocations[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Erreur lors de la suppression: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Convocation Row View
struct ConvocationRowView: View {
    let convocation: Convocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Joueur
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                Text(convocation.joueur?.nomComplet ?? "Joueur inconnu")
                    .font(.headline)
            }
            
            // Match
            if let match = convocation.match {
                HStack {
                    Image(systemName: "sportscourt")
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(match.equipe ?? "") - \(match.categorie ?? "")")
                            .font(.subheadline)
                        Text(match.dateComplete)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(match.lieu ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Statut
            HStack {
                Image(systemName: iconForStatut(convocation.statut ?? ""))
                    .foregroundColor(colorForStatut(convocation.statut ?? ""))
                Text(convocation.statut ?? "Inconnu")
                    .font(.subheadline)
                    .foregroundColor(colorForStatut(convocation.statut ?? ""))
                
                Spacer()
                
                if let date = convocation.dateConvocation {
                    Text(dateFormatter.string(from: date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func colorForStatut(_ statut: String) -> Color {
        switch statut {
        case "Confirmé":
            return .green
        case "En attente":
            return .orange
        case "Refusé":
            return .red
        default:
            return .gray
        }
    }
    
    private func iconForStatut(_ statut: String) -> String {
        switch statut {
        case "Confirmé":
            return "checkmark.circle.fill"
        case "En attente":
            return "clock.fill"
        case "Refusé":
            return "xmark.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    NavigationView {
        ConvocationsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
