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
    
    let vc = SwipCardsViewController()
    
    @IBOutlet var container: UIView!
    @IBOutlet var bottomContainer: UIView!
    

    var counter: Int = 0
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        vc.attachToContainer(self.container, withViews: [])//Global.getMeViews(4))

        vcc.attachToContainer(self.bottomContainer, withViews: [])//Global.stackViewController(4))
        
        self.coordinator = Coordinator(imageStack: vc, textStack: vcc)
    }
    
    @IBAction func onButton(sender: AnyObject) {
        
//        self.vc.slideTopToLeft()
        self.vc.add(Global.getMeViews(19)[self.counter])
        counter = counter + 1
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        
        self.vcc.add(Global.stackViewController(10)[self.counter])
        counter = counter + 1
    }
}


