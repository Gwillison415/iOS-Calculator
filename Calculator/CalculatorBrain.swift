//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Grant Willison on 9/23/17.
//  Copyright © 2017 Grant Willison. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
  
    
    
    private var operations: Dictionary<String, Operation> = [ //generic type so we speciify keys / values
        //dictionary is also technically a value type
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "=" : Operation.Equals,
        ]
    
    //enum is a type - disrete set of values - but like classes can have methods - can't have vars or inheritance
    private enum Operation { // discrete set of values enums in swift are allowed to have methods
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    } // passed by value, cannot inherit, has ascociated value
    
    
    func performOperation(symbol : String)  {  // if below will ignore ops it doesn't understand
        if let  operation = operations[symbol] { // [] == lookup in ops dict
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation (let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            
            }
        }
    }
    private var pending: PendingBinaryOperationInfo?
    private struct PendingBinaryOperationInfo { //struct (has vars & computed vars) PASSED BY VALUE
        // free initializers are all of a struct's vars
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    private func executePendingBinaryOperation(){
        if pending != nil {
            // if i have a pending operation then evaluate
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    var result: Double {
        get {
            return accumulator
        }
    }
    
}

//var operations: [String, Operation] = [
//"π" : Operation.Constant(Double.pi),
//"e" : Operation.Constant(Double.Exponent),
//"√" : Operation.UnaryOperation
//]

