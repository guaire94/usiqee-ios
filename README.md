Usiqee iOS documentation
================
# Fastlane - Match

-> can get Certificat & Provisionning profile with match:
```
fastlane match development --readonly
```
```
fastlane match appstore --readonly
```

================
# Fastlane - Lanes
-> can create build and upload to testflight:
```
# automaticly trigger by develop branch
fastlane staging
```
```
# automaticly trigger by master branch
fastlane prod
```

================
# GIT Convention
-> when create commit, message have to be:
- For US in Trello, only US title
```
# Example
US - 4.7.3 - bouton « modifier le panier » dans confirmation de commande
```
- For HOTFIX in Trello, only HOTFIX title
```
# Example
HOTFIX - 4.7.3 - Connexion avec mauvais mot de passe
```
- For Defects in Trello, only Defect title exept [OS]
```
# Example
Distance différente des U's Drive entre IOS et Android
```
- During Tech task, simply "TECH - message"
```
# Example
TECH - amélioration de la CI
```
- During Code Review, simply "CR Feedback"
- During Product Owner Review, simply "PO Feedback"
- During Quality Automation Review, simply "QA Feedback"
