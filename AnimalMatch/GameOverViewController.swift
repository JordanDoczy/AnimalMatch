//
//  ViewController.swift
//  Balloon
//
//  Created by Jordan Doczy on 11/22/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    private struct Constants{
        struct Segues{
            static let PlayAgain:String = "Play Again"
        }
        struct Selectors{
            static let CreateAnimals:Selector   = "createAnimals:"
            static let PlayAgain:Selector       = "playAgain:"
            static let PopBalloon:Selector      = "popBalloon:"
        }
    }
    
    private var animator:UIDynamicAnimator!
    private let animalBehavior = AnimalBehavior()
    private var balloon:AnimalView?
    private let balloons = [
        Assets.Images.Balloons.Red,
        Assets.Images.Balloons.Orange,
        Assets.Images.Balloons.Yellow,
        Assets.Images.Balloons.Green,
        Assets.Images.Balloons.Blue,
        Assets.Images.Balloons.Purple
    ]
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
    private var imageWidth:CGFloat {
        return view.bounds.width / 10
    }
    private var numberOfImages:Int{
        switch (UserSettings.sharedInstance.difficulty) {
        case UserSettings.Difficulty.Easy: return 6
        case UserSettings.Difficulty.Medium: return 11
        default: return images.count
        }
    }

    private var pops = 0
    private var sounds = [AVAudioPlayer]()
    private let spacer: CGFloat = 5
    
    // MARK : View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(animalBehavior)
        animalBehavior.collisionDelegate = self
        animalBehavior.boundary = CGRect(x: -50, y: -100, width: view.bounds.width + 100, height: view.bounds.height + 300)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.GameOver)!)
        createBalloon("POP THE BALLOONS!")
    }
    
    func createBalloon(text:String, autoPop:Bool = true)->AnimalView{
        
        let balloon = AnimalView()
        balloon.frame.size.width = view.bounds.width / 2
        balloon.balloonAsset = Assets.Images.Balloons.Red
        balloon.center.x = view.center.x
        balloon.frame.origin.y = view.bounds.height
        view.addSubview(balloon)
        
        let label = UILabel()
        label.frame.size.width = balloon.frame.size.width
        label.frame.size.height = 50
        label.frame.origin.y = label.frame.size.height + 20
        label.frame.origin.x = 0
        label.text = text
        label.numberOfLines = 4
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "ChalkboardSE-Light", size: 15)!
        balloon.addSubview(label)
        
        
        UIView.animateWithDuration(2,
            animations: { [unowned self] in
                balloon.frame.origin.y = self.view.bounds.height / 4
            },
            completion: { [unowned self] success in
                if autoPop {
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Constants.Selectors.CreateAnimals, userInfo: balloon, repeats: false)
                }
            }
        )
        
        return balloon
    }
    
    func createAnimals(timer:NSTimer){
        if let balloon = timer.userInfo as? AnimalView{
            balloon.subviews.filter(){ $0 is UILabel }.first?.removeFromSuperview()
            balloon.pop(){
                balloon.removeFromSuperview()
            }
            self.sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
        }
        
        for index in 0..<numberOfImages{
            createAnimal(images[index], yOffset: -CGFloat(randomInt(min: Int(view.bounds.size.height * 0.10), max: Int(view.bounds.size.height * 0.75))))
        }

        timer.invalidate()
    }
    
    func createAnimal(asset:String, yOffset:CGFloat = 0) ->AnimalView{
       
        let randomX = randomInt(min: Int(imageWidth), max: Int(view.bounds.size.width - imageWidth))

        
        let animal = AnimalView(frame: CGRect(origin: CGPoint(x: CGFloat(randomX), y:view.bounds.height + 70 + yOffset), size: CGSize(width: imageWidth, height: imageWidth)))
        animal.animalAsset = asset
        animal.balloonAsset = balloons[randomInt(min: 0, max: balloons.count-1)]
        
        let tap = UITapGestureRecognizer(target: self, action: Constants.Selectors.PopBalloon)
        tap.numberOfTapsRequired = 1
        animal.addGestureRecognizer(tap)
        animalBehavior.addView(animal)
        push(animal)

        return animal
    }
    
    func popBalloon(sender:UITapGestureRecognizer){
        if let animal = sender.view as? AnimalView {
            animal.pop()
            animal.userInteractionEnabled = false
            animal.removeGestureRecognizer(sender)
            sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
            
            switch(animal.animalAsset!){
            case Assets.Images.Animals.Cat:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Cat)!)
            case Assets.Images.Animals.Cow:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Cow)!)
            case Assets.Images.Animals.Hen:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Chicken)!)
            case Assets.Images.Animals.Dog:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Dog)!)
            case Assets.Images.Animals.Donkey:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Donkey)!)
            case Assets.Images.Animals.Rooster:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Rooster)!)
            case Assets.Images.Animals.Sheep:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Sheep)!)
            default:
                sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Whistle)!)
            }
            
            animalBehavior.instantaneousPush(animal, vector: CGVector(dx: 0, dy: -0.75))
            animalBehavior.addGravityBehavior(animal)
            
            pops++
            print (pops)
            if pops == numberOfImages {
                let tap = UITapGestureRecognizer(target: self, action: Constants.Selectors.PlayAgain)
                view.userInteractionEnabled = true
                view.addGestureRecognizer(tap)
                balloon = createBalloon("YOU WIN!\rPLAY AGAIN?", autoPop: false)
            }

        }
    }
    
    func push(animal:AnimalView){
        
        var speed = drand48()
        speed = speed < 0.45 ? 0.45 : speed
        animalBehavior.continuousPush(animal, vector: CGVector(dx: 0, dy: speed * -0.025))
    }
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint){
        
        if let animal = item as? AnimalView{
            let asset = animal.animalAsset!
            animalBehavior.removeView(animal)
            
            if !animal.popped {
                createAnimal(asset)
            }
        }
    }
    
    func randomInt(min min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
    func playAgain(sender:UITapGestureRecognizer){
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
        balloon!.subviews.filter(){ $0 is UILabel }.first?.removeFromSuperview()
        balloon!.pop(){ [unowned self] in
            self.performSegueWithIdentifier(Constants.Segues.PlayAgain, sender: self)
        }
    }
}

