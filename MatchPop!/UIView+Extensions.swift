//
//  UIView+Extensions.swift
//  MatchPop!
//
//  Created by Jordan Doczy on 3/4/21.
//  Copyright © 2021 Jordan Doczy. All rights reserved.
//

import UIKit
import Combine

extension UIView {
    class func animationPublisher(withDuration duration: TimeInterval, animations: @escaping () -> Void) -> Future<Bool, Never> {
        Future { promise in
            UIView.animate(withDuration: duration, animations: animations) {
                promise(.success($0))
            }
        }
    }
    
    class func animationPublisher(withDuration duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions = [], animations: @escaping () -> Void) -> Future<Bool, Never> {
        Future { promise in
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) {
                promise(.success($0))
            }
        }
    }
    
    class func animationPublisher(withDuration duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIView.AnimationOptions = [], animations: @escaping () -> Void) -> Future<Bool, Never> {
        Future { promise in
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations) {
                promise(.success($0))
            }
        }
    }
}
