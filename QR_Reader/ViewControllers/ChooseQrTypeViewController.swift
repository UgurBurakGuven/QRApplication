//
//  ChooseQrTypeViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit
import RealmSwift

class ChooseQrTypeViewController: UIViewController{


    @IBOutlet weak var qrTypeTableView: UITableView!
    var data : [QrModel]?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrTypeTableView.delegate = self
        qrTypeTableView.dataSource = self
        data = DataLoader().userData
        self.qrTypeTableView.register(UINib(nibName: "TypeOfPageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    
    @IBAction func okButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! LastCreatedQRViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    

}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ChooseQrTypeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = qrTypeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TypeOfPageTableViewCell {
            cell.typeOfPageName.text = data?[indexPath.row].name
            if let image = data?[indexPath.row].image {
                cell.typeOfPageImageView.image = UIImage(named: image)
            }
     
            return cell
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "toCreateViewController") as! CreateQRViewController
        vc.selectedData = data?[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
