//
//  QRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit

class QRViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        

    }
 
    @IBAction func lastReadedPageButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pastPages") as! LastReadedPageViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func cameraPageButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QrAppViewController") as! QrAppViewController
        self.present(vc, animated: true, completion: nil)
    }
   
    
    @IBAction func chooseCategory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chooseCategory") as! ChooseQrTypeViewController
        self.present(vc, animated: true, completion: nil)
    }
}
