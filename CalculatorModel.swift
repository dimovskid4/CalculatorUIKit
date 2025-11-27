
import Foundation

enum CalculatorOperation {
    case add, subtract, multiply, divide, none
}

struct CalculatorModel {
    private(set) var current: Double = 0
    private(set) var stored: Double? = nil
    private(set) var pendingOperation: CalculatorOperation = .none

    mutating func setOperand(_ value: Double) {
        current = value
    }
    
    mutating func setOperation(_ operation: CalculatorOperation) {
        if pendingOperation != .none, let stored = stored {
            current = CalculatorModel.performOperation(lhs: stored, rhs: current, operation: pendingOperation)
        }
        self.stored = current
        pendingOperation = operation
    }
    
    mutating func computeIfPossible() {
        if let stored = stored {
            current = CalculatorModel.performOperation(lhs: stored, rhs: current, operation: pendingOperation)
            self.stored = nil
            pendingOperation = .none
        }
    }
    
    mutating func clear() {
        current = 0
        stored = nil
        pendingOperation = .none
    }
    
    private static func performOperation(lhs: Double, rhs: Double, operation: CalculatorOperation) -> Double {
        switch operation {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs == 0 ? 0 : lhs / rhs
        case .none: return rhs
        }
    }
}
