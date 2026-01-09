//
//  JobOfferCard.swift
//  Apply
//

import SwiftUI

struct JobOfferCard: View {
    let jobOffer: JobOffer
    let companyName: String?
    let onSwipeRight: () -> Void
    let onSwipeLeft: () -> Void

    @State private var offset: CGSize = .zero
    @State private var rotationAngle: Double = 0
    @State private var showDetails: Bool = false
    
    private let swipeThreshold: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Carte principale
                VStack(alignment: .leading, spacing: 0) {
                    // Header avec score de match
                    HStack {
                        if let matchScore = jobOffer.matchScore {
                            Text("\(Int(matchScore))%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(matchScoreColor(matchScore).opacity(0.9))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        if let category = jobOffer.category {
                            Text(category.uppercased())
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Contenu principal
                    VStack(alignment: .leading, spacing: 12) {
                        if let companyName = companyName {
                            Text(companyName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Text(jobOffer.title)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        if let description = jobOffer.description, !description.isEmpty {
                            Text(description)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                )
                
                // Overlay pour swipe droite (vert)
                if offset.width > 0 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                                Text("INTÉRESSANT")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.green.opacity(0.2))
                    )
                    .opacity(min(abs(offset.width) / swipeThreshold, 1.0))
                }
                
                // Overlay pour swipe gauche (rouge)
                if offset.width < 0 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                                Text("PASSER")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.red.opacity(0.2))
                    )
                    .opacity(min(abs(offset.width) / swipeThreshold, 1.0))
                }
            }
            .offset(x: offset.width, y: offset.height)
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(1 - abs(offset.width) / 1000.0)
            .opacity(1 - abs(offset.width) / 800.0)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.4)
                    .onEnded { _ in
                        showDetails = true
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                        rotationAngle = Double(value.translation.width / 20)
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            if value.translation.width > swipeThreshold {
                                // Swipe droite
                                offset = CGSize(width: 1000, height: 0)
                                rotationAngle = 30
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSwipeRight()
                                }
                            } else if value.translation.width < -swipeThreshold {
                                // Swipe gauche
                                offset = CGSize(width: -1000, height: 0)
                                rotationAngle = -30
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSwipeLeft()
                                }
                            } else {
                                // Retour au centre
                                offset = .zero
                                rotationAngle = 0
                            }
                        }
                    }
            )
        }
        // TODO: Add JobOfferDetailView sheet when created
        // .sheet(isPresented: $showDetails) {
        //     JobOfferDetailView(jobOffer: jobOffer)
        // }
    }
    
    private func matchScoreColor(_ score: Double) -> Color {
        if score >= 80 {
            return .green
        } else if score >= 60 {
            return .orange
        } else {
            return .blue
        }
    }
}
