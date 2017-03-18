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
    
    var timer = Timer()

    var statsTable = [["0", "0"]]
    var matchTable = [["Varun Ballari", "902993193", "ICGT Memeber", "hi"]]
    
    var searchActive: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        searchbar.delegate = self

        getCounts()
//        scheduledTimerWithTimeInterval()
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
                
                //                if json[0]["success"] == true {
                
                self.matchTable.removeAll()
                for i in 0..<json[0].count {
//                    let checkins = json[i]["checkinby"]
//                    let comingto = json[i]["comingto"]
//                    let groupNum = json[i]["groupNum"]
                    let gtid = json[i]["gtid"]
                    let name = json[i]["name"]
                    let ticketid = json[i]["ticketid"]
                    
                    
                    self.matchTable.append([String(describing: ticketid), String(describing: name), String(describing: gtid)])
//                    print(self.matchTable)
                    
                }
            }
            self.table.reloadData()

        }
    }

    
    func getCounts() {
        let icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/ios/counts"
        Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
            if let jsondata = response.result.value {
                let json = JSON(jsondata)

                if json[0]["success"] == true {
                    
                    self.statsTable.removeAll()
                    for i in 0..<json[0]["counts"].count {
                        let counts = json[0]["counts"][i]
                        let checkins = json[0]["checkins"][i]
                        self.statsTable.append([String(describing: counts), String(describing: checkins)])
                    }
                }
            }
            self.table.reloadData()
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getCounts), userInfo: nil, repeats: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if (searchActive) {
                return self.matchTable.count
            }
            else {
                return self.statsTable.count
            }
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if (searchActive) {
                //            print("searching")
                let cell = tableView.dequeueReusableCell(withIdentifier: "searching", for: indexPath) as! Match_TableViewCell
                cell.ticketid.text = self.matchTable[indexPath.row][0]
                cell.name.text = self.matchTable[indexPath.row][1]
                cell.gtid.text = self.matchTable[indexPath.row][2]
                return cell
                
            } else {
                //            print("not searching")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "stats", for: indexPath) as! Counts_TableViewCell
                cell.registered.text = self.statsTable[indexPath.row][0]
                cell.checkedIn.text = self.statsTable[indexPath.row][1]
                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "copyright", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if (searchActive) {
                return 115
            } else {
                return 150
            }
        } else {
            return 115
        }
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        getMatches(searchString: searchText)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
//        searchbar.text = ""
        searchBar.showsCancelButton = true

        searchBar.resignFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        getCounts()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
//        getMatches(searchString: searchBar.text!)
        searchBar.resignFirstResponder()

    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.searchbar.resignFirstResponder()
//    }
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.searchbar.resignFirstResponder()
//
//    }
}
