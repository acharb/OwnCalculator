
import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var displayLabel: UILabel!
    private var brain = BrainCalculator()
    private var middleOfTyping = false
    private var displayDouble: Double! {
        get {
            return Double(displayLabel!.text!)
        }
        set{
            displayLabel.text = String(newValue)
        }
    }
    
    // MARK: Actions
    
    @IBAction func digitButton(_ sender: UIButton) {
        let digit: String! = sender.currentTitle
        var currentDisplay: String! = displayLabel.text
        
        if digit == "." {
            if displayDouble == 0.0 {
                displayLabel.text = "."
            }
            else if displayLabel!.text!.contains("."){
                return
            }
        }
        
        if middleOfTyping {
            currentDisplay.append(digit)
            displayLabel.text = currentDisplay
        }else {
            displayLabel.text = digit
            middleOfTyping = true
        }
    }
    
    @IBAction func operationButton(_ sender: UIButton) {
        brain.setOperand(displayDouble)
        middleOfTyping = false
        if let symbol = sender.currentTitle {
            brain.operation(symbol)
        }
        displayDouble = brain.result
    }
}

