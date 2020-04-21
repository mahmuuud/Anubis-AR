//
//  AnimatiorFactory.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import UIKit

class AnimatiorFactory {
    
    @discardableResult
    static func grow(blurView: UIVisualEffectView, view: UIVisualEffectView) -> UIViewPropertyAnimator {
        
        let grow = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        view.contentView.alpha = 0
        view.transform = .identity
        
        grow.addAnimations {
            blurView.effect = UIBlurEffect(style: .dark)
        }
        
        grow.addAnimations {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        grow.addCompletion { position in
            switch position {
            case .start:
                blurView.effect = nil
            case .end:
                blurView.effect = UIBlurEffect(style: .dark)
                blurView.isUserInteractionEnabled = true
            default: break
            }
        }
        
        return grow
    }
    
    @discardableResult
    static func complete(view: UIVisualEffectView, frame: CGRect) -> UIViewPropertyAnimator {
        let width = (view.superview?.bounds.width ?? 200) - 20
        var xCoordinate = frame.minX
        let yCoordinate = ((frame.maxY + 156) > view.superview?.frame.maxY ?? CGFloat(0)) ? frame.minY - 156 : frame.maxY + 6
        if (xCoordinate + width) > ((view.superview?.bounds.maxX ?? 0) - 10) {
            xCoordinate -= ((xCoordinate + width) - frame.maxX)
        }
        return UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.7) {
            view.transform = .identity
            view.contentView.alpha = 1
            
            view.frame = CGRect(x: xCoordinate, y: yCoordinate, width: (view.superview?.bounds.width ?? 200) - 20, height: 150)
        }
        
    }
}
