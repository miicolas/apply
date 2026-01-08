# 📘 PRD — AltFlow
**Personal Application Tracking System (iOS)**

---

## 1. Vision & ambition

### Vision
AltFlow aide les étudiants et profils juniors à transformer une recherche d’alternance désorganisée en un **processus structuré, mesurable et efficace**, via une application iOS simple, intelligente et responsable.

AltFlow n’est **pas** un job board.  
AltFlow est un **outil d’exécution personnelle**.

---

### Ambition produit
- Réduire drastiquement le temps passé à chercher des offres
- Augmenter le nombre de candidatures pertinentes envoyées
- Améliorer le taux de réponse via un meilleur suivi et des relances
- Donner une posture professionnelle et proactive au candidat

---

## 2. Problème utilisateur

### Problème principal
Les étudiants :
- passent trop de temps à chercher des offres
- postulent sans stratégie ni priorisation
- oublient de relancer
- ne mesurent pas ce qui fonctionne
- subissent leur recherche plutôt que de la piloter

---

### Problèmes secondaires
- Informations dispersées (job boards, LinkedIn, sites carrière)
- Aucune hiérarchisation objective des opportunités
- Absence de rappels
- Manque de visibilité sur l’état des candidatures

---

## 3. Cible utilisateur

### Persona principal
**Étudiant / Junior développeur**
- Recherche une alternance ou un stage
- À l’aise avec le numérique
- Mobile-first (iPhone)
- Souhaite aller vite, sans complexité inutile

---

### Cas d’usage prioritaires
- Alternance développeur (frontend, fullstack, backend)
- Profils tech / produit / transformation digitale
- Recherche locale, hybride ou remote

---

## 4. Proposition de valeur

> *“AltFlow transforme ta recherche d’alternance en un pipeline clair, actionnable et mesurable.”*

### Différenciateurs clés
- Mobile-first (iOS)
- Scoring automatique des opportunités
- Rappels intelligents de relance
- Approche responsable et légale du scraping
- Simplicité radicale (anti-ATS corporate)

---

## 5. Objectifs produit (OKRs)

### Objectifs qualitatifs
- Réduire la charge mentale du candidat
- Clarifier les priorités quotidiennes
- Encourager la relance systématique
- Donner une vision claire du pipeline

---

### Objectifs quantitatifs
- 5 à 10 candidatures ciblées par jour
- 100 % des candidatures suivies
- 0 oubli de relance
- Taux de réponse mesurable

---

## 6. Fonctionnalités — MVP (obligatoires)

### 6.1 Gestion des opportunités
- Ajout manuel d’une opportunité
- Champs obligatoires :
  - entreprise
  - rôle
  - lien vers l’offre
  - source
  - localisation
  - notes libres
- Champs automatiques :
  - date de création
  - score
  - priorité (A / B / C)
  - statut initial = “À postuler”

---

### 6.2 Scoring automatique
Chaque opportunité est scorée automatiquement selon :
- adéquation du rôle
- type d’entreprise (startup / scale-up / grand groupe)
- stack ou mots-clés
- localisation / remote

Résultat :
- Score numérique
- Priorité visuelle :
  - 🟢 A
  - 🟡 B
  - 🔴 C

Objectif : **supprimer toute hésitation lors de la prise de décision**.

---

### 6.3 Pipeline de candidature
Statuts disponibles :
- À postuler
- Postulé
- Entretien
- Refus
- Ghost 👻

Interactions :
- Swipe actions
- Changement de statut en un geste
- Vue liste (Kanban possible en V1)

---

### 6.4 Rappels intelligents
- Notification locale automatique J+7 après candidature
- Bouton “Relancé”
- Historique des relances par opportunité

Objectif : **augmenter mécaniquement le taux de réponse**.

---

### 6.5 Notes post-interaction
- Notes libres associées à une opportunité
- Timestamp automatique
- Utilisable après call ou entretien

---

## 7. Fonctionnalités — V1 (nice to have)

- Filtres et tris (statut, priorité, date)
- Statistiques simples :
  - candidatures envoyées
  - réponses reçues
  - entretiens obtenus
- Templates de messages de relance
- Tags personnalisés

---

## 8. Fonctionnalités — V2 (long terme)

- Backend distant
- Scraping responsable automatisé
- Synchronisation multi-device
- Publication App Store
- Extension à d’autres profils (marketing, business, produit)

---

## 9. Architecture produit

### Frontend (iOS)
- SwiftUI
- iOS 17+
- Architecture MVVM légère
- Local-first (fonctionne sans backend)

---

### Backend
- API REST avec Hono
- Authentification via Better Auth
- Base de données Postgres
- Scraping ciblé et responsable
- Fréquence basse (1x / jour max)

---

### Données
- Opportunités normalisées
- Déduplication automatique
- Données strictement nécessaires uniquement
- Aucune donnée sensible inutile

---

## 10. Authentification & sécurité

### Auth
- Better Auth
- Email OTP (passwordless)
- Sessions longue durée (30 jours)
- Apple Sign-In possible en V2

---

### Sécurité
- Routes protégées par session
- Rate limiting
- Token scoped
- Séparation claire auth / métier / scraping

---

## 11. Légalité & éthique (fondamentale)

### Principes
- Aucune authentification forcée sur des sites tiers
- Aucun contournement technique
- Aucune surcharge serveur
- Usage personnel / privé

---

### Sources autorisées
- Pages publiques
- Job boards ouverts
- Pages carrière officielles
- Flux RSS

---

## 12. Indicateurs de succès

### Metrics utilisateur
- Nombre d’opportunités ajoutées
- Nombre de candidatures envoyées
- Taux de relance
- Taux de réponse

---

### Metrics produit
- Temps moyen pour ajouter une offre
- Temps moyen pour postuler
- Adoption des rappels

---

## 13. Hors périmètre (volontaire)

- ATS corporate
- Matching IA complexe
- Réseaux sociaux
- Messagerie intégrée
- Scraping massif ou agressif

---

## 14. Positionnement en entretien

> *“J’ai conçu une app iOS de A à Z pour résoudre un problème réel : la recherche d’alternance. J’ai travaillé la vision produit, l’UX, l’architecture, l’authentification et les contraintes légales.”*

---

## 15. Roadmap indicative

| Semaine | Objectif |
|-------|----------|
| S1 | MVP fonctionnel local |
| S2 | Notifications & polish |
| S3 | Backend + auth |
| S4 | Scraping & stats |

---

## 16. Risques & mitigations

| Risque | Mitigation |
|------|------------|
| Trop de fonctionnalités | MVP strict |
| Problèmes légaux | Sources whitelist |
| Complexité technique | Local-first |
| Abandon | Usage personnel quotidien |

---

## 17. Résumé exécutif
AltFlow est une application iOS qui transforme la recherche d’alternance en un pipeline clair, mesurable et actionnable, en combinant simplicité, intelligence et responsabilité.
