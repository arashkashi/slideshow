//
//  ViewController.swift
//  slideshow
//
//  Created by Arash Kashi on 10/6/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck: [Card] = []
    
    var leftDeck: [Card] = []
    
    var initiation: Bool = false
    
    @IBOutlet var container: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deck = Global.getMeViews(8)
        
//        self.initCards(self.deck, in: self.container)
        
        let vc = SwipCardsViewController()
    
        vc.attachToContainer(self.container)
        vc.deck = Global.getMeViews(8)
        vc.initCards()
    }
    
}


