//
//  LastReadedPageViewController.swift
//  QR_Reader
//
//  Created by MacBook Air on 26.01.2022.
//

import UIKit
import RealmSwift

class LastOpenedPageViewController: UIViewController {

    @IBOutlet weak var pagesTableView: UITableView!
    let realm = try! Realm()
    var realmArray: [pastSites]? = []
    var counter = 0
    
    var filteredData : [pastSites]? = []
    var searchBar : UISearchBar?
    var searchBarArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pagesTableView.delegate = self
        pagesTableView.dataSource = self
        self.pagesTableView.register(UINib(nibName: "PagesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        getDataFromRealm()
        searchBarSetup()
        
        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        keyboardGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(keyboardGestureRecognizer)
    }
    
    func getDataFromRealm(){
        let results = realm.objects(pastSites.self)
        for result in results {
            realmArray?.append(result)
            searchBarArray.append(result.url ?? "")
        }
        self.filteredData = self.realmArray
    }
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QrAppViewController") as! QrCameraAppViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func lastReadedButtonClicked(_ sender: Any) {
        if counter == 1 {
            let indexPath = IndexPath(row: 0, section: 0)
            pagesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }

    }
    @IBAction func createQRButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! LastCreatedQRViewController
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension LastOpenedPageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PagesTableViewCell {
            cell.cellsURL.text = filteredData?[indexPath.row].url
            cell.cellsDate.text = filteredData?[indexPath.row].date
            
            return cell
        }
          
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: String(realmArray?[indexPath.row].url ?? "")){
            UIApplication.shared.open(url)
        }
        if let phoneNumber = realmArray?[indexPath.row].url {
            guard let url = URL(string: "telprompt://\(phoneNumber)"),
                    UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      
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
                let results = realm.objects(pastSites.self).filter("url='\(url)'")
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
extension LastOpenedPageViewController : UISearchBarDelegate {
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
        self.pagesTableView.reloadData()
    }
    
    func searchBarSetup(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        searchBar?.showsScopeBar = true
        searchBar?.delegate = self
        searchBar?.scopeButtonTitles = ["Filter By URL"]
        self.pagesTableView.tableHeaderView = searchBar
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
