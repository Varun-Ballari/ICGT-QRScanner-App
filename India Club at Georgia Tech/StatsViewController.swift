//
//  StatsViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/19/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    var statsTable = [["0", "0"]]
    var timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        getCounts()
        scheduledTimerWithTimeInterval()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.statsTable.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stats", for: indexPath) as! Counts_TableViewCell
            cell.registered.text = self.statsTable[indexPath.row][0]
            cell.checkedIn.text = self.statsTable[indexPath.row][1]
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selfstats", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "copyright", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            return 44
        } else {
            return 150
            
        }
    }


    
}
