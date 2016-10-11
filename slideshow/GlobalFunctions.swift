//
//  GlobalFunctions.swift
//  slideshow
//
//  Created by Arash Kashi on 10/7/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit

class Global {
    
    static func newViewWithColor(color: UIColor) -> SwipableView {
        
        let view = SwipableView()
        view.backgroundColor = color
        return view
    }
    
    static func getMeViews(numberOfViews: Int) -> [SwipableView] {
        
        var result: [SwipableView] = []
        for i in 1 ... numberOfViews {
            
            var color: UIColor!
            
            if i % 3 == 0 { color = UIColor.yellowColor() }
            else if i % 3 == 1 { color = UIColor.brownColor()}
            else { color = UIColor.lightGrayColor() }
            
            result.append(newViewWithColor(color))
        }
        
        return result
    }
    
    static func stackViewController(numberOfViews: Int = 8) -> [ScrollableStackedViewController] {
        
        var result: [ScrollableStackedViewController] = []
        
        for _ in 1 ... numberOfViews {
            
            result.append(ScrollableStackedViewController())
        }
        
        return result
        
    }
}
