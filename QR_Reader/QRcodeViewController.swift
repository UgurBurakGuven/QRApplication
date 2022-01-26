//
//  QRcodeViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 25.01.2022.
//

import UIKit

class QRcodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}
