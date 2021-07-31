//
//  ViewController.swift
//  playingCard-study
//
//  Created by bigzero on 2021/06/01.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck();
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var cards = [PlayingCard]();
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!;
            cards += [card, card];
        }

        for cardView in cardViews {
            cardView.isFaceUp = true;
            let card = cards.remove(at: cards.count.arc4random);
            cardView.rank = card.rank.order;
            cardView.suit = card.suit.rawValue;
            cardView.addGestureRecognizer(UITabGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    @objc func flipCard(_ recognizer: UITabGestureRecognizer) {
        
    }
    
    
//    @IBOutlet weak var playingCardView: PlayingCardView! {
//        didSet {
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard));
//                swipe.direction = [.left,.right];
//            playingCardView.addGestureRecognizer(swipe);
//            let pich = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
//            playingCardView.addGestureRecognizer(pich);
//        }
//    }
    
//    @objc func nextCard() {
//        if let card = deck.draw() {
//            playingCardView.rank = card.rank.order;
//            playingCardView.suit = card.suit.rawValue;
//        }
//
//    }
//
//    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
//        switch sender.state {
//        case .ended:
//            playingCardView.isFaceUp = !playingCardView.isFaceUp;
//        default: break;
//        }
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        for _ in 1...10 {
//            if let card = deck.draw() {
//                print("\(card)");
//
//            }
//        }
//    }
    
    


}

