//
//  ViewController.swift
//  RangeSliderExample
//
//  Created by Alexander Naumov on 13.02.16.
//  Copyright © 2016 Alexander Naumov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func sliderAction(sender: RangeSlider) {
        label1.text = "\(Int(sender.selectedMin))"
        label2.text = "\(Int(sender.selectedMax))"
    }
    
}

