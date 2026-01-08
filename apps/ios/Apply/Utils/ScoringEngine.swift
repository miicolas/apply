//
//  ScoringEngine.swift
//  Apply
//
//  Created by Nicolas Becharat on 08/01/2026.
//

import Foundation

struct ScoringEngine {
    /// Calcule le score d'une opportunité selon les critères du PRD
    /// - Parameters:
    ///   - role: Adéquation du rôle
    ///   - companyType: Type d'entreprise (startup / scale-up / grand groupe)
    ///   - stack: Stack ou mots-clés pertinents
    ///   - location: Localisation / remote
    /// - Returns: Score numérique et priorité (A/B/C)
    static func score(
        role: String,
        companyType: CompanyType,
        stack: [String],
        location: LocationType
    ) -> (score: Int, priority: Priority) {
        var score = 0
        
        // Scoring selon le type d'entreprise
        switch companyType {
        case .startup:
            score += 30
        case .scaleUp:
            score += 40
        case .grandGroupe:
            score += 20
        }
        
        // Scoring selon la localisation
        switch location {
        case .remote:
            score += 30
        case .hybrid:
            score += 20
        case .onsite:
            score += 10
        }
        
        // Scoring selon la stack (à implémenter selon les mots-clés)
        // score += stackScore(stack)
        
        // Déterminer la priorité
        let priority: Priority
        if score >= 60 {
            priority = .A
        } else if score >= 40 {
            priority = .B
        } else {
            priority = .C
        }
        
        return (score, priority)
    }
    
    enum CompanyType {
        case startup
        case scaleUp
        case grandGroupe
    }
    
    enum LocationType {
        case remote
        case hybrid
        case onsite
    }
}
