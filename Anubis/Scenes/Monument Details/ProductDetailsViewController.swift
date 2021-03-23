//
//  ProductDetailsViewController.swift
//  E-CommerceApp
//
//  Created by mahmoud mohamed on 11/29/19.
//  Copyright © 2019 ASUFE. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionDetailsLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var currentMonument: MonumentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViews()
    }
    
    func configViews() {
        self.productImageView.kf.setImage(with: URL(string: currentMonument.imagesPaths[0]))
        self.productNameLabel.text = currentMonument.name
        self.productDescriptionDetailsLabel.text = currentMonument.tale
        
    }
    
    func presentAlert(title: String, message: String) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
         self.present(alertController, animated: true)
        
    }

    @IBAction func addToCartButtonTapped(_ sender: Any) {
        let vc = ARViewController()
        vc.modelType = ModelType.init(rawValue: currentMonument.modelType)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        let lat = currentMonument.lat ?? 0
        let lon = currentMonument.lon ?? 0
        self.openMapsApp(lat: lat, lon: lon)
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
