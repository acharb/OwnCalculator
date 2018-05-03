
import Foundation


class BrainCalculator {
    
    // MARK: Properties
    
    private var accumulator: Double = 0.0
    
    var result: Double {
        get{
            return accumulator
        }
    }
    
    private var operationLookUp: Dictionary<String, Operation> = [
        "π": .Constant(Double.pi),
        "e": .Constant(M_E),
        "cos": .UnaryOperation(cos),
        "1/x": .UnaryOperation({1 / $0} ),
        "+": .BinaryOperation({$0 + $1}),
        "-": .BinaryOperation({$0 - $1}),
        "/": .BinaryOperation({$0 / $1}),
        "x": .BinaryOperation({$0 * $1}),
        "C": .Clear,
        "=": .Equals
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    
    // MARK: Functions
    
    func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    func executePendingBinaryOperation(){
        if let pending = pendingBinaryOperation {
            accumulator = pending.operation(pending.firstValue,accumulator)
        }
    }
    
    func operation(_ symbol: String){
        if let operation = operationLookUp[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .Equals:
                executePendingBinaryOperation()
                pendingBinaryOperation = nil
            case .Clear:
                accumulator = 0.0
                pendingBinaryOperation = nil
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pendingBinaryOperation = PendingBinaryOperation(firstValue: accumulator, operation: function)
            }
        }
    }
    
    struct PendingBinaryOperation {
        var firstValue: Double
        var operation: (Double,Double) -> Double
    }
    
    enum Operation {
        case UnaryOperation((Double) -> Double )
        case BinaryOperation( (Double,Double) -> Double )
        case Constant(Double)
        case Equals
        case Clear
    }
    
}
