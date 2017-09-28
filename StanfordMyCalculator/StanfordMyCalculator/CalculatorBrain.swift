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
        case unaryOperation((Double) -> Double, ((String) -> String)?)
        case binaryOperation((Double,Double) -> Double, ((String, String) -> String)?)
        case equals
    }
    
    private var descriptionAccumulator: String?
    
    var description: String? {
        get {
            if pendingBinaryOperation == nil {
                return descriptionAccumulator
            } else {
                return  pendingBinaryOperation!.descriptionFunction (
                    pendingBinaryOperation!.descriptionOperand, descriptionAccumulator ?? "")
            }
        }
    }
    
    
    //Dictionary with operations
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, nil),
        "cos" : Operation.unaryOperation(cos, nil),
        "±" : Operation.unaryOperation({ -$0 }, nil),
        "×" : Operation.binaryOperation(*, nil),
        "÷" : Operation.binaryOperation(/, nil),
        "+" : Operation.binaryOperation(+, nil),
        "-" : Operation.binaryOperation(-, nil),
        "=" : Operation.equals
    ]
    
    //Public
    //Get result (read only). Optional because not set before perform operation
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    //Mutating bacuase it changes the value of struct because of "copy-write"
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            //value == operation.constant(...). associated value
            case .constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .unaryOperation(let function, var descriptionFunction):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    if  descriptionFunction == nil{
                        descriptionFunction = {symbol + "(" + $0 + ")"}
                    }
                    descriptionAccumulator = descriptionFunction!(descriptionAccumulator!)
                }
            case .binaryOperation(let function, var descriptionFunction):
                performPendingBinaryOperation()
                if accumulator != nil {
                    if  descriptionFunction == nil{
                        descriptionFunction = {$0 + " " + symbol + " " + $1}
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function,
                                                                    firstOperand: accumulator!,
                                                                    descriptionFunction: descriptionFunction!,
                                                                    descriptionOperand: descriptionAccumulator!)
                    accumulator = nil
                    descriptionAccumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            descriptionAccumulator = pendingBinaryOperation!.performDescription(with: descriptionAccumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
        func performDescription (with secondOperand: String) -> String {
            return descriptionFunction ( descriptionOperand, secondOperand)
        }
    }
    
    mutating func clear() {
        accumulator = nil
        pendingBinaryOperation = nil
        descriptionAccumulator = " "
    }
    
    weak var numberFormatter: NumberFormatter?
    
    //Mutating bacuase it changes the value of struct because of "copy-write"
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if let value = accumulator {
            descriptionAccumulator = formatter.string(from: NSNumber(value:value)) ?? ""
        }
    }
    
    
}

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 6
    formatter.notANumberSymbol = "Error"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
    
} ()




