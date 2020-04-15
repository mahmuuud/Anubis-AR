//
//  SplashScreenViewController.swift
//  Anubis
//
//  Created by mahmoud mohamed on 3/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

class SplashScreenViewController: UIViewController {
    
    var dbRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        //        self.uploadMonuments()
        downloadMonuments()
    }
    
    func performTransitionToHomeVC() {
        DispatchQueue.main.async {
            if let window = (self.view.window){
                window.rootViewController = HomeViewController()
                UIView.transition(with: window, duration: 0.5551, options: .transitionCrossDissolve, animations: {}, completion: nil)
            }
        }
    }
    
    func presentError(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.downloadMonuments()
        }
        alert.addAction(tryAgainAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadMonuments() {
        var m1 = MonumentModel.init()
        m1.name = "Tutankhamoun"
        m1.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/egypt-tutankhamun-death-mask-pharaonic-33571.jpg?alt=media&token=8763ee31-8d86-4a7d-bf28-2f99e7560e4f"]
        m1.lat = 30.033333
        m1.lon = 31.233334
        m1.tale = ""
        
        var m2 = MonumentModel.init()
        m2.name = "Shphinx"
        m2.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/sand-desert-statue-pyramid-2359.jpg?alt=media&token=d75ebadd-5d6a-408b-8d24-bc6409311ae7"]
        m2.lat = 30.033333
        m2.lon = 31.233334
        m2.tale = ""
        
        var m3 = MonumentModel.init()
        m3.name = "Ramses"
        m3.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/brown-statue-3214970.jpg?alt=media&token=0ee232a6-55af-4337-9c34-6d0fa0e04ef0"]
        m3.lat = 30.033333
        m3.lon = 31.233334
        m3.tale = ""
        
        var m4 = MonumentModel.init()
        m4.name = "Luxor Statue"
        m4.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/3516.jpg?alt=media&token=67e4deaf-10ad-4fd6-bbaf-4ff4eb982424"]
        m4.lat = 30.033333
        m4.lon = 31.233334
        m4.tale = ""
        
        var m5 = MonumentModel.init()
        m5.name = "Ramses' Face"
        m5.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/351.jpg?alt=media&token=9479b360-0f20-4703-aeeb-f652b7e9d3c8"]
        m5.tale = ""
        m5.lat = 30.033333
        m5.lon = 31.233334
        
        let monuments = [m1, m2, m3, m4, m5]
        
        let codedMon = try? FirebaseEncoder().encode(monuments)
        dbRef.child("Monuments").childByAutoId().setValue(codedMon)
    }
    
    func downloadMonuments() {
        dbRef.child("Monuments").observe(.value) { [weak self] (snapshot) in
            if snapshot.value == nil {
                DispatchQueue.main.async {
                    self?.presentError(with: "Something wrong happened", message: "Please check your connection and try again.")
                }
                return
            }
            let data = ((snapshot.value as? [String: Any])!.values).first
            let decodedData = try? FirebaseDecoder().decode([MonumentModel].self, from: data ?? [])
            if let decodedData = decodedData {
                DataSource.shared.monuments = decodedData
                self?.performTransitionToHomeVC()
            } else {
                self?.presentError(with: "Something wrong happened", message: "Please check your connection and try again.")
            }
            print("🟥\(String(describing: decodedData))")
        }
    }
    
    
}
