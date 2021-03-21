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
    var appWindow: UIWindow? {
        (UIApplication.shared.windows.first)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
//                self.uploadMonuments()
        downloadMonuments()
    }
    
    func performTransitionToHomeVC() {
        DispatchQueue.main.async {
            if let window = (self.view.window){
                let rootVC = UINavigationController(rootViewController: HomeViewController())
                window.rootViewController = rootVC
                UIView.transition(with: window, duration: 0.5551, options: .transitionCrossDissolve, animations: {}, completion: nil)
            }
        }
    }
    
    func setMainTabBarInitialView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController")
        appWindow?.rootViewController = tabBarViewController
        appWindow?.makeKeyAndVisible()
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
        m1.name = "Tutankhamoun Mask"
        m1.modelType = ModelType.mask.rawValue
        m1.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/4679fe3b189bf263ec016095c6798531.jpg?alt=media&token=a66b2ce0-035f-43aa-94de-c97410aa14dd"]
        m1.lat = 30.033333
        m1.lon = 31.233334
        m1.tale = "Tutankhamun, also spelled Tutankhamen and Tutankhamon, original name Tutankhaten, byname King Tut, (flourished 14th century BCE), king of ancient Egypt (reigned 1333–23 BCE), known chiefly for his intact tomb, KV 62 (tomb 62), discovered in the Valley of the Kings in 1922. During his reign, powerful advisers restored the traditional Egyptian religion and art, both of which had been set aside by his predecessor Akhenaten, who had led the “Amarna revolution"
        
        var m2 = MonumentModel.init()
        m2.name = "Sphinx"
        m2.modelType = ModelType.sphinx.rawValue
        m2.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/The_amazing_Sphinx.jpg?alt=media&token=c27c2334-2469-4f9a-a926-6fa37250c3e2"]
        m2.lat = 30.033333
        m2.lon = 31.233334
        m2.tale = "The Great Sphinx of Giza, commonly referred to as the Sphinx of Giza or just the Sphinx, is a limestone statue of a reclining sphinx, a mythical creature. Facing directly from West to East, it stands on the Giza Plateau on the west bank of the Nile in Giza, Egypt."
        
        var m3 = MonumentModel.init()
        m3.name = "Anubis"
        m3.modelType = ModelType.cat.rawValue
        m3.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/51MFeywjv2L._AC_SY879_.jpg?alt=media&token=e3b649df-e9e3-4a31-893e-018acf5c958e"]
        m3.lat = 30.033333
        m3.lon = 31.233334
        m3.tale = "Anubis, also called Anpu, ancient Egyptian god of the dead, represented by a jackal or the figure of a man with the head of a jackal. ... In the Early Dynastic period and the Old Kingdom, he enjoyed a preeminent (though not exclusive) position as lord of the dead, but he was later overshadowed by Osiris."
        
        var m4 = MonumentModel.init()
        m4.name = "Tutankhamoun Tomb"
        m4.modelType = ModelType.tut1.rawValue
        m4.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/e341b9c6d488b7cf765f1e96bf22079d.jpg?alt=media&token=b777aab1-4eab-4198-b7ba-52d0e6d05f34"]
        m4.lat = 30.033333
        m4.lon = 31.233334
        m4.tale = ""
        
        var m5 = MonumentModel.init()
        m5.name = "Tutankhamoun"
        m5.modelType = ModelType.tut.rawValue
        m5.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/tut_bust.jpg?alt=media&token=1ec26da4-9405-46a5-a317-dc36eace8d9c"]
        m5.tale = ""
        m5.lat = 30.033333
        m5.lon = 31.233334
        
        var m6 = MonumentModel.init()
        m6.name = "Nefertiti"
        m6.modelType = ModelType.nefer.rawValue
        m6.imagesPaths = ["https://firebasestorage.googleapis.com/v0/b/anubis-f5fd4.appspot.com/o/Nofretete_Neues_Museum.jpg?alt=media&token=dd10db58-849f-423b-8632-2a75257f35bd"]
        m6.tale = "Neferneferuaten Nefertiti was a queen of the 18th Dynasty of Ancient Egypt, the Great Royal Wife of Pharaoh Akhenaten. Nefertiti and her husband were known for a religious revolution, in which they worshipped one god only, Aten, or the sun disc"
        m6.lat = 30.033333
        m6.lon = 31.233334
        
        let monuments = [m1, m2, m3, m4, m5, m6]
        
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
                self?.setMainTabBarInitialView()
            } else {
                self?.presentError(with: "Something wrong happened", message: "Please check your connection and try again.")
            }
            print("🟥\(String(describing: decodedData))")
        }
    }
    
    
}
