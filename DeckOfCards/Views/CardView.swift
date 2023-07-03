//
//  CardView.swift
//  DeckOfCards
//
//  Created by Arturo Alfani on 03/06/23.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var deckVVM: DeckViewVM
    
    var card: Card
    var size: CGSize
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(30)
            Rectangle()
                .fill(Color("Card"))
                .cornerRadius(30)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(card.color) Card")
                        .font(.title)
                    Spacer()
                    Text("Swipe up, left or right")
                        .font(.caption)
                }
                .foregroundColor(Color(.white))
                Spacer()
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color(card.color))
                    .frame(width: 75, height: 75)
            }
            .padding(30)
        }
        .frame(width: 340, height: 210)
        .scaleEffect(deckVVM.indexOf(card: card) == 0 ? deckVVM.cardScale : 1, anchor: .top)
        .rotationEffect(deckVVM.indexOf(card: card) == 0 ? Angle(degrees: deckVVM.rotationAngle) : Angle(degrees: 0))
        .offset(y:
            deckVVM.indexOf(card: card) > 2 ? 0 :
            -(Double(deckVVM.indexOf(card: card) * 10))
        )
        /// Offset values for the first 3 cards
        .offset(y: deckVVM.indexOf(card: card) == 0 ? deckVVM.extraOffset : 0)
        /// Scale values for each card - Scale is reduced for each card by 0.06 (1 / 15)
        .scaleEffect(1 - (Double(deckVVM.indexOf(card: card)) / 15), anchor: .top)
        .zIndex(deckVVM.indexOf(card: card) == 0 ? deckVVM.zIndexValue : 0)
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(color: "Yellow"), size: CGSize())
            .environmentObject(DeckViewVM())
    }
}
