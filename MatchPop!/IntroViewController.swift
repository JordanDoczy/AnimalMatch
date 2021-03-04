//
//  IntroViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

class IntroViewController: UIViewController {
    
    fileprivate struct Constants{
        struct Segues{
            static let NewGame = "New Game"
            static let Settings = "Show Settings"
        }
        struct Selectors{
            static let PandaTapped:Selector = #selector(IntroViewController.pandaTapped(_:))
        }
    }

    // MARK: Private Members
    fileprivate var background: UIImageView!
    fileprivate var cancellables: Set<AnyCancellable> = []
    fileprivate var cloud1: UIImageView!
    fileprivate var cloud2: UIImageView!
    fileprivate var foreground: UIImageView!
    fileprivate var loaded = false
    fileprivate var mountains: UIImageView!
    fileprivate var sounds = [AVAudioPlayer]()
    

    // MARK: IBOutlets
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.alpha = 0
        startButton.alpha = 0
        titleLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loaded {
            animateIn()
            sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Intro)!)
            loaded = true
        }
        animateClouds()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier{
            switch(identifier){
            
            case Constants.Segues.Settings:
                cloud1?.removeFromSuperview()
                cloud2?.removeFromSuperview()
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    fileprivate func createImageView(_ imageName:String) ->UIImageView{
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(origin: CGPoint(x:0, y:view.bounds.height), size: CGSize(width: view.bounds.width, height: view.bounds.width * imageView.image!.size.height / imageView.image!.size.width))
        return imageView
    }
    
    // MARK: Handlers
    @objc func pandaTapped(_ sender:UITapGestureRecognizer){
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Giggle)!)
    }

    
    // MARK: Animate Methods
    func animateClouds(){
        
        func cloud1Animation(){
            cloud1?.removeFromSuperview()
            cloud1 = UIImageView(image: UIImage(named:Assets.Images.Scenery.Cloud))
            
            let imageWidth:CGFloat = 120
            let imageHeight = imageWidth * cloud1.image!.size.height / cloud1.image!.size.width
            
            cloud1.frame = CGRect(origin: CGPoint(x:view.bounds.width, y: 0+imageHeight), size: CGSize(width: imageWidth, height: imageHeight))
            view.addSubview(cloud1)
            
            UIView.animationPublisher(withDuration: 20, delay: 0.5, options: [UIView.AnimationOptions.curveLinear, UIView.AnimationOptions.repeat]) { [unowned self] in
                cloud1.center.x = 0 - cloud1.bounds.size.width - 50
            }
            .sink(receiveValue: { [unowned self] _ in
                cloud1.center.x = view.bounds.width
                   })
            .store(in: &cancellables)
        }
        
        func cloud2Animation() {
            cloud2?.removeFromSuperview()
            cloud2 = UIImageView(image: UIImage(named:Assets.Images.Scenery.Cloud))
            
            let imageWidth:CGFloat = 60
            let imageHeight = imageWidth * cloud2.image!.size.height / cloud1.image!.size.width
            
            cloud2.frame = CGRect(origin: CGPoint(x:0-imageWidth, y: 0+imageHeight+80), size: CGSize(width: imageWidth, height: imageHeight))
            view.addSubview(cloud2)
            
            UIView.animationPublisher(withDuration: 15, delay: 0.5, options: [UIView.AnimationOptions.curveLinear, UIView.AnimationOptions.repeat]) { [unowned self] in
                cloud2.center.x = view.bounds.width + 50
            }
            .sink(receiveValue: { [unowned self] _ in
                cloud2.center.x = 0 - imageWidth
           })
            .store(in: &cancellables)
        }

        cloud1Animation()
        cloud2Animation()
    }
    
    func animateIn(){
        foreground = createImageView(Assets.Images.Scenery.Foreground)
        view.addSubview(foreground)
        view.sendSubviewToBack(foreground)
        
        background = createImageView(Assets.Images.Scenery.Background)
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        mountains = UIImageView(image: UIImage(named: Assets.Images.Scenery.Mountains))
        var imageWidth = background.bounds.width/2
        var imageHeight = background.bounds.width/2 * mountains.image!.size.height / mountains.image!.size.width
        mountains.frame = CGRect(origin: CGPoint(x: view.bounds.width - imageWidth,
                                                 y: background.center.y - imageHeight),
                                 size: CGSize(width: imageWidth,
                                              height: imageHeight))

        view.addSubview(mountains)
        view.sendSubviewToBack(mountains)
        
        let panda = UIImageView(image: UIImage(named: Assets.Images.Animals.Panda))
        imageWidth = 50
        imageHeight = imageWidth * panda.image!.size.height / panda.image!.size.width
        
        panda.frame = CGRect(origin: CGPoint(x:20, y: view.bounds.height), size: CGSize(width: imageWidth, height: imageHeight))
        view.addSubview(panda)
        
        let tapGesture = UITapGestureRecognizer(target:self, action:Constants.Selectors.PandaTapped);
        panda.isUserInteractionEnabled = true
        panda.addGestureRecognizer(tapGesture)


        UIView.animationPublisher(withDuration: 0.4) { [unowned self] in
            foreground.center.y -= foreground.bounds.size.height
        }
        .flatMap { [unowned self] _ in
            return UIView.animationPublisher(withDuration: 0.3,
                                             delay: 0,
                                             usingSpringWithDamping: 0.5,
                                             initialSpringVelocity: 10.0,
                                             options: UIView.AnimationOptions.curveEaseOut) {
                background.center.y -= background.bounds.size.height
            }
        }
        .flatMap { [unowned self] _ in
            return UIView.animationPublisher(withDuration: 0.3,
                                             delay: 0.05,
                                             usingSpringWithDamping: 0.5,
                                             initialSpringVelocity: 10.0,
                                             options: UIView.AnimationOptions.curveLinear) {
                mountains.center.y -= imageHeight/2
            }
        }
        .flatMap { [unowned self] _ in
            return UIView.animationPublisher(withDuration: 0.4, delay: 0) {
                startButton.alpha = 1
                titleLabel.alpha = 1
                settingsButton.alpha = 1
            }
        }
        .flatMap { [unowned self] _ in
            return UIView.animationPublisher(withDuration: 0.5,
                                             delay: 0.25,
                                             usingSpringWithDamping: 0.95,
                                             initialSpringVelocity: 20,
                                             options: UIView.AnimationOptions.curveLinear) {
                panda.center.y = foreground.center.y - imageHeight + 10
            }
        }
        .sink(receiveValue:
                { isCompleted in
                    print("done")
                })
        .store(in: &cancellables)
    }
}
