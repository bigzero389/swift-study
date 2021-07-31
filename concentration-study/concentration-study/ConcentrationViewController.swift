//
//  ViewController.swift
//  concentration-study
//
//  Created by bigzero on 2021/05/29.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2);
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet {
            updateFlipCountLabel();
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!;
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel();
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton!;
    @IBAction func pushNewGame(_ sender: UIButton) {
        // TODO: make new game button event
        self.game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2);
        updateViewFromModel();
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)" , attributes: attributes);
        flipCountLabel.attributedText = attributedString;
        //            flipCountLabel.text = "flips:\(flipCount)";
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
           print("cardNumber = \(cardNumber)");
//           flipCard(withEmoji: emojiChoices[cardNumber], on: sender);
            game.chooseCard(at: cardNumber);
            flipCount += 1;
            print("flipCount : \(flipCount)")
            updateViewFromModel();
       } else {
           print("chosen card was not in cardButtons");
       }
    }
    
    func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index];
                let card = game.cards[index];
                if (card.isFaceUp) {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal);
                    button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1);
                } else {
                    button.setTitle("", for: UIControl.State.normal);
                    button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : UIColor.blue;
                }
            }
        }
    }
    
    //    private var emojiChoices = ["👻","🎃","🍬","🧺","🐶","🐱","🍏","🍇"];
    private var emojiChoices = "👻🎃🍬🧺🐶🐱🍏🍇";
    private var emoji = [Card:String]();
    var theme: String? {
        didSet {
            emojiChoices = theme ?? "";
            emoji = [:];
            updateViewFromModel();
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil , emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random);
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex));  // remove 는 제거할 것을 리턴한다. remove(at:) 은 range replaceable collection 이다.
        }
        return emoji[card] ?? "?";   // 아래코드와 동일한 작동을 한다.
        //        if emoji[card.identifier] != nil {
        //            return emoji[card.identifier]!
        //        } else {
        //            return "?";
        //        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)));
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))));
        } else {
            return 0;
        }
    }
}

