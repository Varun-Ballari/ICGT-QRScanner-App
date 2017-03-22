//
//  ViewController.swift
//  India Club at Georgia Tech
//
//  Created by Varun Ballari on 2/22/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet var one: UIView!
    @IBOutlet var two: UIView!
    @IBOutlet var three: UIView!
    @IBOutlet var four: UIView!
    @IBOutlet var five: UIView!
    @IBOutlet var six: UIView!
    @IBOutlet var seven: UIView!
    @IBOutlet var eight: UIView!
    @IBOutlet var nine: UIView!
    @IBOutlet var zero: UIView!

    var arr: [UIView]!
    
    @IBOutlet var dot1: UIView!
    @IBOutlet var dot2: UIView!
    @IBOutlet var dot3: UIView!
    @IBOutlet var dot4: UIView!
    @IBOutlet var dot5: UIView!
    @IBOutlet var dot6: UIView!
    
    var hiddenArr: [UIView]!
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var label6: UILabel!
    
    var labelArr: [UILabel]!

    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var hiddenStackView: UIStackView!
    
    
    var numNums: Int = 0
    var secretKey: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        
        
        arr = [one, two, three, four, five, six, seven, eight, nine, zero]

        for item in arr {
//            item.layer.cornerRadius = item.frame.size.width / 2
//            item.clipsToBounds = true
//            item.layer.borderColor = UIColor.white.cgColor
//            item.layer.borderWidth = 1.0
        }
        
        hiddenArr = [dot1, dot2, dot3, dot4, dot5, dot6]
        
        for item in hiddenArr {
            item.layer.cornerRadius = 5
        }
        
        
        labelArr = [label1, label2, label3, label4, label5, label6]
        
    }

    @IBAction func onDelete(_ sender: Any) {
        if (numNums != 0) {
            secretKey = secretKey.substring(to: secretKey.index(before: secretKey.endIndex))
            numNums -= 1
            
            UIView.animate(withDuration: 0.3, animations: {
                self.labelArr[self.numNums].alpha = 0
            }, completion: { (suceess:Bool) in
                self.labelArr[self.numNums].text = ""
                self.labelArr[self.numNums].alpha = 1

            })
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if numNums < 6 {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 0.2
            pulseAnimation.fromValue = 0
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            pulseAnimation.autoreverses = false
            pulseAnimation.repeatCount = 0
            if sender.tag == 0 {
                self.arr[9].layer.add(pulseAnimation, forKey: "animateOpacity")

            } else {
                self.arr[sender.tag - 1].layer.add(pulseAnimation, forKey: "animateOpacity")
            }
            
            secretKey = secretKey + String(sender.tag)
            labelArr[numNums].text = String(describing: sender.tag)
            if (numNums != 0) {
               labelArr[numNums - 1].text = "*"
            }

            numNums += 1
        }
        
        
        if numNums == 6 {
            let icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/checkin/ios?key=" + secretKey
            
            Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
                if let jsondata = response.result.value {
                    let json = JSON(jsondata)
                    
                    if json["success"] == true {
                        self.performSegue(withIdentifier: "gotoscan", sender: self)
                    } else {
                        self.numNums = 0

                        self.secretKey = ""
                        let animation = CABasicAnimation(keyPath: "transform.translation.x")
                        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                        animation.repeatCount = 5
                        animation.duration = 0.05
                        animation.autoreverses = true
                        animation.byValue = 10
                        self.hiddenStackView.layer.add(animation, forKey: "position")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            for item in self.labelArr {
                                item.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
}



