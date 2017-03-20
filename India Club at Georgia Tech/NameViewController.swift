//
//  NameViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/20/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class NameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        name.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "gotokey", sender: self)
        return true
    }
}
