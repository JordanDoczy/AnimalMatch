//
//  IntroViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

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
            animateForeground()
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
    func pandaTapped(_ sender:UITapGestureRecognizer){
        sounds.append(AVAudioPlayer.playSound(Assets.Sounds.Giggle)!)
    }

    
    // MARK: Animate Methods
    func animateBackground(){
    
        background = createImageView(Assets.Images.Scenery.Background)
        view.addSubview(background)
        view.sendSubview(toBack: background)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.curveEaseOut,
            animations: { [unowned self] in
                self.background.center.y -= self.background.bounds.size.height
            },
            completion: { [unowned self] finished in
                self.animateMoutains(self.background)
            }
        )
    }
    
    func animateClouds(){
        
        func cloud1Animation(){
            cloud1?.removeFromSuperview()
            cloud1 = UIImageView(image: UIImage(named:Assets.Images.Scenery.Cloud))
            
            let imageWidth:CGFloat = 120
            let imageHeight = imageWidth * cloud1.image!.size.height / cloud1.image!.size.width
            
            cloud1.frame = CGRect(origin: CGPoint(x:view.bounds.width, y: 0+imageHeight), size: CGSize(width: imageWidth, height: imageHeight))
            view.addSubview(cloud1)
            
            UIView.animate(withDuration: 20, delay: 0.5, options: [UIViewAnimationOptions.curveLinear, UIViewAnimationOptions.repeat],
                animations: { [unowned self] in
                    self.cloud1.center.x = 0 - self.cloud1.bounds.size.width - 50
                },
                completion: { [unowned self] finished in
                    self.cloud1.center.x = self.view.bounds.width
                    
                }
            )
        }
        
        func cloud2Animation(){
            
            cloud2?.removeFromSuperview()
            cloud2 = UIImageView(image: UIImage(named:Assets.Images.Scenery.Cloud))
            
            let imageWidth:CGFloat = 60
            let imageHeight = imageWidth * cloud2.image!.size.height / cloud1.image!.size.width
            
            cloud2.frame = CGRect(origin: CGPoint(x:0-imageWidth, y: 0+imageHeight+80), size: CGSize(width: imageWidth, height: imageHeight))
            view.addSubview(cloud2)
            
            UIView.animate(withDuration: 15, delay: 0.5, options: [UIViewAnimationOptions.curveLinear, UIViewAnimationOptions.repeat],
                animations: { [unowned self] in
                    self.cloud2.center.x = self.view.bounds.width + 50
                },
                completion: { [unowned self] finished in
                    self.cloud2.center.x = 0-imageWidth
                    
                }
            )
        }
        
        cloud1Animation()
        cloud2Animation()
    }
    
    func animateForeground(){
        foreground = createImageView(Assets.Images.Scenery.Foreground)
        view.addSubview(foreground)
        view.sendSubview(toBack: foreground)
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(),
            animations: { [unowned self] in
                self.foreground.center.y -= self.foreground.bounds.size.height
            },
            completion: { [unowned self] finished in
                self.animateBackground()
                
            }
        )
    }

    
    func animateMoutains(_ uiView:UIView){
        
        mountains = UIImageView(image: UIImage(named: Assets.Images.Scenery.Mountains))
        let imageWidth = uiView.bounds.width/2
        let imageHeight = uiView.bounds.width/2 * mountains.image!.size.height / mountains.image!.size.width
        
        mountains.frame = CGRect(origin: CGPoint(x:view.bounds.width - imageWidth, y:uiView.center.y - imageHeight ), size: CGSize(width: imageWidth, height: imageHeight))
        
        view.addSubview(mountains)
        view.sendSubview(toBack: mountains)
        
        
        UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.curveLinear,
            animations: { [unowned self] in
                self.mountains.center.y -= imageHeight/2
            },
            completion: { [unowned self] finished in
                self.animatePanda()
                self.animateUI()
            }
        )
    }

    
    func animatePanda(){
        let imageView = UIImageView(image: UIImage(named: Assets.Images.Animals.Panda))
        let imageWidth:CGFloat = 50
        let imageHeight = imageWidth * imageView.image!.size.height / imageView.image!.size.width
        
        imageView.frame = CGRect(origin: CGPoint(x:20, y: view.bounds.height), size: CGSize(width: imageWidth, height: imageHeight))
        view.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target:self, action:Constants.Selectors.PandaTapped);
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.95, initialSpringVelocity: 20, options: UIViewAnimationOptions.curveLinear,
            animations: { [unowned self] in
                imageView.center.y = self.foreground.center.y - imageHeight + 10
            },
            completion: nil
        )
    }
    
    func animateUI(){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(),
            animations: { [unowned self] in
                self.startButton.alpha = 1
                self.titleLabel.alpha = 1
                self.settingsButton.alpha = 1
            },
            completion: nil
        )
    }

    
    
    
    
}
