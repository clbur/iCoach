# iCoach ⚽

Application iOS complète pour gérer les convocations de différentes équipes de football avec gestion de base de données locale (Core Data).

## 📱 Description

iCoach est une application iOS moderne développée en SwiftUI qui permet aux entraîneurs et responsables d'équipes de football de gérer efficacement :
- Les joueurs et leurs informations (âge, catégorie)
- Les compétitions et leurs saisons
- Les matchs avec tous les détails (lieu, horaire, type de terrain)
- Les convocations des joueurs pour chaque match

## ✨ Fonctionnalités principales

### Gestion des données
- **Import CSV** : Importez facilement vos listes de joueurs depuis un fichier CSV
- **Import JSON** : Importez vos compétitions et matchs depuis des fichiers JSON structurés
- **Base de données locale** : Toutes les données sont stockées localement avec Core Data
- **Suppression** : Possibilité de supprimer des entrées avec un simple swipe

### Affichage et filtrage
- **Liste des joueurs** : Recherche par nom/prénom et filtrage par catégorie (U14, U15, U16, etc.)
- **Liste des matchs** : Vue chronologique de tous les matchs avec détails complets
- **Liste des compétitions** : Vue d'ensemble de toutes les compétitions avec nombre de matchs
- **Liste des convocations** : Suivi des convocations avec codes couleur selon le statut

### Navigation intuitive
- Interface moderne en SwiftUI
- Navigation claire entre les différentes sections
- Vues détaillées pour chaque élément
- Support du mode sombre

## 🛠 Technologies utilisées

- **SwiftUI** : Interface utilisateur moderne et déclarative
- **Core Data** : Persistance locale des données
- **iOS 16.0+** : Compatibilité avec les dernières versions d'iOS
- **FileImporter** : Import de fichiers CSV et JSON
- **FetchRequest** : Requêtes dynamiques pour les listes

## 📂 Structure du projet

```
iCoach/
├── App/
│   └── ConvocationsFootballApp.swift    # Point d'entrée de l'application
├── Models/
│   ├── ConvocationsFootball.xcdatamodeld  # Modèle Core Data
│   ├── Persistence.swift                   # Configuration Core Data
│   └── CoreDataModels+Extensions.swift     # Extensions des entités
├── Utils/
│   └── Importers.swift                     # Classes d'import CSV/JSON
├── Views/
│   ├── ContentView.swift                   # Vue principale
│   ├── JoueursListView.swift              # Liste des joueurs
│   ├── MatchsListView.swift               # Liste des matchs
│   ├── CompetitionsListView.swift         # Liste des compétitions
│   └── ConvocationsView.swift             # Liste des convocations
└── SampleData/
    ├── joueurs_exemple.csv                 # Exemple de données joueurs
    ├── competitions_exemple.json           # Exemple de données compétitions
    └── matchs_exemple.json                 # Exemple de données matchs
```

## 📥 Format des fichiers d'import

### CSV - Joueurs
Le fichier CSV doit suivre le format suivant :
```csv
nom,prenom,date_naissance,categorie
Dupont,Jean,15/03/2010,U15
Martin,Pierre,22/07/2009,U16
Bernard,Marie,10/01/2011,U14
```

**Format de date** : `dd/MM/yyyy`

### JSON - Compétitions
```json
[
  {
    "nom": "Championnat U15",
    "equipe": "Équipe A",
    "categorie": "U15",
    "saison": "2025-2026"
  }
]
```

### JSON - Matchs
```json
[
  {
    "date": "15/02/2026",
    "heure": "14:30",
    "lieu": "Stade Municipal",
    "typeTerrain": "Synthétique",
    "categorie": "U15",
    "equipe": "Équipe A",
    "competition": "Championnat U15"
  }
]
```

**Formats** :
- Date : `dd/MM/yyyy`
- Heure : `HH:mm`

## 🚀 Installation

### Prérequis
- Xcode 14.0 ou supérieur
- macOS 12.0 (Monterey) ou supérieur
- iOS 16.0+ pour l'appareil cible

### Étapes d'installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/clbur/iCoach.git
   cd iCoach
   ```

2. **Ouvrir le projet dans Xcode**
   ```bash
   open iCoach.xcodeproj
   ```
   *(Note : Si le fichier .xcodeproj n'existe pas encore, créez un nouveau projet Xcode et ajoutez tous les fichiers source)*

3. **Configurer le projet**
   - Sélectionnez votre équipe de développement dans les paramètres de signature
   - Vérifiez que le déploiement cible est réglé sur iOS 16.0+
   - Assurez-vous que Core Data est activé dans les capacités du projet

4. **Build et Run**
   - Sélectionnez un simulateur ou un appareil iOS
   - Appuyez sur `Cmd + R` ou cliquez sur le bouton Run

## 📖 Guide d'utilisation

### Premier lancement

1. **Importer des données de test**
   - Lancez l'application
   - Dans la section "📥 Import de données", importez les fichiers exemples :
     - `joueurs_exemple.csv` pour les joueurs
     - `competitions_exemple.json` pour les compétitions
     - `matchs_exemple.json` pour les matchs

2. **Explorer l'application**
   - Naviguez vers "Joueurs" pour voir la liste importée
   - Utilisez les filtres par catégorie et la recherche
   - Consultez les matchs et leurs détails
   - Explorez les compétitions et leurs matchs associés

### Fonctionnalités avancées

- **Recherche de joueurs** : Utilisez la barre de recherche pour trouver un joueur par nom ou prénom
- **Filtrage** : Sélectionnez une catégorie spécifique (U14, U15, etc.) pour affiner la liste
- **Suppression** : Swipez vers la gauche sur n'importe quel élément pour le supprimer
- **Détails** : Appuyez sur un élément pour voir tous ses détails

## 🗄 Modèle de données Core Data

### Entités

**Joueur**
- `id` (UUID) - Identifiant unique
- `nom` (String) - Nom de famille
- `prenom` (String) - Prénom
- `dateNaissance` (Date) - Date de naissance
- `categorie` (String) - Catégorie (U14, U15, etc.)
- Relations : `convocations` (one-to-many vers Convocation)

**Match**
- `id` (UUID) - Identifiant unique
- `date` (Date) - Date du match
- `heure` (Date) - Heure du match
- `lieu` (String) - Lieu du match
- `typeTerrain` (String) - Type de terrain (Synthétique, Pelouse, etc.)
- `categorie` (String) - Catégorie
- `equipe` (String) - Nom de l'équipe
- Relations : 
  - `competition` (many-to-one vers Competition)
  - `convocations` (one-to-many vers Convocation)

**Competition**
- `id` (UUID) - Identifiant unique
- `nom` (String) - Nom de la compétition
- `equipe` (String) - Équipe concernée
- `categorie` (String) - Catégorie
- `saison` (String) - Saison (ex: 2025-2026)
- Relations : `matchs` (one-to-many vers Match)

**Convocation**
- `id` (UUID) - Identifiant unique
- `statut` (String) - Statut (Confirmé, En attente, Refusé)
- `dateConvocation` (Date) - Date de la convocation
- Relations :
  - `joueur` (many-to-one vers Joueur)
  - `match` (many-to-one vers Match)

## 🎨 Captures d'écran

*(Captures d'écran à ajouter)*

- Vue principale avec options d'import
- Liste des joueurs avec filtres
- Détails d'un match
- Liste des compétitions
- Liste des convocations

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer de nouvelles fonctionnalités
- Soumettre des pull requests

## 📝 License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 👨‍💻 Auteur

**clbur**

## 🙏 Remerciements

Merci d'utiliser iCoach ! Cette application a été développée pour faciliter la gestion des équipes de football de jeunes.

---

**Version** : 1.0.0  
**Dernière mise à jour** : Janvier 2026
