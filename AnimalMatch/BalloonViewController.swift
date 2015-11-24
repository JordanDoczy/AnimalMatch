//
//  ViewController.swift
//  Balloon
//
//  Created by Jordan Doczy on 11/22/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

class BalloonViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    private struct Constants{
        struct Selectors{
            static let Tapped:Selector = "tapped:"
        }
    }
    
    private var animator:UIDynamicAnimator!
    private let animalBehavior = AnimalBehavior()
    
    private var sounds = [AVAudioPlayer]()

    private let images = [
        Assets.Images.Animals.Cat,
        Assets.Images.Animals.Cow,
        Assets.Images.Animals.Deer,
        Assets.Images.Animals.Dog,
        Assets.Images.Animals.Donkey,
        Assets.Images.Animals.Elephant,
        Assets.Images.Animals.Fox,
        Assets.Images.Animals.Hen,
        Assets.Images.Animals.Leopard,
        Assets.Images.Animals.Lion,
        Assets.Images.Animals.Monkey,
        Assets.Images.Animals.Orangutan,
        Assets.Images.Animals.Owl,
        Assets.Images.Animals.Panda,
        Assets.Images.Animals.Panther,
        Assets.Images.Animals.Penguin,
        Assets.Images.Animals.Pig,
        Assets.Images.Animals.Rabbit,
        Assets.Images.Animals.Rooster,
        Assets.Images.Animals.Sheep,
        Assets.Images.Animals.Zebra
    ]

    
    let spacer: CGFloat = 5
    var imageWidth:CGFloat {
        return view.bounds.width / 10
    }
    
    // MARK : View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(animalBehavior)
        animalBehavior.collisionDelegate = self
        animalBehavior.boundary = CGRect(x: -200, y: -200, width: view.bounds.width + 400, height: view.bounds.height + 400)
        
        for index in 0..<images.count{
            createAnimal(images[index], yOffset: -CGFloat(randomInt(min: 0, max: Int(view.bounds.size.height))))
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.GameOver)!)
    }
    
    func createAnimal(asset:String, yOffset:CGFloat = 0) ->AnimalView{
       
        let randomX = randomInt(min: 0, max: Int(view.bounds.size.width))

        
        let animal = AnimalView(frame: CGRect(origin: CGPoint(x: CGFloat(randomX), y:view.bounds.height + 75 + yOffset), size: CGSize(width: imageWidth, height: imageWidth)))
        animal.animalAsset = asset
        animal.balloonAsset = Assets.Images.Balloons.Red

        let tap = UITapGestureRecognizer(target: self, action: Constants.Selectors.Tapped)
        tap.numberOfTapsRequired = 1
        animal.addGestureRecognizer(tap)
        animalBehavior.addView(animal)
        push(animal)

        return animal
    }
    
    func tapped(sender:UITapGestureRecognizer){
        if let animal = sender.view as? AnimalView {
            animal.pop()
            sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
            
            switch(animal.animalAsset!){
            case Assets.Images.Animals.Cow:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Cow)!)
            case Assets.Images.Animals.Hen:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Chicken)!)
            case Assets.Images.Animals.Rooster:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Rooster)!)
            default:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Whistle)!)
            }
            
            animalBehavior.instantaneousPush(animal, vector: CGVector(dx: 0, dy: -0.75))
            animalBehavior.addGravityBehavior(animal)
        }
    }
    
    func push(animal:AnimalView){
        
        let sign = drand48() >= 0.5 ? 1.0 : -1.0
        
        
        animalBehavior.continuousPush(animal, vector: CGVector(dx: 0, dy: drand48() * -0.025))
        animalBehavior.continuousPush(animal, vector: CGVector(dx: drand48() * 0.004 * sign, dy: 0))
    }
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if let animal = item as? AnimalView{
            let asset = animal.animalAsset!
            animalBehavior.removeView(animal)
            createAnimal(asset)
        }
    }
    
    func randomInt(min min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

