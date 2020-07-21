//
//  HomeViewController.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/15/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit
import Kingfisher

protocol MonumentCollectionCellDelegate: AnyObject {
    func didSetCellImage(at indexPath: IndexPath, using height: CGFloat)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    private var previewInteraction: UIPreviewInteraction?
    private let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "29"))
    let monuments = DataSource.shared.monuments
    private let cellNib = UINib(nibName: "MonumentCollectionViewCell", bundle: nil)
    let cellReuseId = "MonumentCollectionViewCell"
    var photosHeights: [Int : CGFloat] = [:]
    
    let blurView = UIVisualEffectView(effect: nil)
    var animator: UIViewPropertyAnimator?
    var replicatedView: UIView?
    let optionsView = OptionsView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = homeCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        previewInteraction = UIPreviewInteraction(view: homeCollectionView)
        previewInteraction?.delegate = self
        
        backgroundImageView.contentMode = .scaleAspectFill
        self.homeCollectionView.backgroundView = backgroundImageView
        self.homeCollectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBlurView))
        blurView.isUserInteractionEnabled = false
        blurView.addGestureRecognizer(tapGesture)
        view.addSubview(blurView)
        
    }
    
    override func viewWillLayoutSubviews() {
        blurView.frame = view.bounds
    }
    
    @objc func didTapBlurView() {
        playbackOptionsAnimation()
    }
    
    func playbackOptionsAnimation() {
        animator = AnimatiorFactory.grow(blurView: blurView, view: optionsView)
        cancelPreview()
    }
    
    func startPreview(for cellView: UIView, at indexPath: IndexPath) {
        replicatedView?.removeFromSuperview()
        replicatedView = cellView.snapshotView(afterScreenUpdates: false)
        replicatedView?.frame = cellView.convert(cellView.bounds, to: self.view)
        view.insertSubview(replicatedView ?? UIView(), aboveSubview: blurView)
        
        addOptionsView(for: replicatedView!, at: indexPath)
        animator = AnimatiorFactory.grow(blurView: blurView, view: optionsView)
    }
    
    func updatePreview(at progress: CGFloat) {
        animator?.fractionComplete = max(0.01, min(progress, 0.99))
    }
    
    func finishPreview() {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .end)
        animator = nil
        AnimatiorFactory.complete(view: optionsView, frame: replicatedView?.frame ?? CGRect()).startAnimation()
    }
    
    func cancelPreview() {
        animator?.isReversed = true
        animator?.startAnimation()
        animator?.addCompletion({ (position) in
            switch position {
            case .start:
                self.replicatedView?.removeFromSuperview()
                self.optionsView.removeFromSuperview()
                self.blurView.isUserInteractionEnabled = false
            default:
                ()
            }
        })
    }
    
    func addOptionsView(for cellView: UIView, at indexPath: IndexPath) {
        optionsView.removeFromSuperview()
        optionsView.frame = cellView.frame
        optionsView.indexPath = indexPath
        optionsView.delegate = self
        cellView.superview?.insertSubview(optionsView, belowSubview: cellView)
    }
    
}
