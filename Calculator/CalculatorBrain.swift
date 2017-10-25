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
    private var internalProgram = [AnyObject]() // stores an array of objects (operands)that are doubles and strings (operations)
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject) // operand is a double / struct but the bridging to the NSObject class
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
        internalProgram.append(symbol as AnyObject)
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
    typealias PropertyList = AnyObject // typeAlias lets us create a type -
    var program: PropertyList { // set a new type for documentation purposes
        get {
            return internalProgram as CalculatorBrain.PropertyList // return internal data structure to public caller BUT
            // when we return a value type we return a copy of that value type
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
            
        }
        
    }
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
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

