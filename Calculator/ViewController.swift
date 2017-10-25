//
//  ViewController.swift
//  Calculator
//
//  Created by Grant Willison on 9/23/17.
//  Copyright © 2017 Grant Willison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    private var userIsInTheMiddleOfTyping = false // all properties must have initial value
    
    @IBOutlet weak var theButtonDisplay: UILabel!

    @IBAction private func touchDigitMethod(sender: UIButton ) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = theButtonDisplay!.text! // get associated value out of the optional display with bang ! unwrap
            //text is an optional on UILabel, so unwrap that also
            theButtonDisplay!.text = textCurrentlyInDisplay + digit // while seeting a value to string we call set method and use this as associated value
        } else {
            theButtonDisplay!.text = digit
        }
        userIsInTheMiddleOfTyping = true

    }
    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    var displayValue: Double{
        get {
            return Double(theButtonDisplay!.text!)!
        }
        set {
            theButtonDisplay!.text = String(newValue) //newvalue - special keyword -  will be the Double when displayValue is set
        }
    }
    private var brain = CalculatorBrain()
    @IBAction private func performOperation( sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)

        }
        displayValue = brain.result
    }
//cdp10047

}

