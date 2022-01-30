//
//  QRViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import UIKit
import RealmSwift

class QRViewController: UIViewController {
    @IBOutlet weak var qrTableView: UITableView!
    
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
    }
    
    func getDataFromRealm() {
        let results = realm.objects(pastQr.self)
        for result in results {
            realmArray?.append(result)
            searchBarArray.append(result.url ?? "")
        }
 
        self.filteredData = self.realmArray
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

extension QRViewController : UITableViewDelegate, UITableViewDataSource {
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
        if let url = URL(string: String(filteredData?[indexPath.row].url ?? "")){
            UIApplication.shared.open(url)
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
               
           }
           
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
       }
   }
    
    
}

//MARK: - UISearchBarDelegate
extension QRViewController : UISearchBarDelegate {
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
        searchBar?.scopeButtonTitles = ["Filter By URL"]
        self.qrTableView.tableHeaderView = searchBar
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
