//
//  ViewController.swift
//  StupidCalculator - A calculator that works on two numbers at any given time
//
//  Created by Krishna Kishore Shetty on 9/4/16.
//  Copyright © 2016 Krishna Kishore Shetty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Reference to the main label where the results are shown
    @IBOutlet weak var resultLabel: UILabel!
    
    // This variable stores the state of the calculator.
    var calculatorState: CalculatorState = CalculatorState.FIRST_NUM_ENTRY
    
    // This variable stores the first number
    var firstNumberString: String = ""
    
    // This variable stores the second number
    var secondNumberString: String = ""
    
    // This stores the operation chosen by the user. Store default value of nothing
    var chosenOperator: Operator = .NOTHING
    
    // The final result of the operation. Stored as we sometimes need it to continue.
    var finalResult: Double = 0
    
    @IBAction func numberClicked(_ sender: UIButton) {
        switch calculatorState {
            
        // Continue entry of the first number. If its empty, start with the first digit, which is the button's tag
        case .FIRST_NUM_ENTRY:
            if(firstNumberString == "") {
                firstNumberString = String(Double(sender.tag))
            } else {
                // Handle addition of digits to an already present number, by multiplying the first number by 10
                // and then adding the digit
                firstNumberString = String(((Double(firstNumberString)!*10)+Double(sender.tag)))
            }
            
        // Continue the entry of the second number
        case .SECOND_NUM_ENTRY:
            if(secondNumberString == "") {
                secondNumberString = String(Double(sender.tag))
            } else {
                // Handle addition of digits to an already present number, by multiplying the first number by 10
                // and then adding the digit
                secondNumberString = String(((Double(secondNumberString)!*10)+Double(sender.tag)))
            }
        // User entering a number after choosing an operator. Start accepting the second number
        case .OPERATOR_ENTRY:
            calculatorState = .SECOND_NUM_ENTRY
            // If first number was not entered
            secondNumberString = String(Double(sender.tag))
            
        // User entered a number after calculating a result. Reset the calculator
        case .CALCULATE_RESULT:
            resetCalculator()
            firstNumberString = String(Double(sender.tag))
        }
        
        updateResultLabel(calculateResult: false)
    }
    
    @IBAction func operatorClicked(_ sender: UIButton) {
        switch calculatorState {
            
        // User clicks on operator after finishing first number entry. Set the chosen operator,
        // and update result label(done in last line of function).
        // First number may be empty, and user may have directly proceeded to enter an operator
        // In that case, we will assume first number as zero.
        case .FIRST_NUM_ENTRY:
            if(firstNumberString == "") {
                firstNumberString = "0.0"
            }
            calculatorState = .OPERATOR_ENTRY
            chosenOperator = TAG_TO_OPERATOR_DICT[sender.tag]!
            
        // User chose operator after choosing second number.
        // Which means the user will enter a number after this, which she wants applied to
        // the result of executing the previous operator on the previous two numbers
        case .SECOND_NUM_ENTRY:
            // Show result of previous operation
            updateResultLabel(calculateResult: true)
            
            // Set result of previous operation as firstNumber, and reset second number
            firstNumberString = String(format: "%.2f", finalResult)
            secondNumberString = ""
            
            // Change state to operator entry
            calculatorState = .OPERATOR_ENTRY
            
            // And of course, set the operator, and show it in the result label(taken care
            // of by the last line in this function)
            chosenOperator = TAG_TO_OPERATOR_DICT[sender.tag]!
            
        // User already entered an operator. And now she's entering another one
        // Just update the operator. No state change
        case .OPERATOR_ENTRY:
            chosenOperator = TAG_TO_OPERATOR_DICT[sender.tag]!
            
        // User has entered an operator after a previous result has been calculated
        // which indicates she wants to continue the session.
        // This is similar to the .SECOND_NUM_ENTRY case, except we already have the result calculated
        // No harm in doing it again. Change state and call the IBAction recursively
        case .CALCULATE_RESULT:
            calculatorState = .SECOND_NUM_ENTRY
            operatorClicked(sender)
            
        }
        
        // Put outside switch case block, as it is common to all the cases
        updateResultLabel(calculateResult: false)
        
    }
    
    @IBAction func equalsClicked(_ sender: UIButton) {
        switch calculatorState {
            
        // User pressed equals after second number entry. Calculate result and update result label
        case .SECOND_NUM_ENTRY:
            calculatorState = .CALCULATE_RESULT
            updateResultLabel(calculateResult: true)
            
        // User pressed equals after first number entry. Don't do anything
        case .FIRST_NUM_ENTRY: fallthrough
            
        // User pressed equals after choosing an operator. Don't do anything
        case .OPERATOR_ENTRY: fallthrough
            
        // User pressed equals after calculating a result. Don't do anything
        case .CALCULATE_RESULT: fallthrough
            
        default: break
        }
    }
    
    // Called when the clear button is clicked
    @IBAction func clearClicked(_ sender: UIButton) {
        // Just reset the calculator
        resetCalculator()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Reset the calculator
        resetCalculator()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateResultLabel(calculateResult: Bool) {
        if(!calculateResult) {
            resultLabel.text = firstNumberString + OPERATOR_TO_STRING_DICT[chosenOperator]! + secondNumberString
        } else {
            
            // Calculate the result, and store it in finalResult
            
            switch chosenOperator {
            case Operator.ADDITION:
                finalResult = Double(firstNumberString)! + Double(secondNumberString)!
            case Operator.SUBTRACTION:
                finalResult = Double(firstNumberString)! - Double(secondNumberString)!
            case Operator.MULTIPLICATION:
                finalResult = Double(firstNumberString)! * Double(secondNumberString)!
            case Operator.DIVISION:
                // If division by zero encountered, reset calculator
                if Double(secondNumberString) == 0 {
                    resultLabel.text = "DIV/0 !"
                    resetCalculator()
                    return
                }
                
                finalResult = Double(firstNumberString)! / Double(secondNumberString)!
            default:
                return
            }
            
            resultLabel.text = String(format: "%.2f", finalResult)
        }
    }
    
    func resetCalculator() {
        calculatorState = .FIRST_NUM_ENTRY
        firstNumberString = ""
        secondNumberString = ""
        finalResult = 0.0
        chosenOperator = .NOTHING
        
        resultLabel.text = "0.0"
    }
    
    
}
