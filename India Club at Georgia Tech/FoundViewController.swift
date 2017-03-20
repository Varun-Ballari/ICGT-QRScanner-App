//
//  FoundViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/20/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class FoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var attendeeName = ""

    var ticketDataTypes = ["Ticket ID", "GTID", "Status", "Group"]
    var ticketData = ["", "", "", ""]
    
    var checkinDataTypes = ["Holi Show Checkin by", "After Party Checkin By"]
    var checkinData = ["", ""]

    var buttons = ["Check Into Holi Show", "Check Into After Party"]
    var buttonTypes = [UIControlState.disabled, UIControlState.normal]
    
    var found : Bool = true
    
    @IBOutlet var table: UITableView!
    
    var user = [User]()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet var checkinby_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkDB(notification:)), name: NSNotification.Name(rawValue: "Detected Code"), object: nil)
        
        let fetchRequest:  NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedContext.fetch(fetchRequest)
            checkinby_label.text = "Check in by " + String(describing: user[0].name!)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if (found) {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if found {
            if section == 0 {
                return 1
            } else if section == 1 {
                return ticketData.count
            } else if section == 2 {
                return checkinData.count
            } else {
                return buttons.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section, indexPath.row)
        if found {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "attendee", for: indexPath) as! Attendee_TableViewCell
                cell.name.text = self.attendeeName
                return cell
                
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! Details_TableViewCell
                cell.labelType.text = ticketDataTypes[indexPath.row] 
                cell.result.text = ticketData[indexPath.row] 
                return cell
                
            } else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkin", for: indexPath) as! Checkin_TableViewCell
                cell.labelType.text = checkinDataTypes[indexPath.row]
                cell.result.text = checkinData[indexPath.row] 
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! Button_TableViewCell
                cell.buttonLabel.setTitle(buttons[indexPath.row] , for: buttonTypes[indexPath.row])
                return cell
            
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if found {
            if indexPath.section == 0 {
                return 88
            } else if indexPath.section == 1 {
                return 44
            } else if indexPath.section == 2 {
                return 44
            } else {
                return 60
            }
        } else {
            return 220
        }
    }
    
    
    func checkDB(notification: Notification) {
        guard let query = notification.userInfo!["qrResult"] else { return }
        
        print(query)
        
        let icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/checkin/search?query=" + (query as! String)
        Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
            if let jsondata = response.result.value {
                let json = JSON(jsondata)
                
                
                if json[0]["sucess"] == true {
                    self.found = true
                    self.attendeeName = String(describing: json[0]["name"])
                    
                    self.ticketData[0] = String(describing: json[0]["ticketid"])
                    
//                    if (json[0]["gtid"] == nil) {
//                        status = "Non-Member/Guest"
//                    }
                    self.ticketData[1] = String(describing: json[0]["gtid"])
                    self.ticketData[3] = String(describing: json[0]["groupNum"])

//                    self.checkinData = json[0]["checkinby"]
//                    self.comingTo = json[0]["comingto"]
                
                } else {
                    self.found = false
                }
                
                self.table.reloadData()
            }
        }
    }
    
    
    func postRequest() {
        
        let icgtposturl: String = "https://tickets.gtindiaclub.com/api/checkin/search?query="

        
        let params: Parameters = [
            "stripeToken": "token_id",
            "name": "cnoon",
            "email": "cnoon@alamofire.org"
        ]
        
        Alamofire.request(icgtposturl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }
    
    
}


//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
