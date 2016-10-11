//
//  Coordinator.swift
//  slideshow
//
//  Created by Arash Kashi on 10/10/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit




class Coordinator {
    
    let imageStack: SwipCardsViewController
    let textStack: SlidableScrollableTextContent
    
    init(imageStack: SwipCardsViewController, textStack: SlidableScrollableTextContent ) {
        
        self.imageStack = imageStack
        self.textStack = textStack
        
        assert(imageStack.deck.count == textStack.deck.count)
        
        imageStack.delegate = self
    }
}



extension Coordinator: SwipCardsViewControllerDelegate {
    
    func onTopItemBeingDragged(normalizedOffset: CGFloat) {
        
        self.textStack.moveTopItemHorizontally(-1 * normalizedOffset)
    }
    
    func onTopItemWillSlideToLeft() {
        
        self.textStack.slideTopToLeft()
    }
    
    func onTopItemWillSlideToRight() {
        
        self.textStack.slideTopToRight()
    }
    
    func onTopItemWillReturnToCenter() {
        
        UIView.animateWithDuration(self.textStack.animationDuration) {
            self.textStack.moveTopItemHorizontally(0)
        }
    }
}



