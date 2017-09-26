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

    //Convert display type from string to double
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    //Call struct CalculatorBrain
    private var brain: CalculatorBrain = CalculatorBrain()
    
    //Operational buttons (+ - * / π ...)
    @IBAction func perfomOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    //Point button
    @IBAction func floatingPoint() {
        if !userIsInTheMiddleOfTyping {
            display.text = "0" + numberFormatter.decimalSeparator
        } else if !display.text!.contains(numberFormatter.decimalSeparator) {
            display.text = display.text! + numberFormatter.decimalSeparator
        }
        userIsInTheMiddleOfTyping = true
    }

    private var numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.minimumIntegerDigits = 1
        brain.numberFormatter = numberFormatter
    }
    
}

