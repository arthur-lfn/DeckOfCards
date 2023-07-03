//
//  DeckView.swift
//  DeckOfCards
//
//  Created by Arturo Alfani on 03/06/23.
//

import SwiftUI

struct DeckView: View {
    @EnvironmentObject var deckVVM: DeckViewVM
    
    var body: some View {
        GeometryReader { screen in
            let size = screen.size
            VStack {
                if !deckVVM.deckCollection.isEmpty{
                    Text("\(deckVVM.cardPosition) / \(deckVVM.deckCollection.count)")
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                        .padding(.bottom, 40)
                }
                ZStack {
                    ForEach(
                        deckVVM.deckCollection.count > 2 ?
                        deckVVM.deckCollection[..<3].reversed() :
                            deckVVM.deckCollection.reversed()
                    ) { card in
                        CardView(card: card, size: size)
                            .offset(
                                x: deckVVM.indexOf(card: card) == 0 ? deckVVM.horizontalOffset : 0,
                                y: deckVVM.indexOf(card: card) == 0 ? deckVVM.verticalOffset : 0
                            )
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 2)
                        .onChanged(deckVVM.onChanged(value:))
                        .onEnded(deckVVM.onEndedVertical(value:))
                        .onEnded(deckVVM.onEndedHorizontal(value:))
                )
                .disabled(deckVVM.deckIsDisabled)
            }
            .frame(width: size.width, height: size.height)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
            .environmentObject(DeckViewVM())
    }
}
