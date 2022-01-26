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

    override func viewDidLoad() {
        super.viewDidLoad()
        pagesTableView.delegate = self
        pagesTableView.dataSource = self
        self.pagesTableView.register(UINib(nibName: "PagesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    

  

}

//MARK:  UITableViewDataSource, UITableViewDelegate

extension LastReadedPageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let results = realm.objects(pastSites.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PagesTableViewCell {
            
            cell.cellsURL.text = results[indexPath.row].url
            cell.cellsDate.text = results[indexPath.row].date
            
            return cell
        }
          
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = realm.objects(pastSites.self)
        return results.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let results = realm.objects(pastSites.self)
        UIApplication.shared.open((URL(string: String(results[indexPath.row].url!)))!)
      
    }
}
