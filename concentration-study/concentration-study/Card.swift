//
//  Card.swift
//  concentration-study
//
//  Created by bigzero on 2021/05/29.
//

import Foundation

struct Card: Hashable {
    
    private var identifier: Int;
    var isFaceUp = false;
    var isMatched = false;

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier;
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier);
    }
    
    
    private static var identifierFactory = 0;
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1;
        return identifierFactory;
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier();
    }
}
