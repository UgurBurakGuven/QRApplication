//
//  QRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit
import RealmSwift

class LastCreatedQRViewController: UIViewController {
    @IBOutlet weak var qrTableView: UITableView!
    var counter = 0
    
    let realm = try! Realm()
    
    var filteredData : [pastQr]? = []
    var searchBar : UISearchBar?
    var searchBarArray = [String]()
    
    var realmArray : [pastQr]? = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        qrTableView.delegate = self
        qrTableView.dataSource = self

        self.qrTableView.register(UINib(nibName: "PastQrTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        qrTableView.backgroundView = UIImageView(image: UIImage(named: "mat"))
        getDataFromRealm()
        searchBarSetup()
        
        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        keyboardGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(keyboardGestureRecognizer)
    }
    
    func getDataFromRealm() {
        let results = realm.objects(pastQr.self)
        for result in results {
            realmArray?.append(result)
            searchBarArray.append(result.url ?? "")
        }
 
        self.filteredData = self.realmArray
    }
 
    @IBAction func createQRButtonClicked(_ sender: Any) {
        if counter == 1 {
            let indexPath = IndexPath(row: 0, section: 0)
            qrTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    @IBAction func lastReadedPageButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pastPages") as! LastOpenedPageViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func cameraPageButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QrAppViewController") as! QrCameraAppViewController
        self.present(vc, animated: true, completion: nil)
    }
   
    
    @IBAction func chooseCategory(_ sender: Any) {
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

//MARK: - UITableViewDelegate, UITableViewDataSource

extension LastCreatedQRViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = qrTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PastQrTableViewCell{
            cell.pastQrNameLabel.text = filteredData?[indexPath.row].name
            cell.pastQrUrl.text = filteredData?[indexPath.row].url
            if let url = filteredData?[indexPath.row].url {
                cell.pastQrImageView.image = generateQRCode(URL: url)
            }
           
            return cell
        }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "qrDetail") as! QrDetailViewController
        vc.selectedUrl = filteredData?[indexPath.row]
        self.present(vc, animated: true, completion: nil)
      
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                counter = 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {

           if let url = realmArray?[indexPath.row].url {
               let results = realm.objects(pastQr.self).filter("url='\(url)'")
               print(results)
               try! realm.write({
                   realm.delete(results)
                   realmArray?.remove(at: indexPath.row)
                   filteredData?.remove(at: indexPath.row)
               })
               if filteredData?.count == 0 {
                   counter = 0
               }
               
           }
           
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
       }
   }
    
    
}

//MARK: - UISearchBarDelegate
extension LastCreatedQRViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = realmArray
        } else {
            for counter in 0..<realmArray!.count{
                for result in searchBarArray{
                    if result.lowercased().contains(searchText.lowercased()){
                            if realmArray?[counter].url == result {
                                filteredData?.append(realmArray![counter])
                                break
                            }
                        }
                }
            }
        }
        self.qrTableView.reloadData()
    }
    
    func searchBarSetup(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        searchBar?.showsScopeBar = true
        searchBar?.delegate = self
        self.qrTableView.tableHeaderView = searchBar
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
