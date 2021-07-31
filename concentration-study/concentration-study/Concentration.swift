//
//  Concentration.swift
//  concentration-study
//
//  Created by bigzero on 2021/05/29.
//
import Foundation;

struct Concentration {
    private(set) var cards = [Card]();
    
    // indexOfOneAndOnlyfaceUpcard 를 읽거나 쓸때 자동으로 전체 카드를 돌면서 index 가 갱신된다.
    // 즉, isFaceUp 을 읽고 쓸때 마다 이 함수가 호출된다.
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // closure 와 extension 을 이용한 방법 추가.
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly;
            
//            var faceUpCardIndex: Int?;
//            for i in cards.indices {
//                if cards[i].isFaceUp {
//                    if faceUpCardIndex == nil {
//                        faceUpCardIndex = i;
//                    } else {
//                        faceUpCardIndex = nil;
//                    }
//                }
//            }
//            return faceUpCardIndex;
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue);
            }
        }
    }
    
      /* 수업에서 만든 코드 */
//    mutating func chooseCard(at index: Int) {
//        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards");
//        if !cards[index].isMatched {
//            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
//                // check if cards match
//                if cards[matchIndex] == cards[index] {
//                    cards[matchIndex].isMatched = true;
//                    cards[index].isMatched = true;
//                }
//                cards[index].isFaceUp = true;
//            } else {
//                // either no cards or 2 cards are face up
//                indexOfOneAndOnlyFaceUpCard = index;
//            }
//        }
//    }
        
        
    /* 내가 만든 코드 */
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards");
        /* card가 이미 매칭되지 않고, 선택한 카드가 윗면으로 되어 있지 않아야 함.*/
        if !cards[index].isMatched, indexOfOneAndOnlyFaceUpCard != index {
            // 세가지 경우만 존재함
            // 1. 모두 뒷면만 있는 경우, 2. 한개는 윗면으로 있는 경우
            if indexOfOneAndOnlyFaceUpCard == nil {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false;  // indexOfOneAndOnlyFaceUpCard 를 갱신함.
                }
            } else {
                // check if cards match
                if cards[indexOfOneAndOnlyFaceUpCard!] == cards[index] {    // indexOfOneAndOnlyFaceUpCard 를 읽어들임.
                    cards[indexOfOneAndOnlyFaceUpCard!].isMatched = true;
                    cards[index].isMatched = true;
                } else {
                    cards[indexOfOneAndOnlyFaceUpCard!].isMatched = false;
                    cards[index].isMatched = false;
                }
            }
            cards[index].isFaceUp = true;   // indexOfOneAndOnlyFaceUpCard 를 갱신함.
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 , "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards");
        for _ in 0..<numberOfPairsOfCards {
            let card = Card();      // 구조체 이기 때문에 일단 여기서 카드 1개가 만들어짐(복사됨)
//            cards.append(card);                         // 여기서 카드가 두번째로 복사되어 만들어짐
//            cards.append(card);                         // 여기서 카드가 세번째로 복사되어 만들어짐
//            => 매우 중요함. class 와 struct 의 중요한 차이점임.
            cards += [card, card]; // 위에 append 두개를 이렇게 한줄로 만들수도 있다.
            
            // 구조체 이어서 아래처럼 하지 않음.
            // 이렇게 구조체를 주고 받을 때 복사한다는 걸 이해해야 한다.
//            let matchingCard = card;
//            cards.append(card);
//            cards.append(matchingCard);
        }
        
        // TODO: Shuffle the cards
        
    }
    
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil;
    }
}
