//
//  QrDetailViewController.swift
//  QR_Reader
//
//  Created by Uğur burak Güven on 31.01.2022.
//

import UIKit

class QrDetailViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var goToQrCodeButton: UIButton!
    
    var selectedUrl : pastQr?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQr()
        
    }
    
    func getQr(){
        if let selectedUrl = selectedUrl?.url {
            self.qrImageView.image = generateQRCode(URL: selectedUrl)
        }
    }

    @IBAction func goToQrCodeButtonClicked(_ sender: Any) {
        if selectedUrl?.name == "Phone Number" {
            if let selectedUrl = selectedUrl?.url {
                guard let url = URL(string: "telprompt://\(selectedUrl)"),
                        UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if let selectedUrl = selectedUrl?.url {
                if let url = URL(string: String(selectedUrl)){
                    UIApplication.shared.open(url)
                }
            }
        }
        
       
    }
    
    func generateQRCode(URL: String) -> UIImage? {
        
        let url_data = URL.data(using: String.Encoding.ascii)
    
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(url_data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
