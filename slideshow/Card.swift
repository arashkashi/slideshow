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
    func moveToLeft(card: Card)
    func moveToright(card: Card)
    func beingDragged(card: Card, offset: CGFloat)
}


class Card: UIView {
    
    var centerXConstraint: NSLayoutConstraint!
    var centerYConstraint: NSLayoutConstraint!
    
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    
    lazy var label: UILabel = {
        
        let label = UILabel()
        return label
    }()
    
    var labelText: String = ""  {
        
        didSet {
            
            self.label.text = self.labelText
        }
    }
    
    var container: UIView?
    
    var originalX: CGFloat!
    
    var delegate: CardDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.label)
        
        label.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        label.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.centerXConstraint.constant = -1 * self.frame.size.width
            self.container?.layoutIfNeeded()
            }) { _ in
                completion?()
        }
    }
    
    func afterSwipAction() {
        
        // If the card is pulled to the left then take it to the left
        if self.centerXConstraint.constant < -1 * self.frame.size.width / 2 {
            
            self.delegate?.moveToLeft(self)
        }
        else if self.centerXConstraint.constant > self.frame.size.width / 2 {
            
            self.delegate?.moveToright(self)
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
            self.delegate?.beingDragged(self, offset: xFromCenter - self.originalX)
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
