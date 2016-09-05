//
//  CalculatorUtils.swift
//  StupidCalculator
//
//  Created by Krishna Kishore Shetty on 9/4/16.
//  Copyright © 2016 Krishna Kishore Shetty. All rights reserved.
//

import Foundation

// The Enum that contains the various states the calculator can be in
enum CalculatorState: String {
    case FIRST_NUM_ENTRY = "FIRST_NUM_ENTRY"
    
    case OPERATOR_ENTRY = "OPERATOR_ENTRY"
    
    case SECOND_NUM_ENTRY = "SECOND_NUM_ENTRY"
    
    case CALCULATE_RESULT = "CALCULATE_RESULT"
}

// The Enum which stores the four possible operations in the calculator
enum Operator: String {
    case ADDITION = "ADDITION"
    case SUBTRACTION = "SUBTRACTION"
    case MULTIPLICATION = "MULTIPLICATION"
    case DIVISION = "DIVISION"
    case NOTHING = ""
}

// A dictionary that maps the tags of the operator buttons to their respective Operator Enum values
let TAG_TO_OPERATOR_DICT: [Int: Operator] = [
    10: Operator.ADDITION,
    11: Operator.SUBTRACTION,
    12: Operator.MULTIPLICATION,
    13: Operator.DIVISION
]

let OPERATOR_TO_STRING_DICT: [Operator: String] = [
    Operator.ADDITION: "+",
    Operator.SUBTRACTION: "-",
    Operator.MULTIPLICATION: "*",
    Operator.DIVISION: "/",
    Operator.NOTHING: ""
]
