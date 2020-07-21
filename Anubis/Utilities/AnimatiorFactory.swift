//
//  AnimatiorFactory.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

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
    
    @discardableResult
    static func shake(view: UIView, with deltaX: CGFloat) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator()
        let _ = view.bounds
        animator.addAnimations({
            view.bounds.origin.x += deltaX
        }, delayFactor: 0)
        
        animator.addAnimations({
            view.bounds.origin.x -= deltaX
        }, delayFactor: 0.1)
        
        animator.addAnimations({
            view.bounds.origin.x -= deltaX
        }, delayFactor: 0.2)
        
        animator.addAnimations({
            view.bounds.origin.x += deltaX
        }, delayFactor: 0.3)
        
        animator.addCompletion { (_) in
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        return animator
    }
    
    static func showErrorBanner(in parentView: UIView, with message: String) {
        let safeAreaGuide = parentView.layoutMarginsGuide
        let bannerView = UIView(frame: CGRect(x: parentView.bounds.minX, y: safeAreaGuide.layoutFrame.minY, width: parentView.bounds.width, height: 40))
        bannerView.backgroundColor = .red
        bannerView.center.y -= 200
        parentView.addSubview(bannerView)
        
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        bannerView.insertSubview(label, at: 0)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: bannerView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: bannerView, attribute: .trailing, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: bannerView, attribute: .centerY, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: bannerView, attribute: .centerX, multiplier: 1, constant: 0)
        
        ])
        
        label.textColor = .white
        label.text = message
        
        UIView.animate(withDuration: 0.7, animations: {
            bannerView.center.y += 200
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 2, options: [], animations: {
                bannerView.center.y -= 200
            }) { (_) in
                bannerView.removeFromSuperview()
            }
        })
    }
}
