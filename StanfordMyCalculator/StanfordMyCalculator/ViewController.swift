//
//  ViewController.swift
//  StanfordMyCalculator
//
//  Created by Anton Semenov on 22/09/2017.
//  Copyright © 2017 Anton Semenov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Display
    @IBOutlet weak var display: UILabel!
    
    //Learn where user is begining of typing
    var userIsInTheMiddleOfTyping = false
    
    //Buttons
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        //If user is typing or not
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    //Move display from string to double
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    
    //Operational buttons (+ - * / π ...)
    @IBAction func perfomOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle {
            switch mathSymbol {
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)
            default:
                break
            }
        }
    }
    
}

