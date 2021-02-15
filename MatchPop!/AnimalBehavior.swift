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
    fileprivate lazy var collisionBehavior: UICollisionBehavior = {
        let lazy = UICollisionBehavior()
        lazy.collisionMode = UICollisionBehavior.Mode.boundaries
        return lazy
    }() 
    fileprivate let gravityBehavior = UIGravityBehavior()
    fileprivate var pushBeaviors = [UIView:UIPushBehavior]()
    fileprivate lazy var animalBehavior: UIDynamicItemBehavior = {
        let lazy = UIDynamicItemBehavior()
        lazy.allowsRotation = false
        return lazy
    }()
    
    var boundary:CGRect? {
        didSet{
            collisionBehavior.addBoundary(withIdentifier: Constants.Boundaries.Left as NSCopying, from: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y), to: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y + boundary!.size.height))
            collisionBehavior.addBoundary(withIdentifier: Constants.Boundaries.Right as NSCopying, from: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y), to: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y + boundary!.size.height))
            collisionBehavior.addBoundary(withIdentifier: Constants.Boundaries.Top as NSCopying, from: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y), to: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y))
            collisionBehavior.addBoundary(withIdentifier: Constants.Boundaries.Bottom as NSCopying, from: CGPoint(x: boundary!.origin.x, y: boundary!.origin.y + boundary!.size.height), to: CGPoint(x: boundary!.origin.x + boundary!.size.width, y: boundary!.origin.y  + boundary!.size.height))
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
    
    func addView(_ view:UIView){
        addToSuperview(view)
        animalBehavior.addItem(view)
        collisionBehavior.addItem(view)
    }
    
    func removeView(_ view:UIView){
        animalBehavior.removeItem(view)
        collisionBehavior.removeItem(view)
        gravityBehavior.removeItem(view)
        stopContinuousPush(view)
        view.removeFromSuperview()
    }

    func addGravityBehavior(_ view: UIView){
        addToSuperview(view)
        gravityBehavior.addItem(view)
    }
    
    func removeGravityBehavior(_ view: UIView){
        gravityBehavior.removeItem(view)
    }
    
    func continuousPush(_ view:UIView, vector:CGVector){
        addToSuperview(view)
        let behavior = UIPushBehavior(items: [view], mode: UIPushBehavior.Mode.continuous)
        behavior.pushDirection = vector
        addChildBehavior(behavior)
        pushBeaviors[view] = behavior
    }
    
    func instantaneousPush(_ view:UIView, vector:CGVector){
        addToSuperview(view)
        let behavior = UIPushBehavior(items: [view], mode: UIPushBehavior.Mode.instantaneous)
        behavior.pushDirection = vector
        behavior.action = { [unowned behavior] in
            behavior.dynamicAnimator?.removeBehavior(behavior)
        }
        addChildBehavior(behavior)
    }

    
    func stopContinuousPush(_ view:UIView){
        if let behavior = pushBeaviors[view]{
            behavior.removeItem(view)
            removeChildBehavior(behavior)
            pushBeaviors.removeValue(forKey: view)
        }
    }
    
    fileprivate func addToSuperview(_ view:UIView){
        if let superview = dynamicAnimator?.referenceView {
            if !superview.subviews.contains(view){
                superview.addSubview(view)
            }
        }
    }
}
