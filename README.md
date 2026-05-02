# **ChainCacao Mobile**

Application mobile de traçabilité agricole

1. Description

ChainCacao Mobile est une application destinée à faciliter l’accès à la traçabilité des produits agricoles depuis un appareil mobile.

Elle permet aux différents acteurs (coopérative, transformateur, exportateur) d’interagir avec le système directement sur le terrain.

2. Objectifs
   Simplifier l’utilisation en mobilité
   Accélérer la saisie des données
   Permettre la consultation rapide des lots
   Offrir une vérification instantanée via QR code
3. Fonctionnalités principales
   Authentification
   Connexion sécurisée
   Gestion des rôles
   Gestion des lots
   Consultation des lots reçus
   Affichage des détails
   Mise à jour des informations (poids, notes)
   Transfert de lots
   Envoi entre acteurs
   Suivi en temps réel
   Vérification
   Scan QR code
   Consultation instantanée de l’historique
4. Technologies utilisées
   Kotlin (Android)
   XML (UI)
   API REST (connexion backend Django)
5. Architecture
   Activity principale (MainActivity)
   Layout XML
   Services API
   Gestion des états utilisateur
6. Installation
   Prérequis
   Android Studio
   SDK Android
   Étapes
   git clone https://github.com/ton-repo/chaincacao-mobile.git

Ouvrir dans Android Studio puis :

Synchroniser Gradle
Lancer l’application sur :
émulateur
appareil réel
7. Configuration API

Dans le code :

val BASE_URL = "http://10.0.2.2:8000"

(Adapter selon ton environnement)

8. Utilisation
   Parcours utilisateur
   Connexion
   Consultation des lots
   Mise à jour des données
   Transfert
   Vérification
9. Cas d’usage terrain
   Coopérative recevant un lot
   Transformateur en usine
   Exportateur validant un envoi
   Contrôleur vérifiant un lot via QR code
10. Améliorations futures
    Mode hors ligne (offline sync)
    Scan QR avancé
    Notifications push
    Signature numérique
11. Auteur

Application développée dans le cadre d’un projet académique / hackathon.