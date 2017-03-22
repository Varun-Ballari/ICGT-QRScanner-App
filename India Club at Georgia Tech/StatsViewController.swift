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
import CoreData

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    var statsTable = [["0", "0"]]
    var selfStats = ["0"]
    var subevents = ["0"]
    
    @IBOutlet var eventName: UILabel!
    
    var timer = Timer()

    var user = [User]()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest:  NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        

        
        table.delegate = self
        table.dataSource = self
        
        getCounts()
        scheduledTimerWithTimeInterval()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getCounts() {
        let icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/checkin/counts?user=" + String(describing: user[0].name!)
        Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
            if let jsondata = response.result.value {
                let json = JSON(jsondata)
                
                if json["success"] == true {
                    
                    self.statsTable.removeAll()
                    self.selfStats.removeAll()
                    self.subevents.removeAll()
                    
                    self.eventName.text = String(describing: json["eventName"])
                    
                    
                    for i in 0..<json["subevents"].count {

                        self.statsTable.append([String(describing: json["counts"][i]), String(describing: json["checkins"][i])])
                        self.selfStats.append(String(describing: json["userStats"][i]))
                        self.subevents.append(String(describing: json["subevents"][i]))

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
        } else if section == 1 {
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
            cell.eventName.text = self.subevents[indexPath.row] as? String
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selfstats", for: indexPath) as! SelfStat_TableViewCell
            cell.count.text = self.selfStats[indexPath.row] as? String
            
            var string: String = self.subevents[indexPath.row] as! String
            cell.label.text = "Your " + string + " Checkin Count"
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
