import UIKit

final class HomeViewController: UIViewController {

    private let mainStackView = UIStackView()

    private let stackView1 = UIStackView()
    private let stackView2 = UIStackView()
    private let stackView3 = UIStackView()
    private let stackView4 = UIStackView()
    private let stackView5 = UIStackView()
    private let stackView6 = UIStackView()
    private let stackView7 = UIStackView()

    private let resultLabel = UILabel()

    private let operatorAC = CustomButton(colorDeFondo: .lightGray, titulo: "AC", target: self, action: #selector(operatorACAction(_:)))

//    MARK: - Variables

    private var total: Double = 0                           // Almacena el resultado total de la calculadora
    private var temp: Double = 0                            // Valor por pantalla
    private var operating = false                           // Indica si se ha seleccionado algun operador
    private var decimal = false                             // Indica si el valor es decimal
    private var operation: OperationType = .none            // Operacion actual

//    MARK: - Constantes

    private let decimalSeparator = Locale.current.decimalSeparator!
    private let maxLength = 9 // Tamaño maximo que vamos a admitir para un numero
    private let ktotal = "total"
//    private let maxValue: Double = 999999999         // Valor maximo visual con el que vamos a trabajar
//    private let minValue: Double = 0.00000001        // Valor minimo visual con el que vamos a trabajar

    private enum OperationType {
        case none
        case addiction          //Suma
        case substraction       //Resta
        case multiplication
        case division
        case percent
    }

//     Formateo de valores auxiliar -- Encargado de modificar visualmente el numero para mostrarlo por pantalla

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

//     Formateo de valores por pantalla por defecto -- En este caso se utiliza el seperador de grupo de Locale

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

//     Formateo de valores por pantalla en formato cientifico

    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainStackView()
        configureResultLabel()
        total = UserDefaults.standard.double(forKey: ktotal)
        result()

    }
}


//MARK: - Private Methods

extension HomeViewController {

    func configureMainStackView() {
        view.addSubview(mainStackView)

        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 18

        configureAllStacksView()

        let height = view.frame.height * 0.45
        NSLayoutConstraint.activate([
            mainStackView.heightAnchor.constraint(equalToConstant: height),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    func configureAllStacksView() {
        configureStackView(stackView: stackView1, backgroundColor: .clear)
        configureStackView(stackView: stackView2, backgroundColor: .clear)
        configureStackView(stackView: stackView3, backgroundColor: .clear)
        configureStackView(stackView: stackView4, backgroundColor: .clear)
        configureStackView(stackView: stackView5, backgroundColor: .clear)
        configureStackView5()
        addButtonsToStacksViews()
    }

    func configureStackView(stackView: UIStackView, backgroundColor: UIColor) {
        mainStackView.addArrangedSubview(stackView)
        stackView.backgroundColor = backgroundColor
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 18
    }

    func configureStackView5() {
        stackView5.addArrangedSubview(stackView6)
        stackView5.addArrangedSubview(stackView7)
        stackView5.distribution = .fillEqually

        stackView6.axis = .horizontal
        stackView7.axis = .horizontal

        stackView7.distribution = .fillEqually
        stackView7.spacing = 18

        stackView6.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "0", target: self, action: #selector(numberAction(_:)), tag: 0))
        stackView7.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: decimalSeparator, target: self, action: #selector(numberDecimalAction(_:))))
        stackView7.addArrangedSubview(CustomButton(colorDeFondo: .orange, titulo: "=", target: self, action: #selector(operatorResultAction(_:))))
    }

    func addButtonsToStacksViews() {
        addButtonsToStackView1()
        addButtonsToStackView2()
        addButtonsToStackView3()
        addButtonsToStackView4()
    }

    func addButtonsToStackView1() {
        stackView1.addArrangedSubview(operatorAC)
        
        stackView1.addArrangedSubview(CustomButton(colorDeFondo: .lightGray, titulo: "+/-", target: self, action: #selector(operatorPlusMinusAction(_:))))
        stackView1.addArrangedSubview(CustomButton(colorDeFondo: .lightGray, titulo: "%", target: self, action: #selector(operatorPercentAction(_:))))
        stackView1.addArrangedSubview(CustomButton(colorDeFondo: .orange, titulo: "÷", target: self, action: #selector(operatorDivisionnAction(_:))))
    }

    func addButtonsToStackView2() {
        stackView2.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "7", target: self, action: #selector(numberAction(_:)), tag: 7))
        stackView2.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "8", target: self, action: #selector(numberAction(_:)), tag: 8))
        stackView2.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "9", target: self, action: #selector(numberAction(_:)), tag: 9))
        stackView2.addArrangedSubview(CustomButton(colorDeFondo: .orange, titulo: "×", target: self, action: #selector(operatorMultiplicationAction(_:))))
    }

    func addButtonsToStackView3() {
        stackView3.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "4", target: self, action: #selector(numberAction(_:)), tag: 4))
        stackView3.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "5", target: self, action: #selector(numberAction(_:)), tag: 5))
        stackView3.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "6", target: self, action: #selector(numberAction(_:)), tag: 6))
        stackView3.addArrangedSubview(CustomButton(colorDeFondo: .orange, titulo: "-", target: self, action: #selector(operatorSubstractionAction(_:))))
    }

    func addButtonsToStackView4() {
        stackView4.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "1", target: self, action: #selector(numberAction(_:)), tag: 1))
        stackView4.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "2", target: self, action: #selector(numberAction(_:)), tag: 2))
        stackView4.addArrangedSubview(CustomButton(colorDeFondo: .darkGray, titulo: "3", target: self, action: #selector(numberAction(_:)), tag: 3))
        stackView4.addArrangedSubview(CustomButton(colorDeFondo: .orange, titulo: "+", target: self, action: #selector(operatorAdditionAction(_:))))
    }

    func configureResultLabel() {
        view.addSubview(resultLabel)

        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.heightAnchor.constraint(equalToConstant: 70),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -30)
        ])

        //        label.backgroundColor = .red
        resultLabel.textAlignment = .right
        resultLabel.textColor = .white
        //        label.font = .boldSystemFont(ofSize: 90)
        resultLabel.font = .systemFont(ofSize: 57)
        resultLabel.minimumScaleFactor = 20
        resultLabel.text = "0"
    }

    private func clear() {      // Limpia los valores
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

    private func result() {       // Obtiene el resultado final

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

        // Formateo en pantalla

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

    func callShine(_ sender: UIButton) {

        if let customButton = sender as? CustomButton {
            customButton.shine()
        }
    }

    @objc func operatorACAction(_ sender: UIButton) {
        clear()
        callShine(sender)
        print("Se ha pulsado AC")
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
        print("Se ha pulsado +")
    }

    @objc func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }

        operating = true
        operation = .substraction

        callShine(sender)
        print("Se ha pulsado -")
    }

    @objc func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }

        operating = true
        operation = .multiplication

        callShine(sender)
        print("Se ha pulsado *")
    }

    @objc func operatorDivisionnAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }

        operating = true
        operation = .division

        callShine(sender)
        print("Se ha pulsado /")
    }

    @objc func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= maxLength {
            return
        }

        resultLabel.text = resultLabel.text! + decimalSeparator
        decimal = true


        callShine(sender)
        print("Se ha pulsado ,")
    }

    @objc func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)

        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= maxLength {
            return
        }

        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!

        // Hemos seleccionado una operancion

        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }

        // Hemos seleccionado decimales

        if decimal {
            currentTemp = "\(currentTemp)\(decimalSeparator)"
            operating = false
        }

        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))


        callShine(sender)
    }



}
