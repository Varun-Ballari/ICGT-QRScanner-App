//
//  SearchViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 2/28/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchbar: UISearchBar!
    
    var matchTable = [["", "", ""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        searchbar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMatches(searchString: String) {
        let icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/checkin/search?query=" + searchString
        
        Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
            if let jsondata = response.result.value {
                let json = JSON(jsondata)
//                print(json)
                
                self.matchTable.removeAll()
                for i in 0..<json.count {
                    let gtid = json[i]["gtid"]
                    let name = json[i]["name"]
                    let ticketid = json[i]["ticketid"]
                    
                    
                    self.matchTable.append([String(describing: ticketid), String(describing: name), String(describing: gtid)])
                    print(self.matchTable)
                    
                }
            }
            self.table.reloadData()

        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchTable.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Detected Code"), object: nil, userInfo: ["qrResult" : self.matchTable[indexPath.row][0]])
//        print(self.matchTable[indexPath.row][0])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "searching", for: indexPath) as! Match_TableViewCell
        cell.ticketid.text = self.matchTable[indexPath.row][0]
        cell.name.text = self.matchTable[indexPath.row][1]
        cell.gtid.text = self.matchTable[indexPath.row][2]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getMatches(searchString: searchText)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.resignFirstResponder()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchbar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchbar.resignFirstResponder()

    }
}
