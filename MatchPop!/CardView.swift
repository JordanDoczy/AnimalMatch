//
//  CardView.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

protocol CardViewDelegate :class{
    func cardTapped(_ card:CardView)
}

class CardView: UIView {

    struct Constants{
        struct Selectors{
            static let Tapped:Selector = #selector(CardView.tapped)
        }
    }

    // MARK: Private Members
    fileprivate var back: UIView!
    fileprivate var cancellables: Set<AnyCancellable> = []
    fileprivate var front: UIView!
    fileprivate var empty: UIView!

    // MARK: Public Members
    weak var delegate:CardViewDelegate?
    var value:String?
    var visible: Bool {
        get {
            return subviews.contains(front)
        }
        set{
            isUserInteractionEnabled = !newValue
            flip(sideA: newValue ? back : front, sideB: newValue ? front : back, animation: newValue ? UIView.AnimationOptions.transitionFlipFromLeft : UIView.AnimationOptions.transitionFlipFromRight, duration: newValue ? 0.4 : 0.55)
        }
    }

    // MARK: INIT
    convenience init(frame: CGRect, back backImage:String, front frontImage:String, color:UIColor=UIColor.clear) {
        self.init(frame:frame)
        
        value = frontImage
        back = createCard(backImage, color: UIColor(red: 206/255, green: 240/255, blue: 253/255, alpha: 1.0))
        front = createCard(frontImage, color: color)
        empty = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: bounds.height)))
        addSubview(empty)
        
        let singleTap = UITapGestureRecognizer(target: self, action: Constants.Selectors.Tapped)
        singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(singleTap)
        isUserInteractionEnabled = true
    }
    
    // MARK: API
    func hide(){
        UIView.animationPublisher(withDuration: 0.55) { [unowned self] in
            transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        .flatMap { [unowned self] _ in
            return UIView.animationPublisher(withDuration: 0.5) { [unowned self] in
                alpha=0
                transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
        .sink { _ in }
        .store(in: &cancellables)
    }
    
    @objc func show(){
        flip(sideA: empty, sideB: back, animation: UIView.AnimationOptions.transitionFlipFromLeft, duration:0.35)
    }

    
    @objc func tapped() {
        delegate?.cardTapped(self)
    }
    
    // MARK: Private Methods
    fileprivate func createCard(_ imageName:String, color:UIColor) ->UIView{
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: bounds.height))
        
        let card = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: bounds.height)))
        card.layer.cornerRadius = 8.0
        card.backgroundColor = color
        card.addSubview(imageView)
        
        return card
    }

    fileprivate func flip(sideA:UIView, sideB:UIView, animation:UIView.AnimationOptions=UIView.AnimationOptions.transitionFlipFromRight, duration:TimeInterval){
        UIView.transition(from: sideA, to: sideB, duration: duration, options: animation, completion: nil)
    }

}
