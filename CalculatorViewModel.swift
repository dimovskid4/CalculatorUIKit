
import Foundation

class CalculatorViewModel {
    private var model = CalculatorModel()
    
    var displayText: String {
        return format(model.current)
    }
    
    func inputDigit(_ digit: String) {
        if let value = Double(digit) {
            if model.current == 0 {
                model.setOperand(value)
            } else {
                let combined = "\(Int(model.current))" + digit
                model.setOperand(Double(combined) ?? value)
            }
        }
    }
    
    func inputDecimal() {
        if !displayText.contains(".") {
            model.setOperand(Double(displayText + ".") ?? 0)
        }
    }
    
    func performOperation(_ operation: CalculatorOperation) {
        model.setOperation(operation)
    }
    
    func computeResult() {
        model.computeIfPossible()
    }
    
    func clear() {
        model.clear()
    }
    
    private func format(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        }
        return String(value)
    }
}
