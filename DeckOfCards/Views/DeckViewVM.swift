//
//  DeckViewVM.swift
//  DeckOfCards
//
//  Created by Arturo Alfani on 03/06/23.
//

import SwiftUI

class DeckViewVM: ObservableObject {
    // MARK: Properties
    @Published var deckCollection: [Card] = deck
    @Published var cardPosition: Int = 1
    @Published var deckIsDisabled: Bool = false
    
    /// Deck animation properties
    @Published var horizontalOffset: CGFloat = 0
    @Published var verticalOffset: CGFloat = 0
    @Published var rotationAngle: Double = 0
    @Published var zIndexValue: Double = 0
    @Published var cardScale: Double = 1
    @Published var extraOffset: Double = 0
    
    // MARK: Methods
    /// Animation functions
    func onChanged(value: DragGesture.Value) {
        horizontalOffset =
            value.translation.width > 150 ? 150 :
            value.translation.width < -150 ? -150 :
            value.translation.width
        verticalOffset =
            value.translation.height < -150 ? -150 :
            value.translation.height > 0 ? 0 :
            value.translation.height
    }

    func onEndedVertical(value: DragGesture.Value) {
        let translation = value.translation.height

        if translation < -100 && (value.translation.width > -100 && value.translation.width < 100) {
            deckIsDisabled = true
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                extraOffset = -200
                cardScale = 0.5
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    self.zIndexValue = -1
                    self.extraOffset = 0
                    self.horizontalOffset = .zero
                    self.verticalOffset = .zero
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation() {
                    self.cardScale = 1
                }

                self.zIndexValue = 0

                if !self.deckCollection.isEmpty {
                    let firstCard = self.deckCollection[0]
                    withAnimation(.easeIn(duration: 0.1)) {
                        self.deckCollection.remove(at: 0)
                        self.deckCollection.append(firstCard)
                        /// Updates displayed card position
                        self.updateCardPosition()
                        /// Remove the card from the deck
                        self.removeFromDeck(
                            index: self.indexOf(card: firstCard)
                        )
                    }
                    self.deckIsDisabled = false
                }
            }
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.7)) {
                verticalOffset = .zero
            }
        }
    }

    func onEndedHorizontal(value: DragGesture.Value) {
        let translation = value.translation.width

        if (translation > 100 || translation < -100) && value.translation.height > -100 {
            deckIsDisabled = true
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                extraOffset = -250
                cardScale = 0.3
                
                if translation > 100 {
                    rotationAngle += 30
                } else if translation < -100 {
                    rotationAngle -= 30
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    self.zIndexValue = -1
                    self.extraOffset = 0
                    self.horizontalOffset = .zero
                    self.verticalOffset = .zero
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation() {
                    self.cardScale = 1
                    
                    if translation > 100 {
                        self.rotationAngle -= 30
                    } else if translation < -100 {
                        self.rotationAngle += 30
                    }
                }

                self.zIndexValue = 0

                let firstCard = self.deckCollection[0]
                withAnimation(.easeIn(duration: 0.1)) {
                    self.deckCollection.remove(at: 0)
                    self.deckCollection.append(firstCard)
                    self.updateCardPosition()
                }
                
                self.deckIsDisabled = false
            }
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.7)) {
                horizontalOffset = .zero
            }
        }
    }
    
    /// Retrieve index of a given card
    func indexOf(card: Card) -> Int {
        if let index = deckCollection.firstIndex(where: { thisCard in
            thisCard.id == card.id
        }) {
            return index
        }
        return 0
    }
    
    /// Update indicator
    func updateCardPosition() {
        if cardPosition < deckCollection.count {
            cardPosition += 1
        } else {
            cardPosition = 1
        }
    }
    
    /// Remove the card from the deck after swiping up
    func removeFromDeck(index: Int) {
        deckCollection.remove(at: index)
        
        if deckCollection.isEmpty {
            /// Populate the deck again
            deckCollection = deck.shuffled()
        }
    }
}
