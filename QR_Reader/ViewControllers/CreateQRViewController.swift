//
//  CreateQRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit
import RealmSwift

class CreateQRViewController: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var selectedData : QrModel?
    var combinedString = ""
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        contentLabel.text = selectedData?.content
        contentTitle.text = selectedData?.name
        self.textField.delegate = self
        if selectedData?.name == "Phone Number" {
            textField.keyboardType = UIKeyboardType.phonePad
        }

        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        keyboardGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(keyboardGestureRecognizer)
    }
    
    
    @IBAction func createQRButtonClicked(_ sender: Any) {
        let myQrCode = textField.text
       
        if let myQrCode = myQrCode {
            if let selectedUrl = selectedData?.url {
                combinedString = "\(selectedUrl + myQrCode)"
                qrImageView.image = generateQRCode(from : combinedString)
                saveButton.isHidden = false
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chooseCategory") as! ChooseQrTypeViewController
        self.present(vc, animated: true, completion: nil)
    }
    func generateQRCode(from URL: String) -> UIImage? {
        
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
    @IBAction func saveQrButtonClicked(_ sender: Any) {
        let qr = pastQr()
        qr.name = selectedData?.name
        qr.url = combinedString
        try! realm.write({
            realm.add(qr)
        })
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! LastCreatedQRViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    

}

//MARK: - UITextFieldDelegate
extension CreateQRViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
