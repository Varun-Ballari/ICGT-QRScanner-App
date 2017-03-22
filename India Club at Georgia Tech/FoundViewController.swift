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

    var buttonsTitles = ["", ""]
    var buttonTypes = [false, false]
    
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
        
        table.allowsSelection = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if (found) {
            return 3
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
            } else {
                return buttonsTitles.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath.section, indexPath.row)
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

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! Button_TableViewCell
                
                cell.cellButton.setTitle(self.buttonsTitles[indexPath.row], for: .normal)
                
                cell.cellButton.addTarget(self, action: #selector(postRequest(button:)), for: UIControlEvents.touchUpInside)
                
                cell.cellButton.tag = indexPath.row + 1
                cell.cellButton.layer.cornerRadius = 5
                cell.cellButton.layer.borderWidth = 1.0

            
                if self.buttonTypes[indexPath.row] {
                    cell.cellButton.layer.borderColor = UIColor.init(rgb: 0x4898FA, alpha: 1.0).cgColor
                    cell.cellButton.backgroundColor = UIColor.init(rgb: 0x4898FA, alpha: 1.0)
                    cell.cellButton.isEnabled = true
                    cell.cellButton.setTitleColor(UIColor.init(rgb: 0xFFFFFF, alpha: 1.0), for: .normal)
                
                } else {
                    cell.cellButton.layer.borderColor = UIColor.init(rgb: 0xF95358, alpha: 1.0).cgColor
                    cell.cellButton.backgroundColor = UIColor.clear
                    cell.cellButton.isEnabled = false
                    cell.cellButton.setTitleColor(UIColor.init(rgb: 0xF95358, alpha: 1.0), for: .normal)
                }

                
                return cell
            
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            return cell
        }
    }
    
    func buttonPressed(button: UIButton) {
        if button.isEnabled {
            print("You have clicked \(button.tag)")
            print(button.titleLabel?.text)
        } else {
            
        }
        print("You have clicked \(button.tag)")
        print(button.titleLabel?.text)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if found {
            if indexPath.section == 0 {
                return 88
            } else if indexPath.section == 1 {
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
                
                
                if json.count != 0 {
                    self.found = true
                    self.attendeeName = String(describing: json[0]["name"])
                    
                    self.ticketData[0] = String(describing: json[0]["ticketid"])
                    
                    self.ticketData[1] = String(describing: json[0]["gtid"])
                    
                    if (json[0]["gtid"] == nil) {
                        self.ticketData[2] = "Non-Member/Guest"
                    } else {
                        self.ticketData[2] = "ICGT Member"
                    }

                    self.ticketData[3] = String(describing: json[0]["groupNum"])

                    for i in 0..<json[0]["comingto"].count {
                        if (json[0]["comingto"][i] == false) {
                            // not coming to part i
                            self.buttonsTitles[i] = "Not registered for Part " + String(i)
                            self.buttonTypes[i] = false
                        } else {
                            // coming to part i
                            if (json[0]["checkinby"][i] == nil) {
                                // not checked in
                                self.buttonsTitles[i] = "Check In for Part " + String(i)
                                self.buttonTypes[i] = true
                                
                            } else {
                                // checked in already
                                self.buttonsTitles[i] = "Already Checked in by " + String(describing: json[0]["checkinby"][i]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                self.buttonTypes[i] = false
                            }
                        }
                    }
                    print(json)
                
                } else {
                    self.found = false
                }
                
                self.table.reloadData()
            }
        }
    }
    
    
    func postRequest(button: UIButton) {
        
        let icgtposturl: String = "https://tickets.gtindiaclub.com/api/checkin"

        
        let params: Parameters = [
            "day": button.tag,
            "ticketId": Int(ticketData[0]),
            "staff": String(describing: user[0].name!)
        ]
        
        Alamofire.request(icgtposturl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
            if let jsondata = response.result.value {
                let json = JSON(jsondata)
                    
                    
                if json["success"] == true {
                    button.setTitle("Checked In", for: .disabled)
                    self.table.reloadData()
                    print("Successfully Checked In")
                } else {
                    let alert = UIAlertController(title: "Error!", message: "Something went terribly wrong. Contact VP IT immediately." + String(describing: json["error"]), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
