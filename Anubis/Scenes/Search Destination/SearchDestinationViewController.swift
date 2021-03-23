//
//  SearchDestinationViewController.swift
//  Anubis
//
//  Created by Mahmoud Elkassry on 21/03/2021.
//  Copyright © 2021 ASUFE. All rights reserved.
//

import UIKit
import Firebase

class SearchDestinationViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    lazy var vision = Vision.vision()
    var landmark: VisionCloudLandmark! {
        didSet {
            displayLandmarkDetails()
        }
    }
    var didChooseImage = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var landmarkNameLabel: UILabel!
    @IBOutlet weak var landmarkLocationButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func displayLandmarkDetails() {
//        detailsView.isHidden = false
//        landmarkNameLabel.text = landmark.landmark
        guard let landmarkName = landmark.landmark else {
            showAlert(title: "Something went wrong", message: "Please try again.")
            return
        }
        showLocationDetailsPopup(landmarkName: landmarkName)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLocationDetailsPopup(landmarkName: String) {
        let alert = UIAlertController(title: "A Match found!", message: "The landmark in the photo is \(landmarkName).", preferredStyle: .alert)
        let locationAction = UIAlertAction(title: "Navigation", style: .default) { (_) in
            guard let lat = self.landmark.locations?[0].latitude, let lon = self.landmark.locations?[0].longitude else {
                self.showAlert(title: "Your landmark location is not available.", message: "Please try a different search")
                return
            }
            self.openMapsApp(lat: Double(truncating: lat), lon: Double(truncating: lon))
        }
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert.addAction(locationAction)
        alert.addAction(continueAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose how to upload", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard didChooseImage else {
            return
        }
        activityIndicator.startAnimating()
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        detectLandmark(with: imageView.image!)
    }
    @IBAction func landmarkLocationTapped(_ sender: Any) {
        guard let lat = landmark.locations?[0].latitude, let lon = landmark.locations?[0].longitude else {
            showAlert(title: "Your landmark location is not available.", message: "Please try a different search")
            return
        }
        self.openMapsApp(lat: Double(truncating: lat), lon: Double(truncating: lon))
    }
    
    func detectLandmark(with image: UIImage) {
        let cloudDetector = vision.cloudLandmarkDetector()
        let visionImage = VisionImage(image: image)
        
        cloudDetector.detect(in: visionImage) { landmarks, error in
          guard error == nil, let landmarks = landmarks, !landmarks.isEmpty else {
            print("🔴\(String(describing: error))")
            return
          }
            self.submitButton.isEnabled = true
            self.submitButton.alpha = 1
            self.activityIndicator.stopAnimating()
          // Recognized landmarks
            let landmark = landmarks.max { (l1, l2) -> Bool in
                Double(truncating: (l1 ).confidence ?? 0) < Double(truncating: (l2 ).confidence ?? 0)
                
            }
            if let landmark = landmark{
                // Details vc
                self.landmark = landmark
            } else {
                self.showAlert(title: "No results found!", message: "Please try another search.")
            }
            print("🥇\(String(describing: landmark?.landmark))")
        }
    }
    
    func openMapsApp(lat: Double, lon: Double) {
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


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        detailsView.isHidden = true
        didChooseImage = true
        picker.dismiss(animated: true) {
            self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
    }
    
}
