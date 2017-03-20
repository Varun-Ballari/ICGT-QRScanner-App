//
//  PagerUIViewController.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/19/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Pager

class PagerUIViewController: PagerController, PagerDataSource {

    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        //Setting Status Bar to be white instead of black
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Instantiating Storyboard ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller1 = storyboard.instantiateViewController(withIdentifier: "statistics")
        let controller2 = storyboard.instantiateViewController(withIdentifier: "search")
        let controller3 = storyboard.instantiateViewController(withIdentifier: "found")

        
        self.setupPager(
            tabNames: ["Event Stats", "Search", "QR Results"],
            tabControllers: [controller1, controller2, controller3])
        
        customizeTab()
    }
    
    // Customising the Tab's View
    func customizeTab() {
        indicatorColor = UIColor.black
        tabsViewBackgroundColor = UIColor.init(rgb: 0xF7F6F2, alpha: 1)
//        contentViewBackgroundColor = UIColor.gray.withAlphaComponent(0.32)
        
        startFromSecondTab = false
        centerCurrentTab = true
        tabLocation = PagerTabLocation.top
        tabHeight = 40
        tabOffset = 0
        tabWidth = self.view.frame.width / 3
        fixFormerTabsPositions = true
        fixLaterTabsPosition = true
        animation = PagerAnimation.during
        selectedTabTextColor = .black
        tabsTextFont = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        indicatorHeight = 2
        
        
        tabTopOffset = 10.0
        tabsTextColor = UIColor.init(rgb: 0x7D7C79, alpha: 1)
    }
    
    
    // Programatically selecting a tab. This function is getting called on AppDelegate
    func changeTab() {
        self.selectTabAtIndex(4)
    }
}
