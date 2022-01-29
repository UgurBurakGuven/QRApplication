//
//  LastReadedPageViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 26.01.2022.
//

import UIKit
import RealmSwift

class LastReadedPageViewController: UIViewController {

    @IBOutlet weak var pagesTableView: UITableView!
    let realm = try! Realm()
    var realmArray: [pastSites]? = []
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        pagesTableView.delegate = self
        pagesTableView.dataSource = self
        self.pagesTableView.register(UINib(nibName: "PagesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        getDataFromRealm()
    }
    
    func getDataFromRealm(){
        let results = realm.objects(pastSites.self)
        for result in results {
            realmArray?.append(result)
        }
    }
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QrAppViewController") as! QrAppViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func lastReadedButtonClicked(_ sender: Any) {
//        if counter == 1 {
//            let indexPath = IndexPath(row: 0, section: 0)
//            pagesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
//            print("clicked")
//        }

    }
    @IBAction func createQRButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:  UITableViewDataSource, UITableViewDelegate

extension LastReadedPageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PagesTableViewCell {
            cell.cellsURL.text = realmArray?[indexPath.row].url
            cell.cellsDate.text = realmArray?[indexPath.row].date
            
            return cell
        }
          
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open((URL(string: String((realmArray?[indexPath.row].url)!)))!)
      
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
//            if indexPath == lastVisibleIndexPath {
//                counter = 1
//            }
//            print("indexPath----->",indexPath)
//        }
//    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            if let url = realmArray?[indexPath.row].url {
                let results = realm.objects(pastSites.self).filter("url='\(url)'")
                print(results)
                try! realm.write({
                    realm.delete(results)
                    realmArray?.remove(at: indexPath.row)
                })
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
