//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Shantal Ewell on 9/21/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segementControl: UISegmentedControl!
    @IBOutlet weak var lightDark: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        //made color of segmented control title always be black
        segementControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    

    @IBAction func segmentedControlAction(_ sender: Any) {
        //saving key and values for percentage in user defaults
        UserDefaults.standard.set(segementControl.selectedSegmentIndex, forKey: "percentageSelection")
    }
    
    
    @IBAction func lightDarkControl(_ sender: Any?) {
        //change background color of view based on what is selected
        if (lightDark.selectedSegmentIndex == 1){
           view.overrideUserInterfaceStyle = .dark
            lightDark.backgroundColor = .gray
        }else{
            view.overrideUserInterfaceStyle = .light
        }
        
        //saving key and values for light/dark mode selection in user defaults
        UserDefaults.standard.set(lightDark.selectedSegmentIndex, forKey: "lightOrDark")
    }
    
    //this function will display saved values from user defaults when this view appears
    override func viewWillAppear(_ animated: Bool) {
        
         let defaults = UserDefaults.standard
        
         //retrirving percentageSelection amount and light/dark mode from user defaults
         segementControl.selectedSegmentIndex = defaults.integer(forKey: "percentageSelection")
         lightDark.selectedSegmentIndex = defaults.integer(forKey: "lightOrDark")
        
        //display mode selected
         lightDarkControl(nil)
    }
    
    
}
