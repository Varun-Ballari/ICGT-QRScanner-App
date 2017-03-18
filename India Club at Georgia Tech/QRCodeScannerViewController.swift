
//  QRCodeScannerViewController.swift
//  India Club at Georgia Tech
//
//  Created by Varun Ballari on 2/23/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox.AudioServices
import Alamofire
import SwiftyJSON


class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var qrResult: String!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
//            view.bringSubview(toFront: messageLabel)
//            view.bringSubview(toFront: topbar)
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR/barcode is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                qrResult = metadataObj.stringValue
                
                print(qrResult)
                captureSession?.stopRunning()
                
                checkDB(query: metadataObj.stringValue)
                
//                self.performSegue(withIdentifier: "found", sender: qrResult)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "found" {
            let nextScene = segue.destination as! UINavigationController
            let nextVC = nextScene.viewControllers[0] as! FoundViewController
            nextVC.qrValuePassedOn = sender as! String
        } else {
            let nextScene = segue.destination.navigationController?.viewControllers[0] as! ViewController

        }
        
    }
    
    func checkDB(query: String!) {
//        print(query)
        var icgtsearchurl: String = "https://tickets.gtindiaclub.com/api/ios/search?query=" + query
        Alamofire.request(icgtsearchurl, method: .get).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let jsondata = response.result.value {
                let json = JSON(jsondata)

//                print("JSON: \(json)")
                
                if json[0]["sucess"] == true {
                    self.performSegue(withIdentifier: "found", sender: self)
                } else {
                    self.performSegue(withIdentifier: "notfound", sender: self)
                }
                
//                for item in json[0]["checkinby"].arrayValue {
//                    if (item == null) {
//                        self.performSegue(withIdentifier: "found", sender: self)
//                    } else {
//                        self.performSegue(withIdentifier: "found", sender: self)
//                    }
//                }
//
//                if let checkinby = Array(json["checkinby"]) {
//                    
//                }
            }
            
//            if JSON["error"]
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
