# APPLY
Copilote intelligent pour candidatures en alternance (iOS)

---

## 1. Vision Produit

### 1.1 Problème

Chercher une alternance est :
- Long et répétitif (lettres personnalisées)
- Désorganisé (Excel, notes, mails)
- Stressant (relances oubliées, peu de retours)
- Peu guidé (entretiens mal préparés)

Les candidats passent plus de temps à gérer qu’à optimiser.

---

### 1.2 Solution

**APPLY** est une application iOS qui :
- Transforme une URL d’offre en candidature complète
- Propose des offres pertinentes via un système de swipe
- Centralise le suivi, les relances et la préparation entretien
- Utilise l’IA comme copilote décisionnel

---

### 1.3 Proposition de valeur

| Valeur | Description |
|------|-------------|
| ⏱️ Gain de temps | 5 min par candidature |
| 🎯 Pertinence | Offres filtrées par profil |
| 🧠 Intelligence | IA contextuelle (profil + offre) |
| 📊 Clarté | Pipeline clair et visuel |
| 😌 Sérénité | Relances et rappels automatiques |

---

## 2. Cible

- Étudiants Bac+2 à Bac+5
- Alternance (12–24 mois)
- Domaines : dev, produit, data, marketing, business
- iOS-first

---

## 3. Objectifs Produit

### 3.1 MVP

- Activation < 10 minutes
- 1 candidature complète générée
- Découverte d’offres pertinentes
- Tracking clair des candidatures

### 3.2 Long terme

- Augmenter le taux de réponse
- Réduire le stress candidat
- Créer un pool d’offres communautaire qualitatif

---

## 4. Principes Produit

- **URL-first** : jamais de formulaire long
- **Swipe-first** pour la découverte
- **Exclusivité temporaire** pour celui qui apporte une offre
- **IA comme copilote**, pas comme boîte noire
- **Pas de blocage utilisateur** (doublons tolérés)

---

## 5. Parcours Utilisateur

### 5.1 Onboarding

**Objectif : profil exploitable en < 3 minutes**

1. Welcome APPLY
2. Authentification :
   - Email
   - Password
3. Création du profil utilisateur :
   - Formation
   - Compétences
   - Expériences
4. Préférences de recherche :
   - Domaines (ex: développement)
   - Type de contrat
   - Localisation
5. CTA : **Ajouter une offre**

---

## 6. Core Loop

### 6.1 Ajout d’une offre (URL)

- L’utilisateur colle une URL
- Un **agent AI SDK** est déclenché via **Trigger.dev**
- L’agent :
  - Analyse l’offre
  - Extrait les infos clés
  - Catégorise l’offre (ex: dev, marketing…)
  - Calcule le match avec le profil
- L’offre est :
  - **Privée pendant 48h**
  - Visible uniquement par son créateur
  - Ajoutée à son dashboard

---

### 6.2 Exclusivité des offres

- Une offre ajoutée est :
  - `isPublic = false` pendant 48h
  - Toujours visible pour son créateur
- Après 48h :
  - `isPublic = true`
  - Elle apparaît dans **Découverte**
- Objectif :
  - Récompenser celui qui apporte l’offre
  - Enrichir le pool commun

---

### 6.3 Découverte (Swipe)

- Page dédiée **Découverte**
- Swipe type Tinder :
  - Swipe droite → sauvegarder / apply
  - Swipe gauche → ignorer
- Uniquement :
  - Offres publiques
  - Offres récentes (< 15 jours)
  - Offres correspondant au profil
- Chaque carte affiche :
  - Poste
  - Entreprise
  - Localisation
  - Score de match (%)

---

### 6.4 Application à une offre

- Swipe droite ou bouton "Apply"
- Génération automatique :
  - Lettre de motivation personnalisée
  - Email d’accompagnement
- IA utilisée :
  - AI SDK
  - Contexte : profil + offre
- L’utilisateur peut :
  - Éditer
  - Copier
  - Exporter

---

## 7. Tracking & Suivi

### 7.1 Pipeline Kanban

Colonnes :
- À postuler
- Postulé
- Relance
- Entretien
- Offre
- Refus

Chaque carte :
- Entreprise
- Poste
- Dernière action
- Badge urgence

---

### 7.2 Relances

- Relance suggérée automatiquement
- Email généré par IA
- Ton adapté selon délai

---

## 8. Préparation Entretien

- Fiche entreprise
- Questions probables
- Points forts à placer
- Questions à poser
- Option mock interview (post-MVP)

---

## 9. Architecture Technique

### 9.1 Stack

#### Frontend
- SwiftUI
- Swift Concurrency

#### Backend
- Node.js / Hono ou Next.js
- Drizzle ORM
- Zod

#### IA & Jobs
- AI SDK (analyse, génération, matching)
- Trigger.dev (agents, jobs async)

#### Database
- PostgreSQL

---

## 10. Modèle de données (résumé)

### 10.1 user_preferences
> La table `users` existe déjà (auth)

- userId
- education
- skills
- experiences
- preferredDomains
- preferredContract
- preferredLocation
- createdAt
- updatedAt

---

### 10.2 job_offers

- id
- sourceUrl
- title
- company
- category (IA)
- description
- requiredSkills
- matchScore
- isPublic
- isActive
- createdAt

---

### 10.3 applications

- id
- userId
- jobOfferId
- status
- coverLetter
- emailContent
- appliedAt
- nextFollowUpAt

---

## 11. Gestion des doublons

- Les doublons sont autorisés
- Même URL → même offre en DB si existante
- Plusieurs utilisateurs peuvent postuler
- Aucune friction côté utilisateur

---

## 12. Fraîcheur des offres

### MVP
- Découverte = offres < 15 jours

### Plus tard
- Job Trigger.dev :
  - Re-check des URLs
  - Si indisponible → `isActive = false`
  - Retirée de la découverte

---

## 13. Roadmap

### Phase 1 — MVP
- Ajout offre URL
- Génération candidature
- Pipeline
- Découverte swipe

### Phase 2
- Jobs de vérification offres
- Stats utilisateur
- Mock interview

### Phase 3
- Premium
- Coaching IA
- Recommandations intelligentes

---

## 14. Critères de succès

- 10 candidatures en < 1h
- Feed Découverte pertinent
- Utilisateur confiant avant entretien

---

**— FIN PRD APPLY**
