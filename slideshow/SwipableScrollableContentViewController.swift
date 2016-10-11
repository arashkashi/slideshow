//
//  SlidableScrolableTextContent.swift
//  slideshow
//
//  Created by Arash Kashi on 10/7/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit



class SwipableScrollableContentViewController: UIViewController {
    
    var deck: [ScrollableStackedViewController] = []
    
    var leftDeck: [ScrollableStackedViewController] = []
    
    let animationDuration: NSTimeInterval = 0.2
    
    weak var container: UIView?
    
    override func updateViewConstraints() {
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        guard (self.container != nil) else { return }
        
        self.view.leftAnchor.constraintEqualToAnchor(self.container?.leftAnchor).active = true
        self.view.rightAnchor.constraintEqualToAnchor(self.container?.rightAnchor).active = true
        self.view.topAnchor.constraintEqualToAnchor(self.container?.topAnchor).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(self.container?.bottomAnchor).active = true
        
        self.deck.forEach {
            
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            
            $0.view.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
            $0.view.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
            
            if $0.centerXConstraint == nil {
                
                $0.centerXConstraint = $0.view.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
                $0.centerXConstraint.active = true
            }
            
            $0.view.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        }
        
        super.updateViewConstraints()
    }
    
    func add(item: ScrollableStackedViewController) {
        
        self.deck.append(item)
        self.initSubViews()
    }
    
    func initSubViews() {
        
        for vc in self.deck {
            
            guard vc.view.superview == nil else { continue }
            
            self.view.addSubview(vc.view)
            vc.container = self.view
            
            if vc != self.deck.last {
                
                vc.view.alpha = 0.0
            }
        }
        
        self.updateViewConstraints()
    }
    
    func slideTopToLeft() {
        
        guard self.deck.count > 1 else { return }
        
        let last = self.deck.removeLast()
        
        last.moveViewToLeft {
            
            self.leftDeck.append(last)
        }
        
        self.deck.last?.fadeViewIn(nil)
    }
    
    
    func slideTopToRight() {
        
        guard self.leftDeck.count > 0 else { return }
        
        let last = self.leftDeck.removeLast()
        last.moveViewToRight(nil)
        
        self.deck.last?.fadeViewOut(nil)
        self.deck.append(last)
    }
    
    func attachToContainer(container: UIView, withViews: [ScrollableStackedViewController]) {
        
        self.deck = withViews
        self.initSubViews()
        
        self.container = container
        
        container.addSubview(self.view)
        
        self.updateViewConstraints()
    }
    
    func moveTopItemHorizontally(normalizedOffset: CGFloat) {
        
        // Move the top one to the left
        guard let validTopItem = self.deck.last else { return }
        
        // Move to left just when is being slided to the left
        if normalizedOffset >= 0.0 {
            
            validTopItem.moveCenterXTo(normalizedOffset)
            
            // Change the Alpha value for the underlying item
            if self.deck.count > 1 {
                
                let secondLastItem = self.deck[self.deck.count - 1 - 1]
                secondLastItem.view.alpha = abs(normalizedOffset)
            }
        } else // If moving right bring the other object into the view
        {
            guard let validLeftItem = self.leftDeck.last else { return }
            
            validLeftItem.moveCenterXTo(1.0 - normalizedOffset)
            
            validTopItem.view.alpha = 1 - abs(normalizedOffset)
        }
        
        validTopItem.view.superview?.setNeedsLayout()
    }
}
