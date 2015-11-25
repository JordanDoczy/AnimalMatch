//
//  CardView.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

protocol CardViewDelegate :class{
    func cardTapped(card:CardView)
}

class CardView: UIView {

    struct Constants{
        struct Selectors{
            static let Tapped:Selector = "tapped"
        }
    }

    // MARK: Private Members
    private var back: UIView!
    private var front: UIView!
    private var empty: UIView!

    // MARK: Public Members
    weak var delegate:CardViewDelegate?
    var value:String?
    var visible: Bool {
        get {
            return subviews.contains(front)
        }
        set{
            userInteractionEnabled = !newValue
            flip(sideA: newValue ? back : front, sideB: newValue ? front : back, animation: newValue ? UIViewAnimationOptions.TransitionFlipFromLeft : UIViewAnimationOptions.TransitionFlipFromRight, duration: newValue ? 0.4 : 0.55)
        }
    }

    // MARK: INIT
    convenience init(frame: CGRect, back backImage:String, front frontImage:String, color:UIColor=UIColor.clearColor()) {
        self.init(frame:frame)
        
        value = frontImage
        back = createCard(backImage, color: UIColor(red: 206/255, green: 240/255, blue: 253/255, alpha: 1.0))
        front = createCard(frontImage, color: color)
        empty = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: bounds.height)))
        addSubview(empty)
        
        let singleTap = UITapGestureRecognizer(target: self, action: Constants.Selectors.Tapped)
        singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(singleTap)
        userInteractionEnabled = true
    }
    
    // MARK: API
    func hide(){
        func disappear(){
            UIView.animateWithDuration(0.50, animations: {
                self.alpha=0
                self.transform = CGAffineTransformMakeScale(0.1, 0.1)
                })
        }
        
        UIView.animateWithDuration(0.55, animations: {
            self.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: { finished in
                disappear()
            })
    }
    
    func show(){
        flip(sideA: empty, sideB: back, animation: UIViewAnimationOptions.TransitionFlipFromLeft, duration:0.35)
    }

    
    func tapped() {
        delegate?.cardTapped(self)
    }
    
    // MARK: Private Methods
    private func createCard(imageName:String, color:UIColor) ->UIView{
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: bounds.height))
        
        let card = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: bounds.height)))
        card.layer.cornerRadius = 8.0
        card.backgroundColor = color
        card.addSubview(imageView)
        
        return card
    }

    private func flip(sideA sideA:UIView, sideB:UIView, animation:UIViewAnimationOptions=UIViewAnimationOptions.TransitionFlipFromRight, duration:NSTimeInterval){
        UIView.transitionFromView(sideA, toView: sideB, duration: duration, options: animation, completion: nil)
    }

}
