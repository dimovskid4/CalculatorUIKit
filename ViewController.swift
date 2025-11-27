

import UIKit


class ViewController: UIViewController {

    var currentText = "0"
    var firstNumber: Double? = nil
    var op: String? = nil

    let resultLabel = UILabel()
    var buttons: [[UIButton]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // result label
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.text = currentText
        resultLabel.font = UIFont.systemFont(ofSize: 40)
        resultLabel.textAlignment = .right
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

        let titles: [[String]] = [
            ["C", "+/-", "%", "/"],
            ["7", "8", "9", "x"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "="]
        ]

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        for rowTitles in titles {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            for t in rowTitles {
                let b = UIButton(type: .system)
                b.setTitle(t, for: .normal)
                b.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                b.backgroundColor = colorFor(t)
                b.setTitleColor(.white, for: .normal)
                b.layer.cornerRadius = 8
                b.translatesAutoresizingMaskIntoConstraints = false
                b.heightAnchor.constraint(equalToConstant: 56).isActive = true
                if t == "0" {
                    // make 0 a bit wider (beginner way)
                    b.widthAnchor.constraint(equalToConstant: 120).isActive = true
                } else {
                    b.widthAnchor.constraint(equalToConstant: 56).isActive = true
                }
                b.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
                row.addArrangedSubview(b)
            }
            mainStack.addArrangedSubview(row)
        }

        update()
    }

    func colorFor(_ t: String) -> UIColor {
        if t == "+" || t == "-" || t == "x" || t == "/" {
            return .systemOrange
        } else if t == "C" {
            return .systemRed
        } else if t == "=" {
            return .systemGreen
        }
        return .systemGray
    }

    @objc func tap(_ sender: UIButton) {
        guard let t = sender.title(for: .normal) else { return }
        switch t {
        case "0","1","2","3","4","5","6","7","8","9":
            if currentText == "0" {
                currentText = t
            } else {
                currentText += t
            }
        case ".":
            if currentText.contains(".") == false {
                currentText += "."
            }
        case "+":
            setOp("+")
        case "-":
            setOp("-")
        case "x":
            setOp("x")
        case "/":
            setOp("/")
        case "C":
            currentText = "0"
            firstNumber = nil
            op = nil
        case "=":
            compute()
        default:
            break
        }
        update()
    }

    func setOp(_ newOp: String) {
        // compute previous if there was one (beginner style)
        if let _ = op {
            compute()
        }
        firstNumber = Double(currentText) ?? 0
        op = newOp
        currentText = "0"
    }

    func compute() {
        guard let theOp = op, let lhs = firstNumber, let rhs = Double(currentText) else {
            return
        }
        var result: Double = 0
        if theOp == "+" {
            result = lhs + rhs
        } else if theOp == "-" {
            result = lhs - rhs
        } else if theOp == "x" {
            result = lhs * rhs
        } else if theOp == "/" {
            if rhs == 0 {
                result = 0
            } else {
                result = lhs / rhs
            }
        }
        if result.rounded() == result {
            currentText = String(Int(result))
        } else {
            currentText = String(result)
        }
        firstNumber = result
        op = nil
    }

    func update() {
        resultLabel.text = currentText
    }
}
