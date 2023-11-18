
import UIKit


class CustomButton: UIButton {


    var colorDeFondo: UIColor
    var titulo: String

    let buttonAC = UIButton()

    private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

    init(colorDeFondo: UIColor, titulo: String, target: Any?, action: Selector, tag: Int? = nil) {


        self.colorDeFondo = colorDeFondo
        self.titulo = titulo
        super.init(frame: .zero)

        self.addTarget(target, action: action, for: .touchUpInside)

        if let buttonTag = tag {
            self.tag = buttonTag
        }

        self.backgroundColor = colorDeFondo
        self.setTitle(titulo, for: .normal)
        configure()
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure() {

        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 36)
        self.frame = CGRect(x: 60, y: 60, width: 60, height: 60)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.titleLabel?.textAlignment = .center

    }

    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }

//     Apariencia seleccion boton operacion
//
//    func selectOperation(_ selected: Bool) {
//        self.backgroundColor = selected ? .white : orange
//        self.setTitleColor(selected ? orange : .white, for: .normal)
//    }

}











    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        configure()
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }
//
//
//
//    func configure() {
//        self.backgroundColor = .gray
//        self.setTitleColor(.black, for: .normal)
//        self.titleLabel?.font = .boldSystemFont(ofSize: 35)
//
//        self.layer.cornerRadius = self.bounds.size.width / 2
//
//    }
//
//    func setTitleButtonAndColor(title: String, color: UIColor) {
//        self.setTitle(title, for: .normal)
//        self.backgroundColor = color
//    }


