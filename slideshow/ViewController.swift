//
//  ViewController.swift
//  slideshow
//
//  Created by Arash Kashi on 10/6/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var vcc = SwipableScrollableContentViewController()
    var coordinator: Coordinator!
    
    @IBOutlet var container: UIView!
    @IBOutlet var bottomContainer: UIView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let vc = SwipCardsViewController()
    
        vc.attachToContainer(self.container, withViews: Global.getMeViews(4))

        vcc.attachToContainer(self.bottomContainer, withViews: Global.stackViewController(4))
        
        self.coordinator = Coordinator(imageStack: vc, textStack: vcc)
    }
    
    @IBAction func onButton(sender: AnyObject) {
        
        self.vcc.moveTopItemHorizontally(0.2)
        
//        vcc.slideTopToLeft()
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        
        vcc.slideTopToLeft()
    }
    
}


