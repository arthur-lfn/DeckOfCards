//
//  Cards.swift
//  DeckOfCards
//
//  Created by Arturo Alfani on 03/07/23.
//

import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let color: String
}

var deck: [Card] = [
    Card(color: "Yellow"),
    Card(color: "Teal"),
    Card(color: "Green"),
    Card(color: "Purple"),
    Card(color: "Red"),
    Card(color: "Indingo")
]
