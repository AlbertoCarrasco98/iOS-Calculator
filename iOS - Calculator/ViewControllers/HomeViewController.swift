import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let stackView1 = UIStackView()
    private let stackView2 = UIStackView()
    private let stackView3 = UIStackView()
    private let stackView4 = UIStackView()
    private let stackView5 = UIStackView()
    private let stackView6 = UIStackView()
    private let stackView7 = UIStackView()
    private let resultLabel = UILabel()
    private let operatorAC = CustomButton(backgroundColor: .lightGray, title: "AC", target: self, action: #selector(operatorACAction(_:)))
    private let decimalSeparator = Locale.current.decimalSeparator!
    private let maxLength = 9
    private let ktotal = "total"

    //    MARK: - Variables

    private var total: Double = 0
    private var temp: Double = 0
    private var operating = false
    private var decimal = false
    private var operation: OperationType = .none

    private enum OperationType {
        case none
        case addiction
        case substraction
        case multiplication
        case division
        case percent
    }

    // MARK: - Formatters

    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()

    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()

    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()

    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainStackView()
        configureResultLabel()
        total = UserDefaults.standard.double(forKey: ktotal)
        result()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - Private Methods

extension HomeViewController {

    private func configureMainStackView() {
        view.addSubview(mainStackView)

        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        let height = view.frame.height * 0.45
        NSLayoutConstraint.activate([
            mainStackView.heightAnchor.constraint(equalToConstant: height),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 18
        configureAllStacksView()
    }

    private func configureAllStacksView() {
        configureStackView(stackView: stackView1, backgroundColor: .clear)
        configureStackView(stackView: stackView2, backgroundColor: .clear)
        configureStackView(stackView: stackView3, backgroundColor: .clear)
        configureStackView(stackView: stackView4, backgroundColor: .clear)
        configureStackView(stackView: stackView5, backgroundColor: .clear)
        configureStackView5()
        addButtonsToStacksViews()
    }

    private func configureStackView(stackView: UIStackView, backgroundColor: UIColor) {
        mainStackView.addArrangedSubview(stackView)
        stackView.backgroundColor = backgroundColor
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 18
    }

    private func configureStackView5() {
        configureStackView6()
        configureStackView7()
        stackView5.addArrangedSubview(stackView6)
        stackView5.addArrangedSubview(stackView7)
        stackView5.distribution = .fillEqually
    }

    private func configureStackView6() {
        stackView6.axis = .horizontal
        stackView6.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "0", target: self, action: #selector(numberAction(_:)), tag: 0))
    }

    private func configureStackView7() {
        stackView7.axis = .horizontal
        stackView7.distribution = .fillEqually
        stackView7.spacing = 18
        stackView7.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: decimalSeparator, target: self, action: #selector(numberDecimalAction(_:))))
        stackView7.addArrangedSubview(CustomButton(backgroundColor: .orange, title: "=", target: self, action: #selector(operatorResultAction(_:))))
    }

    private func addButtonsToStacksViews() {
        addButtonsToStackView1()
        addButtonsToStackView2()
        addButtonsToStackView3()
        addButtonsToStackView4()
    }

    private func addButtonsToStackView1() {
        stackView1.addArrangedSubview(operatorAC)
        stackView1.addArrangedSubview(CustomButton(backgroundColor: .lightGray, title: "+/-", target: self, action: #selector(operatorPlusMinusAction(_:))))
        stackView1.addArrangedSubview(CustomButton(backgroundColor: .lightGray, title: "%", target: self, action: #selector(operatorPercentAction(_:))))
        stackView1.addArrangedSubview(CustomButton(backgroundColor: .orange, title: "÷", target: self, action: #selector(operatorDivisionnAction(_:))))
    }

    private func addButtonsToStackView2() {
        stackView2.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "7", target: self, action: #selector(numberAction(_:)), tag: 7))
        stackView2.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "8", target: self, action: #selector(numberAction(_:)), tag: 8))
        stackView2.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "9", target: self, action: #selector(numberAction(_:)), tag: 9))
        stackView2.addArrangedSubview(CustomButton(backgroundColor: .orange, title: "×", target: self, action: #selector(operatorMultiplicationAction(_:))))
    }

    private func addButtonsToStackView3() {
        stackView3.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "4", target: self, action: #selector(numberAction(_:)), tag: 4))
        stackView3.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "5", target: self, action: #selector(numberAction(_:)), tag: 5))
        stackView3.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "6", target: self, action: #selector(numberAction(_:)), tag: 6))
        stackView3.addArrangedSubview(CustomButton(backgroundColor: .orange, title: "-", target: self, action: #selector(operatorSubstractionAction(_:))))
    }

    private func addButtonsToStackView4() {
        stackView4.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "1", target: self, action: #selector(numberAction(_:)), tag: 1))
        stackView4.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "2", target: self, action: #selector(numberAction(_:)), tag: 2))
        stackView4.addArrangedSubview(CustomButton(backgroundColor: .darkGray, title: "3", target: self, action: #selector(numberAction(_:)), tag: 3))
        stackView4.addArrangedSubview(CustomButton(backgroundColor: .orange, title: "+", target: self, action: #selector(operatorAdditionAction(_:))))
    }

    private func configureResultLabel() {
        view.addSubview(resultLabel)

        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.heightAnchor.constraint(equalToConstant: 70),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -30)
        ])

        resultLabel.textAlignment = .right
        resultLabel.textColor = .white
        resultLabel.font = .systemFont(ofSize: 57)
        resultLabel.minimumScaleFactor = 20
        resultLabel.text = "0"
    }

     func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
    }

    private func result() {

        switch operation {

            case .none:
                // No hacemos nada
                break
            case .addiction:
                total = total + temp
                break
            case .substraction:
                total = total - temp
                break
            case .multiplication:
                total = total * temp
                break
            case .division:
                total = total / temp
                break
            case .percent:
                temp = temp / 100
                total = temp
                break
        }

        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > maxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }

        operation = .none
        UserDefaults.standard.setValue(total, forKey: ktotal)
    }
}

//MARK: - Button Actions

extension HomeViewController {

    private func callShine(_ sender: UIButton) {
        if let customButton = sender as? CustomButton {
            customButton.shine()
        }
    }

    @objc func operatorACAction(_ sender: UIButton) {
        clear()
        callShine(sender)
    }

    @objc func operatorPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))

        callShine(sender)
    }

    @objc func operatorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }

        operating = true
        operation = .percent
        result()
        callShine(sender)
    }

    @objc func operatorResultAction(_ sender: UIButton) {
        result()
        callShine(sender)
    }

    @objc func operatorAdditionAction(_ sender: UIButton) {

        if operation != .none {
            result()
        }
        operating = true
        operation = .addiction
        callShine(sender)
    }

    @objc func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraction
        callShine(sender)
    }

    @objc func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        callShine(sender)
    }

    @objc func operatorDivisionnAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        callShine(sender)
    }

    @objc func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= maxLength {
            return
        }
        resultLabel.text = resultLabel.text! + decimalSeparator
        decimal = true
        callShine(sender)
    }

    @objc func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= maxLength {
            return
        }
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!

        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }

        if decimal {
            currentTemp = "\(currentTemp)\(decimalSeparator)"
            operating = false
        }

        let number = sender.tag
        if let tempValue = Double(currentTemp + String(number)) {
            temp = tempValue
            if let tempString = printFormatter.string(from: NSNumber(value: temp)) {
                resultLabel.text = tempString
            }
        }
        callShine(sender)
    }
}
