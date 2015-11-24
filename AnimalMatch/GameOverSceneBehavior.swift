//
//  DropitBehavior.swift
//  Dropit
//
//  Created by Jordan Doczy on 11/7/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit

class GameOverSceneBehavior: UIDynamicBehavior {
    
    
    private lazy var collider: UICollisionBehavior = {
        let lazy = UICollisionBehavior()
        lazy.translatesReferenceBoundsIntoBoundary = true
        return lazy
    }()
    
    private lazy var animalBehavior: UIDynamicItemBehavior = {
       let lazy = UIDynamicItemBehavior()
        lazy.density = 1
        //lazy.elasticity = 0.8
        return lazy
    }()

    private lazy var gravity: UIGravityBehavior = {
        let lazy = UIGravityBehavior()
        //lazy.gravityDirection = CGVectorMake(0, -1.25)
        lazy.gravityDirection = CGVectorMake(0, 0.25)
        return lazy
    }()
    
    
//    func addBarrier (path:UIBezierPath, named name:String){
//        collider.removeBoundaryWithIdentifier(name)
//        collider.addBoundaryWithIdentifier(name, forPath: path)
//    }

    override init(){
        super.init()
        
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(animalBehavior)
    }
    
    func addAnimal(animal: AnimalView){
        gravity.addItem(animal)
        collider.addItem(animal)
        animalBehavior.addItem(animal)
                
    }
 
    func removeAnimal(animal: AnimalView){
        gravity.removeItem(animal)
        collider.removeItem(animal)
        animalBehavior.removeItem(animal)
    }

}
