//
//  AnimalView.swift
//  Balloon
//
//  Created by Jordan Doczy on 11/22/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit

class BalloonView : UIView {
    
    fileprivate var _popped = false
    var popped:Bool {
        return _popped
    }
    
    var balloon: UIImageView?
    var balloonAsset:String?{
        didSet{
            balloon?.removeFromSuperview()
            balloon = UIImageView(image:UIImage(named: balloonAsset!))
            balloon!.frame.size = CGSize(width: frame.size.width, height: frame.size.width * balloon!.image!.ratio)
            animal?.center.x = balloon!.center.x
            addSubview(balloon!)
            sendSubview(toBack: balloon!)
        }
    }
    
    var animal: UIImageView?
    var animalAsset:String?{
        didSet{
            animal?.removeFromSuperview()
            animal = UIImageView(image:UIImage(named: animalAsset!))
            animal!.frame.size = CGSize(width: frame.size.width, height: frame.size.width * animal!.image!.ratio)
            animal!.center.y = -animal!.frame.size.height * 0.50
            addSubview(animal!)
        }
    }
    
    func pop(_ complete:@escaping ()->Void={}){
        _popped = true
        let pop = UIImageView(image: UIImage(named: Assets.Images.Balloons.Pop))
        pop.frame.size = CGSize(width: balloon!.frame.size.width, height: balloon!.frame.size.width * pop.image!.ratio)
        addSubview(pop)
        UIView.animate(withDuration: 0.25,
            animations: { [unowned self] in
                self.balloon!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.balloon!.center.y -= self.balloon!.bounds.height/4
                self.balloon!.alpha = 0
                self.animal?.alpha = 1
                pop.transform = CGAffineTransform(scaleX: 2, y: 2)
                pop.alpha = 0
            },
            completion: { success in
                pop.removeFromSuperview()
                complete()
            }
        )
    }

}

extension UIImage{
    var ratio: CGFloat {
        return max(size.width/size.height, size.height/size.width)
    }
}


