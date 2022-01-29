//
//  CreateQRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit

class CreateQRViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    
    var selectedData : TypeOfQr?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = selectedData?.content
        contentTitle.text = selectedData?.name
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createQRButtonClicked(_ sender: Any) {
        let myQrCode = textField.text
       
        if let myQrCode = myQrCode {
            if let selectedUrl = selectedData?.url {
                let combinedString = "\(selectedUrl + myQrCode)"
                qrImageView.image = generateQRCode(URL: combinedString)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chooseCategory") as! ChooseQrTypeViewController
        self.present(vc, animated: true, completion: nil)
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
