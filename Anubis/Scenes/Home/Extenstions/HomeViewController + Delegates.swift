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
        let lat = monuments[indexPath.row].lat ?? 0
        let lon = monuments[indexPath.row].lon ?? 0
        self.playbackOptionsAnimation()
        self.openMapsApp(lat: lat, lon: lon)
    }
    
    func didTapSaveButton(at indexPath: IndexPath) {
        
    }
    
    func didTapARButton(at indexPath: IndexPath) {
        
    }
    
    func didTapCancelButton() {
        
    }
    
    @objc internal func openMapsApp(lat: Double, lon: Double) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) { (_) in
            UIApplication.shared.open(URL(string: "http://maps.apple.com/maps?saddr=\(lat),\(lon)")!)
        }
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { (_) in
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)&directionsmode=driving")!)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(appleMapsAction)
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            actionSheet.addAction(googleMapsAction)
        }
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true) {
            
        }
    }
    
}
