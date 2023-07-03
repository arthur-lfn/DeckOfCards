//
//  ContentView.swift
//  DeckOfCards
//
//  Created by Arturo Alfani on 03/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var deckVVM = DeckViewVM()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                DeckView()
                    .frame(height: geo.size.height * 0.5)
                    .environmentObject(deckVVM)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
