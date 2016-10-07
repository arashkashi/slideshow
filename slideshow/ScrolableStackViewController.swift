//
//  ScrollableStackedViewController.swift
//  StackView
//
//  Created by Arash Kashi on 10/7/16.
//  Copyright © 2016 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func anchorEdges(toSuperView: UIView) {
        
        self.topAnchor.constraintEqualToAnchor(toSuperView.topAnchor).active = true
        self.bottomAnchor.constraintEqualToAnchor(toSuperView.bottomAnchor).active = true
        self.leftAnchor.constraintEqualToAnchor(toSuperView.leftAnchor).active = true
        self.rightAnchor.constraintEqualToAnchor(toSuperView.rightAnchor).active = true
    }
}


class ScrollableStackedViewController: UIViewController {
    
    var stackView: UIStackView = UIStackView()
    var scrollView: UIScrollView = UIScrollView()
    
    weak var container: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .Vertical
        stackView.alignment = .Center
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        for view in self.getMeViews(20) {
            
            stackView.addArrangedSubview(view)
        }
    }
    
    func attachToContainer(container: UIView) {
        
        container.addSubview(self.view)
        
        self.container = container
        
        self.view.anchorEdges(container)
        
        self.updateViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        scrollView.contentSize = stackView.frame.size
    }
    
    override func updateViewConstraints() {
        
        stackView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        
        scrollView.anchorEdges(view)
        
        super.updateViewConstraints()
    }
    
    func newViewWithColor(color: UIColor) -> UIView {
        
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    func getMeViews(numberOfViews: Int) -> [UIView] {
        
        var result: [UIView] = []
        for i in 1 ... numberOfViews {
            
            var color: UIColor!
            
            if i % 3 == 0 { color = UIColor.yellowColor() }
            else if i % 3 == 1 { color = UIColor.brownColor()}
            else { color = UIColor.lightGrayColor() }
            
            let view = self.newViewWithColor(color)
            view.heightAnchor.constraintEqualToConstant(80).active = true
            view.widthAnchor.constraintEqualToConstant(10 * CGFloat(i)).active = true
            
            result.append(view)
        }
        
        return result
    }
}