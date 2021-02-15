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

    fileprivate struct Constants{
        struct Segues{
            static let PlayAgain:String = "Play Again"
        }
        struct Selectors{
            static let CreateAnimals:Selector   = #selector(GameOverViewController.createAnimals(_:))
            static let PlayAgain:Selector       = #selector(GameOverViewController.playAgain(_:))
            static let PopBalloon:Selector      = #selector(GameOverViewController.popBalloon(_:))
        }
    }
    
    // MARK: Private Members
    fileprivate let animalBehavior = AnimalBehavior()
    fileprivate var animator:UIDynamicAnimator!
    fileprivate var balloon:BalloonView?
    fileprivate let balloons = [
        Assets.Images.Balloons.Red,
        Assets.Images.Balloons.Orange,
        Assets.Images.Balloons.Yellow,
        Assets.Images.Balloons.Green,
        Assets.Images.Balloons.Blue,
        Assets.Images.Balloons.Purple
    ]
    fileprivate let images = [
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
    fileprivate var imageWidth:CGFloat {
        return view.bounds.width / 10
    }
    fileprivate var numberOfImages:Int{
        switch (UserSettings.sharedInstance.difficulty) {
        case UserSettings.Difficulty.easy: return 6
        case UserSettings.Difficulty.medium: return 11
        default: return images.count
        }
    }
    fileprivate var pops = 0
    fileprivate let spacer: CGFloat = 5
    fileprivate var sounds = [AVAudioPlayer]()
    
    // MARK : View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(animalBehavior)
        animalBehavior.collisionDelegate = self
        animalBehavior.boundary = CGRect(x: -50, y: -100, width: view.bounds.width + 100, height: view.bounds.height + 300)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.GameOver)!)
        _ = createBalloon("POP THE BALLOONS!")
    }
    
    // MARK: Public Methods
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint){
        
        if let animal = item as? BalloonView{
            let asset = animal.animalAsset!
            animalBehavior.removeView(animal)
            
            if !animal.popped {
                _ = createAnimal(asset)
            }
        }
    }
    
    func createAnimal(_ asset:String, yOffset:CGFloat = 0) ->BalloonView{
        
        let randomX = randomInt(min: Int(imageWidth), max: Int(view.bounds.size.width - imageWidth))
        let animal = BalloonView(frame: CGRect(origin: CGPoint(x: CGFloat(randomX), y:view.bounds.height + 70 + yOffset), size: CGSize(width: imageWidth, height: imageWidth)))
        animal.animalAsset = asset
        animal.balloonAsset = balloons[randomInt(min: 0, max: balloons.count-1)]
        
        let tap = UITapGestureRecognizer(target: self, action: Constants.Selectors.PopBalloon)
        tap.numberOfTapsRequired = 1
        animal.addGestureRecognizer(tap)
        animalBehavior.addView(animal)
        push(animal)
        
        return animal
    }

    @objc func createAnimals(_ timer:Timer){

        if let balloon = timer.userInfo as? BalloonView{
            balloon.subviews.filter(){ $0 is UILabel }.first?.removeFromSuperview()
            balloon.pop(){
                balloon.removeFromSuperview()
            }
            self.sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
        }
        
        for index in 0..<numberOfImages{
            _ = createAnimal(images[index], yOffset: -CGFloat(randomInt(min: Int(view.bounds.size.height * 0.10), max: Int(view.bounds.size.height * 0.75))))
        }
        
        timer.invalidate()
    }

    func createBalloon(_ text:String, autoPop:Bool = true)->BalloonView{
        
        let balloon = BalloonView()
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
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "ChalkboardSE-Light", size: 15)!
        balloon.addSubview(label)
        
        
        UIView.animate(withDuration: 2,
            animations: { [unowned self] in
                balloon.frame.origin.y = self.view.bounds.height / 4
            },
            completion: { [unowned self] success in
                if autoPop {
                    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Constants.Selectors.CreateAnimals, userInfo: balloon, repeats: false)
                }
            }
        )
        
        return balloon
    }
    
    @objc func popBalloon(_ sender:UITapGestureRecognizer){
        if let animal = sender.view as? BalloonView {
            animal.pop()
            animal.isUserInteractionEnabled = false
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
            
            pops += 1
            if pops == numberOfImages {
                let tap = UITapGestureRecognizer(target: self, action: Constants.Selectors.PlayAgain)
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(tap)
                balloon = createBalloon("YOU WIN!\rPLAY AGAIN?", autoPop: false)
            }

        }
    }
    
    @objc func playAgain(_ sender:UITapGestureRecognizer){
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Pop)!)
        balloon!.subviews.filter(){ $0 is UILabel }.first?.removeFromSuperview()
        balloon!.pop(){ [unowned self] in
            self.performSegue(withIdentifier: Constants.Segues.PlayAgain, sender: self)
        }
    }
    
    func push(_ animal:BalloonView){
        
        var speed = drand48()
        speed = speed < 0.45 ? 0.45 : speed
        animalBehavior.continuousPush(animal, vector: CGVector(dx: 0, dy: speed * -0.025))
    }
    
    
    
    // MARK: Private Methods
    fileprivate func randomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

}

