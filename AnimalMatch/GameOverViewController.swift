//
//  GameOverViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/19/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

//import UIKit
//import AVFoundation
//
//class GameOverViewController: UIViewController, UIDynamicAnimatorDelegate {
//
//    private lazy var animator: UIDynamicAnimator = { [unowned self] in
//        let lazy = UIDynamicAnimator(referenceView: self.view)
//        lazy.delegate = self
//        return lazy
//        }()
//
//    private var audioPlayer:AVAudioPlayer?
//    private var behavior = GameOverSceneBehavior()
//    private var timers = [NSTimer]()
//    private var pressTime:NSDate?
//    private var lastAnimalPressed:AnimalView?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        animator.addBehavior(behavior)
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//
//        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.GameOver)
//
//        let images = [Assets.Images.Animals.Zebra, Assets.Images.Animals.Pig, Assets.Images.Animals.Panda, Assets.Images.Animals.Donkey, Assets.Images.Animals.Monkey, Assets.Images.Animals.Fox, Assets.Images.Animals.Cow]
//        let spacer:CGFloat = 5.0
//        var animalWidth:CGFloat {
//            return ( (view.bounds.width - (spacer * CGFloat(images.count + 1)) ) / CGFloat(images.count))
//        }
//        
//        for index in 0..<images.count{
//            let image = images[index]
//            let frame = CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0))
//            
//            let animal = AnimalView(frame: frame, imageName: image)
//            animal.frame.size = CGSize(width: animalWidth, height: animalWidth * animal.image!.size.height / animal.image!.size.width)
//            animal.frame.origin = CGPoint(x: spacer + (CGFloat(index) * (animal.frame.size.width + spacer)) , y: view.bounds.height - animal.frame.size.height - spacer)
//            
//            let longPress = UILongPressGestureRecognizer(target: self, action: "pressed:")
//            longPress.minimumPressDuration = 0.15
//            
//            animal.userInteractionEnabled = true
//            animal.addGestureRecognizer(longPress)
//            view.addSubview(animal)
//        }
//        
//    }
//    
//    func push(animal:AnimalView, amount:Double = -1){
//        let pushBehavior = UIPushBehavior(items: [animal], mode: UIPushBehaviorMode.Instantaneous)
//        pushBehavior.pushDirection = CGVector(dx: 0, dy: amount)
//        pushBehavior.action = { [unowned pushBehavior] in
//            pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
//        }
//        animator.addBehavior(pushBehavior)
//    }
//
//
//    func addAnimalToAnimator(animal:AnimalView) {
//        behavior.addAnimal(animal)
//    }
//
//    func removeAnimal(timer:NSTimer) {
//        if let animalView = timer.userInfo as? AnimalView{
//            behavior.removeAnimal(animalView)
//            animalView.removeFromSuperview()
//        }
//
//        timer.invalidate()
//        timers.removeAtIndex(timers.indexOf(timer)!)
//   }
//    
//    
//    func pressed(sender: UILongPressGestureRecognizer){
//        
//        switch(sender.state){
//        case UIGestureRecognizerState.Began:
//            pressTime = NSDate()
//            if let animal = sender.view as? AnimalView{
//                behavior.removeAnimal(animal)
//                animal.squat()
//                lastAnimalPressed = animal
//            }
//        case UIGestureRecognizerState.Ended:
//            var time = NSDate().timeIntervalSinceDate(pressTime!)
//            time *= 2
//            if let animal = sender.view as? AnimalView {
//                if animal == lastAnimalPressed{
//                    animal.reset()
//                    addAnimalToAnimator(animal)
//                    push(animal, amount: time <= 2 ? -time : -2)
//                    audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Wee)
//                }
//            }
//            
//        default: break
//        }
//            
//    }
//    
//    
//    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
//        _ = view.subviews.map() {
//            if let view = $0 as? AnimalView {
//                view.animate()
//            }
//        }
//    }
//
//}


