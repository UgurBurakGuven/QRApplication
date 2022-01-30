//
//  QRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit

class QRViewController: UIViewController {
    @IBOutlet weak var qrTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrTableView.delegate = self
        qrTableView.dataSource = self

        qrTableView.backgroundView = UIImageView(image: UIImage(named: "mat"))
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

//MARK: UITableViewDelegate, UITableViewDataSource

extension QRViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
