# Instructions de Build et Compilation - iCoach

Ce document fournit des instructions détaillées pour compiler et exécuter l'application iCoach.

## Prérequis

### Matériel et Système
- **Mac** avec macOS 12.0 (Monterey) ou supérieur
- Au moins **8 GB de RAM** (16 GB recommandé)
- **20 GB d'espace disque libre**

### Logiciels Requis
- **Xcode 14.0 ou supérieur** (téléchargeable depuis l'App Store)
- **iOS 16.0+** comme cible de déploiement
- Compte développeur Apple (gratuit ou payant)

## Installation et Configuration

### 1. Installation de Xcode

Si Xcode n'est pas déjà installé :

```bash
# Option 1 : Via l'App Store (recommandé)
# Ouvrez l'App Store et recherchez "Xcode"

# Option 2 : Via la ligne de commande
xcode-select --install
```

Vérifiez l'installation :
```bash
xcode-select -p
# Devrait afficher : /Applications/Xcode.app/Contents/Developer
```

### 2. Clonage du Repository

```bash
# Clonez le repository
git clone https://github.com/clbur/iCoach.git

# Accédez au dossier du projet
cd iCoach
```

### 3. Structure du Projet

Vérifiez que la structure suivante existe :

```
iCoach/
├── iCoach.xcodeproj/           # Projet Xcode
│   └── project.pbxproj
├── iCoach/                      # Code source
│   ├── App/
│   │   └── ConvocationsFootballApp.swift
│   ├── Models/
│   │   ├── ConvocationsFootball.xcdatamodeld/
│   │   ├── Persistence.swift
│   │   └── CoreDataModels+Extensions.swift
│   ├── Utils/
│   │   └── Importers.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── JoueursListView.swift
│   │   ├── MatchsListView.swift
│   │   ├── CompetitionsListView.swift
│   │   └── ConvocationsView.swift
│   ├── SampleData/
│   │   ├── joueurs_exemple.csv
│   │   ├── competitions_exemple.json
│   │   └── matchs_exemple.json
│   ├── Assets.xcassets/
│   └── Info.plist
└── README.md
```

## Compilation et Exécution

### Option 1 : Via Xcode (Recommandé)

1. **Ouvrir le projet**
   ```bash
   open iCoach.xcodeproj
   ```
   
   Ou double-cliquez sur `iCoach.xcodeproj` dans le Finder.

2. **Configuration de la signature**
   - Dans Xcode, sélectionnez le projet "iCoach" dans le navigateur
   - Sélectionnez la cible "iCoach"
   - Allez dans l'onglet "Signing & Capabilities"
   - Sélectionnez votre équipe dans "Team" (ou créez un compte développeur gratuit)

3. **Sélectionner une destination**
   - En haut de la fenêtre Xcode, cliquez sur le menu de destination
   - Sélectionnez un simulateur (ex: "iPhone 15 Pro") ou un appareil iOS physique

4. **Compiler et lancer**
   - Appuyez sur `Cmd + R` ou cliquez sur le bouton ▶️ (Play)
   - Attendez que la compilation se termine
   - L'application se lancera automatiquement

### Option 2 : Via la Ligne de Commande

1. **Lister les simulateurs disponibles**
   ```bash
   xcrun simctl list devices
   ```

2. **Compiler pour simulateur**
   ```bash
   xcodebuild -project iCoach.xcodeproj \
              -scheme iCoach \
              -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
              clean build
   ```

3. **Lancer sur simulateur**
   ```bash
   # Démarrer le simulateur
   open -a Simulator
   
   # Installer et lancer l'app (après compilation)
   xcrun simctl install booted path/to/iCoach.app
   xcrun simctl launch booted com.clbur.iCoach
   ```

### Option 3 : Compilation pour Appareil Physique

1. **Connecter votre iPhone/iPad** via USB

2. **Activer le mode développeur** sur l'appareil :
   - Allez dans Réglages > Confidentialité et sécurité > Mode développeur
   - Activez-le et redémarrez l'appareil

3. **Sélectionner l'appareil** dans Xcode

4. **Compiler et déployer** (`Cmd + R`)

## Résolution des Problèmes Courants

### Erreur : "No signing certificate found"

**Solution** :
1. Allez dans Xcode > Preferences > Accounts
2. Ajoutez votre Apple ID
3. Dans le projet, sélectionnez votre équipe dans "Signing & Capabilities"

### Erreur : "Core Data model not found"

**Solution** :
- Vérifiez que le dossier `ConvocationsFootball.xcdatamodeld` est bien dans le projet
- Faites un Clean Build Folder (`Cmd + Shift + K`)
- Rebuild (`Cmd + B`)

### Erreur : "Swift Compiler Error"

**Solution** :
1. Assurez-vous d'utiliser Xcode 14.0+
2. Vérifiez que la version Swift est 5.0+ dans Build Settings
3. Clean et rebuild

### L'application crash au lancement

**Solution** :
1. Vérifiez les logs dans la Console Xcode
2. Assurez-vous que Core Data est correctement configuré
3. Supprimez l'app du simulateur et réinstallez

### Les imports CSV/JSON ne fonctionnent pas

**Solution** :
- Sur simulateur : Glissez-déposez les fichiers dans le simulateur
- Sur appareil : Utilisez AirDrop ou iCloud Drive pour transférer les fichiers exemples

## Test de l'Application

### 1. Premier Lancement

Au premier lancement, l'application sera vide. Pour tester les fonctionnalités :

1. **Préparer les fichiers de test** :
   - Les fichiers sont dans `iCoach/SampleData/`
   - `joueurs_exemple.csv`
   - `competitions_exemple.json`
   - `matchs_exemple.json`

2. **Transférer les fichiers** :
   
   **Sur Simulateur** :
   ```bash
   # Glissez-déposez les fichiers dans la fenêtre du simulateur
   # ou utilisez la commande :
   xcrun simctl addmedia booted iCoach/SampleData/*.csv
   ```
   
   **Sur Appareil** :
   - Utilisez AirDrop depuis votre Mac
   - Ou sauvegardez-les dans l'app Fichiers (iCloud Drive)

### 2. Importer les Données

Dans l'application :
1. Appuyez sur "Importer des compétitions (JSON)"
2. Sélectionnez `competitions_exemple.json`
3. Appuyez sur "Importer des matchs (JSON)"
4. Sélectionnez `matchs_exemple.json`
5. Appuyez sur "Importer des joueurs (CSV)"
6. Sélectionnez `joueurs_exemple.csv`

### 3. Explorer l'Application

- Naviguez vers "Joueurs" pour voir la liste
- Utilisez les filtres par catégorie
- Testez la recherche
- Consultez les matchs et compétitions
- Testez la suppression (swipe gauche)

## Build Release

Pour créer une version Release :

```bash
xcodebuild -project iCoach.xcodeproj \
           -scheme iCoach \
           -configuration Release \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           clean build
```

## Archive pour Distribution

Pour créer une archive en vue de distribution (TestFlight/App Store) :

1. Dans Xcode : Product > Archive
2. Une fois l'archive créée, elle apparaîtra dans l'Organizer
3. Sélectionnez "Distribute App" pour soumettre à TestFlight ou l'App Store

## Configuration Avancée

### Changer l'identifiant de bundle

1. Ouvrez le projet dans Xcode
2. Sélectionnez la cible "iCoach"
3. Dans "General", modifiez "Bundle Identifier"
4. Par défaut : `com.clbur.iCoach`

### Modifier la version

Dans le projet Xcode :
- **Version** (Marketing Version) : `1.0`
- **Build** (Current Project Version) : `1`

### Activer des fonctionnalités supplémentaires

Dans "Signing & Capabilities" :
- iCloud (pour synchronisation)
- Push Notifications (pour notifications)
- Background Modes (pour tâches en arrière-plan)

## Ressources Supplémentaires

- **Documentation Apple** : https://developer.apple.com/documentation/
- **SwiftUI** : https://developer.apple.com/swiftui/
- **Core Data** : https://developer.apple.com/documentation/coredata

## Support

Pour signaler des bugs ou demander de l'aide :
- Ouvrez une issue sur GitHub : https://github.com/clbur/iCoach/issues

## Licence

Ce projet est sous licence MIT.

---

**Note** : Pour toute question concernant la compilation ou des problèmes techniques, consultez d'abord cette documentation avant de créer une issue.
