//
//  SwipeCardsViewController.swift
//  slideshow
//
//  Created by Arash Kashi on 10/7/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit



class SwipCardsViewController: UIViewController, CardDelegate {
    
    // Stack of cards, 0 index is bottom, higher indexes are top cards
    var deck: [Card] = []
    
    // Stack of card accumulated on the left side
    var leftDeck: [Card] = []
    
    weak var container: UIView?
    
    // Number of cards slided to the left on the top of stack
    static let numberOfSlidedCards: Int = 3
    
    // MARK: View Controller Methods
    override func updateViewConstraints() {
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.leftAnchor.constraintEqualToAnchor(self.container?.leftAnchor).active = true
        self.view.rightAnchor.constraintEqualToAnchor(self.container?.rightAnchor).active = true
        self.view.topAnchor.constraintEqualToAnchor(self.container?.topAnchor).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(self.container?.bottomAnchor).active = true
        
        self.deck.forEach {
        
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.heightConstraint = $0.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor)
            $0.heightConstraint.active = true
            
            $0.widthConstraint = $0.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor)
            $0.widthConstraint.active = true
            
            $0.centerXConstraint = $0.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
            $0.centerXConstraint.active = true
            
            $0.centerYConstraint = $0.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
            $0.centerYConstraint.active = true
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: Card Manipulation
    
    // This function puts all the cards aligned well on top of eachother.
    // The size of the card will be resized to the view controller's view size
    func initCards() {
        
        self.deck.forEach {
            
            self.view.addSubview($0)
            
            $0.container = self.view
            $0.delegate = self
            $0.userInteractionEnabled = false
        }
        
        self.deck.last?.userInteractionEnabled = true
        
        self.updateViewConstraints()
        
        dispatch_after(1, dispatch_get_main_queue()) { 
            self.shuffle()
        }
    }
    
    // Re-organizes the cards so that the last n ones are
    // slightly slided to the left side
    func shuffle() {
        
        let offsets = self.shuffleOffsets(self.deck, eachOffset: 10.0, numberOfSlidedCards: SwipCardsViewController.numberOfSlidedCards)
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            // Slip the top cards to the left
            for (index, offset) in offsets.enumerate() {
                
                let view = self.deck[self.deck.count - 1 - index]
                
                view.centerXConstraint.constant = offset
            }
            
            // Align the bottom cards right on top of each other
            for i in 0 ... self.deck.count - offsets.count - 1 {
                
                let view = self.deck[i]
                
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
            self.shuffle()
        }
    }
    
    // Slides the top view on the deck array to the right
    func slideToRight() {
        
        guard self.leftDeck.count > 0 else { return }
        
        let last = self.leftDeck.removeLast()
        
        last.userInteractionEnabled = true
        
        self.deck.append(last)
        
        self.shuffle()
    }
    
    // MARK: Card Delegates
    
    func moveToLeft(card: Card) {
        
        guard self.deck.first != card else { self.shuffle(); return }
        
        self.slideToLeft()
    }
    
    func moveToright(card: Card) {
        
        guard self.leftDeck.isEmpty == false else { self.shuffle(); return }
        
        let last = self.leftDeck.removeLast()
        last.userInteractionEnabled = true
        
        self.deck.last?.userInteractionEnabled = false
        
        self.deck.append(last)
        
        self.shuffle()
    }
    
    func shuffleDeck(card: Card) {
        
        self.shuffle()
    }
    
    func beingDragged(card: Card, offset: CGFloat) {
        
        // When it is being dragged to right pull the card on left inside
        if offset > 0.0 {
            
            self.leftDeck.last?.centerXConstraint.constant = -1 * card.frame.size.width + offset
        }
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
    
    func attachToContainer(container: UIView) {
        
        self.container = container
        
        container.addSubview(self.view)
        
        self.updateViewConstraints()
    }
    
}