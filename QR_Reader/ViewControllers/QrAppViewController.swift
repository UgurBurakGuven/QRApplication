//
//  ViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 25.01.2022.
//

import UIKit
import AVFoundation
import RealmSwift

class QrAppViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var captureLayer: AVCaptureVideoPreviewLayer?
    var qrcodeFrameView: UIView?
    var on : Bool? = false
    var input : AVCaptureDeviceInput?
    var captureMetadataOutput : AVCaptureMetadataOutput?
    var counter = 0
    var realmTest = 0
 
    let realm = try! Realm()
    
    @IBOutlet weak var changeCameraButton: UIButton!
    @IBOutlet weak var pastSitesButton: UIButton!
    @IBOutlet weak var selectImageFromGalleryButton: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start(value: AVCaptureDevice.Position.back)
      
    }
    
  
    func start(value: AVCaptureDevice.Position){
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: value) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)

            if captureSession.inputs.isEmpty {
                self.captureSession.addInput(input!)
            }
            
            captureMetadataOutput = AVCaptureMetadataOutput()
   
            if captureSession.outputs.isEmpty {
                self.captureSession.addOutput(captureMetadataOutput!)
            }
            
            captureMetadataOutput!.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput!.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            captureLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureLayer?.frame = view.layer.bounds
            view.layer.addSublayer(captureLayer!)
            
            captureSession.startRunning()

            view.bringSubviewToFront(imageView)
            view.bringSubviewToFront(flashlightButton)
            view.bringSubviewToFront(changeCameraButton)
            view.bringSubviewToFront(selectImageFromGalleryButton)
            view.bringSubviewToFront(pastSitesButton)
            
            qrcodeFrameView = UIView()
            
            if let qrcodeFrameView = qrcodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    }
    
    @IBAction func changeCameraButtonClicked(_ sender: Any) {
        captureSession.removeInput(input!)
        captureSession.removeOutput(captureMetadataOutput!)
        captureSession.stopRunning()
        qrcodeFrameView?.removeFromSuperview()
        captureLayer?.removeFromSuperlayer()
        
        if counter == 0 {
            start(value: AVCaptureDevice.Position.front)
            counter += 1
        } else {
            start(value: AVCaptureDevice.Position.back)
            counter -= 1
        }
       
    }
    
        
    @IBAction func flashlightButttonClicked(_ sender: Any) {
            guard let device = AVCaptureDevice.default(for: .video) else { return }

            if device.hasTorch {
                do {
                    try device.lockForConfiguration()

                    if on == false {
                        device.torchMode = .on
                        on = true
                    } else {
                        device.torchMode = .off
                        on = false
                    }

                    device.unlockForConfiguration()
                } catch {
                    print("Torch could not be used")
                }
            } else {
                print("Torch is not available")
            }
    }
    
    @IBAction func selectImageButtonClicked(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func pastButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pastPages") as! LastReadedPageViewController
        self.present(vc, animated: true, completion: nil)
    }
    

}


//MARK: AVCaptureMetadataOutputObjectsDelegate

extension QrAppViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrcodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        if URL(string: String(metadataObj.stringValue!)) != nil {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                let barCodeObject = captureLayer?.transformedMetadataObject(for: metadataObj)
                qrcodeFrameView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    let results = realm.objects(pastSites.self)
                    for counter in 0..<results.count {
                        if results[counter].url == metadataObj.stringValue {
                            realmTest += 1
                        }
                    }
                    if realmTest == 0 {
                        let date = Date()
                        let df = DateFormatter()
                        df.dateFormat = "dd.MM.yyyy"
                        let dateString = df.string(from: date)
                        let detail = pastSites()
                        detail.url = metadataObj.stringValue ?? ""
                        detail.date = dateString
                        try! realm.write({
                            realm.add(detail)
                            print("added")
                        })
                    }
                realmTest = 0
                    UIApplication.shared.open((URL(string: String(metadataObj.stringValue!)) ?? URL(string: "https://www.google.com.tr"))!)
                }
        }
       
        }
    }
    
   
}

//MARK: UIImagePickerControllerDelegate,UINavigationControllerDelegate

extension QrAppViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrcodeImg = info[.originalImage] as? UIImage {
            let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage:CIImage=CIImage(image:qrcodeImg)!
            var qrCodeLink=""
  
            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrCodeLink += feature.messageString!
            }
            if URL(string: String(qrCodeLink)) != nil {
                if qrCodeLink=="" {
                    print("nothing")
                }else{
                    let results = realm.objects(pastSites.self)
                    for counter in 0..<results.count {
                        if results[counter].url == qrCodeLink {
                            realmTest += 1
                        }
                    }
                    if realmTest == 0 {
                        let date = Date()
                        let df = DateFormatter()
                        df.dateFormat = "dd.MM.yyyy"
                        let dateString = df.string(from: date)
                        let detail = pastSites()
                        detail.url = qrCodeLink
                        detail.date = dateString
                        try! realm.write({
                            realm.add(detail)
                            print("added")
                        })
                    }
                realmTest = 0
                    print(qrCodeLink)
                    if let result = URL(string: String(qrCodeLink)){
                        UIApplication.shared.open(result)
                    }
            }
            
          
            }
        }
        else{
           print("Something went wrong")
        }
       self.dismiss(animated: true, completion: nil)
      }
}


