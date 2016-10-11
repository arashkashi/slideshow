//
//  Card.swift
//  slideshow
//
//  Created by Arash Kashi on 10/6/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit



protocol CardDelegate {
    
    func shuffleDeck(card: Card)
    func onMovingToLeft(card: Card)
    func onMovingToRight(card: Card)
    func onBeingDragged(card: Card, offset: CGFloat)
    
    func isAllowedToSlideToright() -> Bool
    func isAllowedToSlideToLeft(card: Card) -> Bool
}



class Card: UIView {
    
    var centerXConstraint: NSLayoutConstraint!
    
    let animationDuration: NSTimeInterval = 0.2
    
    var container: UIView?
    
    private var originalX: CGFloat!
    
    var delegate: CardDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setupPanGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPanGestureRecognizer() {
        
        let panRecognizer = UIPanGestureRecognizer()
        panRecognizer.addTarget(self, action: #selector(beingDragged(_:)))
        addGestureRecognizer(panRecognizer)
    }
    
    func moveToLeft(completion: (() -> ())?) {
        
        UIView.animateWithDuration(self.animationDuration
            , delay: 0
            , options: UIViewAnimationOptions.CurveEaseOut
            , animations: {
            
            self.centerXConstraint.constant = -1 * self.frame.size.width
            self.container?.layoutIfNeeded()
            }) { _ in
                completion?()
        }
    }
    
    func afterSwipAction() {
        
        // If the card is pulled to the left then take it to the left
        if let isMovePermitted = self.delegate?.isAllowedToSlideToLeft(self)
            where isMovePermitted && self.centerXConstraint.constant < -1 * self.frame.size.width / 2 {
            
            self.delegate?.onMovingToLeft(self)
        }
        else if let isMovePermitted = self.delegate?.isAllowedToSlideToright()
            where isMovePermitted && (self.centerXConstraint.constant > self.frame.size.width / 2)
                {
            
            self.delegate?.onMovingToRight(self)
        } else {
            
            self.delegate?.shuffleDeck(self)
        }
    }
    
    func beingDragged(gr:UIPanGestureRecognizer){
        
        let xFromCenter = gr.translationInView(self.superview).x
        
        switch gr.state {
        case .Began:
            self.originalX = gr.translationInView(self.superview).x - self.centerXConstraint.constant
            break
        case .Changed:
            self.centerXConstraint.constant = xFromCenter - self.originalX
            self.delegate?.onBeingDragged(self, offset: xFromCenter - self.originalX)
            break
        case .Ended:
            afterSwipAction()
            break
        case .Possible:break;
        case .Cancelled:break;
        case .Failed:break;
            
        }
    }
}
