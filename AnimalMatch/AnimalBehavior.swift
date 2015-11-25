//
//  AnimalBehavior.swift
//  Balloon
//
//  Created by Jordan Doczy on 11/22/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit

class AnimalBehavior : UIDynamicBehavior {
    
    struct Constants{
        struct Boundaries{
            static let Bottom   = "bottom"
            static let Left     = "left"
            static let Right    = "right"
            static let Top      = "top"
        }
    }
    private lazy var collisionBehavior: UICollisionBehavior = {
        let lazy = UICollisionBehavior()
        lazy.collisionMode = UICollisionBehaviorMode.Boundaries
        return lazy
    }() 
    private let gravityBehavior = UIGravityBehavior()
    private var pushBeaviors = [UIView:UIPushBehavior]()
    private lazy var animalBehavior: UIDynamicItemBehavior = {
        let lazy = UIDynamicItemBehavior()
        lazy.allowsRotation = false
        return lazy
    }()
    
    var boundary:CGRect? {
        didSet{
            collisionBehavior.addBoundaryWithIdentifier(Constants.Boundaries.Left, fromPoint: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y), toPoint: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y + boundary!.size.height))
            collisionBehavior.addBoundaryWithIdentifier(Constants.Boundaries.Right, fromPoint: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y), toPoint: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y + boundary!.size.height))
            collisionBehavior.addBoundaryWithIdentifier(Constants.Boundaries.Top, fromPoint: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y), toPoint: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y))
            collisionBehavior.addBoundaryWithIdentifier(Constants.Boundaries.Bottom, fromPoint: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y + boundary!.size.height), toPoint: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y  + boundary!.size.height))
        }
    }
    
    var collisionDelegate:UICollisionBehaviorDelegate? {
        get{
            return collisionBehavior.collisionDelegate
        }
        set{
            collisionBehavior.collisionDelegate = newValue
        }
    }
    
    override init(){
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(gravityBehavior)
        addChildBehavior(animalBehavior)
    }
    
    func addView(view:UIView){
        addToSuperview(view)
        animalBehavior.addItem(view)
        collisionBehavior.addItem(view)
    }
    
    func removeView(view:UIView){
        animalBehavior.removeItem(view)
        collisionBehavior.removeItem(view)
        gravityBehavior.removeItem(view)
        stopContinuousPush(view)
        view.removeFromSuperview()
    }

    func addGravityBehavior(view: UIView){
        addToSuperview(view)
        gravityBehavior.addItem(view)
    }
    
    func removeGravityBehavior(view: UIView){
        gravityBehavior.removeItem(view)
    }
    
    func continuousPush(view:UIView, vector:CGVector){
        addToSuperview(view)
        let behavior = UIPushBehavior(items: [view], mode: UIPushBehaviorMode.Continuous)
        behavior.pushDirection = vector
        addChildBehavior(behavior)
        pushBeaviors[view] = behavior
    }
    
    func instantaneousPush(view:UIView, vector:CGVector){
        addToSuperview(view)
        let behavior = UIPushBehavior(items: [view], mode: UIPushBehaviorMode.Instantaneous)
        behavior.pushDirection = vector
        behavior.action = { [unowned behavior] in
            behavior.dynamicAnimator?.removeBehavior(behavior)
        }
        addChildBehavior(behavior)
    }

    
    func stopContinuousPush(view:UIView){
        if let behavior = pushBeaviors[view]{
            behavior.removeItem(view)
            removeChildBehavior(behavior)
            pushBeaviors.removeValueForKey(view)
        }
    }
    
    private func addToSuperview(view:UIView){
        if let superview = dynamicAnimator?.referenceView {
            if !superview.subviews.contains(view){
                superview.addSubview(view)
            }
        }
    }
}