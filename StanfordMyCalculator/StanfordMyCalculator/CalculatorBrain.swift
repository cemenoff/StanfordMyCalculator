//
//  CalculatorBrain.swift
//  StanfordMyCalculator
//
//  Created by Anton Semenov on 25/09/2017.
//  Copyright © 2017 Anton Semenov. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    //Internal
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clearDisplay
    }
    
    
    //Dictionary with operations
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals,
        "C" : Operation.clearDisplay
    ]
    
    //Public
    //Get result (read only). Optional because not set before perform operation
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    
    //Mutating bacuase it changes the value of struct because of "copy-write"
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            //value == operation.constant(...). associated value
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clearDisplay:
                accumulator = 0
                pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    weak var numberFormatter: NumberFormatter?
    
    //Mutating bacuase it changes the value of struct because of "copy-write"
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    
    }
    
    
}




