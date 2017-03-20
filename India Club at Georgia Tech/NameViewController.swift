//
//  NameViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/20/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreData

class NameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var name: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        name.becomeFirstResponder()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print(textField.text)
        
        if textField.text == "" {
            let alert = UIAlertController(title: "Incorrect Format", message: "Please enter a valid name.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else {
            let userName  = User(context: managedObjectContext)
            userName.name = self.name.text
            
            let alert = UIAlertController(title: "Permanent Name", message: "Please make sure this is the name you want to identified by. You cannot change this later.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "This is good", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in         self.performSegue(withIdentifier: "gotokey", sender: self)
                
            }))
            self.present(alert, animated: true, completion: nil)

        }
        
        return true
    }

}
