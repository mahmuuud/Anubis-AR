//
//  HomeViewController + Delegates.swift
//  Anubis
//
//  Created by mahmoud mohamed on 4/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        // Retrieve the image height
//        let n = Int.random(in: 200...300)
        let height = self.photosHeights[indexPath.row]
        return height ?? 250.0
    }
}

extension HomeViewController: MonumentCollectionCellDelegate {
    func didSetCellImage(at indexPath: IndexPath, using height: CGFloat) {
        let layout = homeCollectionView.collectionViewLayout as? PinterestLayout
        layout?.cache = []
        self.photosHeights [indexPath.row] = height/12
        self.homeCollectionView.collectionViewLayout.invalidateLayout()
        self.homeCollectionView.layoutIfNeeded()
    }
    
}

extension HomeViewController: OptionsViewDelegate {
    
    func didTapDirectionsButton(at indexPath: IndexPath) {
        
    }
    
    func didTapSaveButton(at indexPath: IndexPath) {
        
    }
    
    func didTapARButton(at indexPath: IndexPath) {
        
    }
    
    func didTapCancelButton() {
        
    }
    
}
