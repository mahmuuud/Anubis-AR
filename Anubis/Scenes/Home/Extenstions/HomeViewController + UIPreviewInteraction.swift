//
//  HomeViewController + UIPreviewInteraction.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UIPreviewInteractionDelegate {
    
    func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
        if let indexPath = homeCollectionView.indexPathForItem(at: previewInteraction.location(in: homeCollectionView)), let cell = homeCollectionView.cellForItem(at: indexPath) as? MonumentCollectionViewCell {
            startPreview(for: cell, at: indexPath)
        }
        return true
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        updatePreview(at: transitionProgress)
        if ended {
            finishPreview()
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        cancelPreview()
    }
    
}
