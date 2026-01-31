#!/bin/bash

echo "==================================="
echo "Vérification du projet iCoach"
echo "==================================="
echo ""

# Vérifier la structure
echo "📁 Vérification de la structure..."
REQUIRED_FILES=(
    "iCoach.xcodeproj/project.pbxproj"
    "iCoach/App/ConvocationsFootballApp.swift"
    "iCoach/Models/Persistence.swift"
    "iCoach/Models/CoreDataModels+Extensions.swift"
    "iCoach/Utils/Importers.swift"
    "iCoach/Views/ContentView.swift"
    "iCoach/Views/JoueursListView.swift"
    "iCoach/Views/MatchsListView.swift"
    "iCoach/Views/CompetitionsListView.swift"
    "iCoach/Views/ConvocationsView.swift"
    "iCoach/Info.plist"
    "iCoach/SampleData/joueurs_exemple.csv"
    "iCoach/SampleData/competitions_exemple.json"
    "iCoach/SampleData/matchs_exemple.json"
    "README.md"
    "BUILD_INSTRUCTIONS.md"
    ".gitignore"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (MANQUANT)"
        MISSING_FILES+=("$file")
    fi
done

echo ""
echo "📊 Statistiques du projet:"
echo "  - Fichiers Swift: $(find iCoach -name "*.swift" | wc -l | tr -d ' ')"
echo "  - Vues SwiftUI: $(find iCoach/Views -name "*.swift" | wc -l | tr -d ' ')"
echo "  - Modèles: $(find iCoach/Models -name "*.swift" | wc -l | tr -d ' ')"
echo "  - Utilitaires: $(find iCoach/Utils -name "*.swift" | wc -l | tr -d ' ')"

echo ""
if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "✅ Tous les fichiers requis sont présents!"
    echo ""
    echo "🚀 Prochaines étapes:"
    echo "  1. Ouvrez le projet: open iCoach.xcodeproj"
    echo "  2. Sélectionnez un simulateur ou appareil"
    echo "  3. Compilez et lancez: Cmd + R"
    echo "  4. Importez les fichiers exemples depuis SampleData/"
    exit 0
else
    echo "❌ ${#MISSING_FILES[@]} fichier(s) manquant(s)"
    exit 1
fi
