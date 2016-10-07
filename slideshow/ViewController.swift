//
//  ViewController.swift
//  slideshow
//
//  Created by Arash Kashi on 10/6/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardDelegate {
    
    var deck: [Card] = []
    
    var leftDeck: [Card] = []
    
    var initiation: Bool = false
    
    @IBOutlet var container: UIView!
    
    func newViewWithColor(color: UIColor) -> Card {
        
        let view = Card()
        view.backgroundColor = color
        return view
    }
    
    func getMeViews(numberOfViews: Int) -> [Card] {
        
        var result: [Card] = []
        for i in 1 ... numberOfViews {
            
            var color: UIColor!
            
            if i % 3 == 0 { color = UIColor.yellowColor() }
            else if i % 3 == 1 { color = UIColor.brownColor()}
            else { color = UIColor.lightGrayColor() }
            
            result.append(self.newViewWithColor(color))
        }
        
        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deck = self.getMeViews(8)
        
        self.initCards(self.deck, in: self.container)
    }
    
    // This function puts all the cards aligned well on top of eachother.
    func initCards(views: [Card], in container: UIView) {

        var counter: Int = 0
        views.forEach {
            self.container.addSubview($0)
            
            $0.container = container
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.heightConstraint = $0.heightAnchor.constraintEqualToConstant(180)
            $0.heightConstraint.active = true

            $0.widthConstraint = $0.widthAnchor.constraintEqualToConstant(200)
            $0.widthConstraint.active = true
            
            $0.centerXConstraint = $0.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor)
            $0.centerXConstraint.active = true
            
            $0.centerYConstraint = $0.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor)
            $0.centerYConstraint.active = true
            
            $0.delegate = self
            $0.userInteractionEnabled = false
            
            if self.initiation == false { $0.labelText = "\(counter)" } else {}
            counter = counter + 1
        }
        
        if self.initiation == false { self.initiation = true }
        
        self.deck.last?.userInteractionEnabled = true
    }
    
    // Re-organizes the view so that the last three ones are
    // slightly slided on top of each other.
    func shuffleDeck(views: [Card], numberOfSlidedCards: Int) {
        
        let offsets = self.shuffleOffsets(views, eachOffset: 10.0, numberOfSlidedCards: 3)
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            // Slip the top cards
            for (index, offset) in offsets.enumerate() {
                
                let view = views[views.count - 1 - index]
                
                view.centerXConstraint.constant = offset
            }
            
            // Align the bottom cards
            for i in 0 ... views.count - offsets.count - 1 {
                
                let view = views[i]
                
                view.centerXConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
            
            // Align the left deck cards
            
            for card in self.leftDeck {
                
                card.moveToLeft(nil)
            }
            }) { _ in }
    }
    
    // Slides the top view on the deck array to the left
    func slideToLeft() {
        
        guard self.deck.count > 1 else { return }
        
        let last = self.deck.removeLast()
        
        last.userInteractionEnabled = false
        self.deck.last?.userInteractionEnabled = true
        
        last.moveToLeft { 
            
            self.leftDeck.append(last)
            self.shuffleDeck(self.deck, numberOfSlidedCards: 3)
        }
    }
    
    // Slides the top view on the deck array to the right
    func slideToRight() {
        
        guard self.leftDeck.count > 0 else { return }
        
        let last = self.leftDeck.removeLast()
        
        last.userInteractionEnabled = true
        
        self.deck.append(last)
        
        self.shuffleDeck(self.deck, numberOfSlidedCards: 3)
    }
    
    
    @IBAction func slideToLeft(sender: AnyObject) {
    
        self.slideToLeft()
    }
    
    @IBAction func slideToRight(sender: AnyObject) {
        
        self.slideToRight()
    }
    
    @IBAction func shuffle(sender: AnyObject) {
        
        self.shuffleDeck(self.deck, numberOfSlidedCards: 3)
    }
    
    // MARK: Helpers
    
    func shuffleOffsets(views: [Card], eachOffset: CGFloat, numberOfSlidedCards: Int) -> [CGFloat] {
        
        var offsets: [CGFloat] = []
        
        for i in 0 ... numberOfSlidedCards - 1 {
            
            guard views.count > i + 1 else { break }
            
            offsets.append(0)
            
            for j in 0 ... i {
                
                offsets[j] = offsets[j] + eachOffset
            }
        }
        return offsets.map { $0 * -1 }
    }
    
    // MARK: Card Delegates
    
    func moveToLeft(card: Card) {
        
        guard self.deck.first != card else { self.shuffleDeck(self.deck, numberOfSlidedCards: 3); return }
        
        self.slideToLeft()
    }
    
    func moveToright(card: Card) {
        
        guard self.leftDeck.isEmpty == false else { self.shuffleDeck(self.deck, numberOfSlidedCards: 3); return }
        
        let last = self.leftDeck.removeLast()
        last.userInteractionEnabled = true
        
        self.deck.last?.userInteractionEnabled = false
        
        self.deck.append(last)
        
        self.shuffleDeck(self.deck, numberOfSlidedCards: 3)
    }
    
    func shuffleDeck(card: Card) {
        
        self.shuffleDeck(self.deck, numberOfSlidedCards: 3)
    }
    
    func beingDragged(card: Card, offset: CGFloat) {
        
        // When it is being dragged to right pull the card on left inside
        if offset > 0.0 {
            
            self.leftDeck.last?.centerXConstraint.constant = -1 * card.frame.size.width + offset
        }
    }
}


