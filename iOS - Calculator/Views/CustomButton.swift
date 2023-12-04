import UIKit

class CustomButton: UIButton {

    private var customBackgroundcolor: UIColor
    private var title: String
    private let buttonAC = UIButton()
    private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

    init(backgroundColor: UIColor, title: String, target: Any?, action: Selector, tag: Int? = nil) {

        self.customBackgroundcolor = backgroundColor
        self.title = title
        super.init(frame: .zero)

        self.addTarget(target, action: action, for: .touchUpInside)

        if let buttonTag = tag {
            self.tag = buttonTag
        }

        self.customBackgroundcolor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.frame.height, self.frame.width) / 2
    }

    private func configure() {
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 36)
        self.frame = CGRect(x: 70, y: 70, width: 70, height: 70)
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
}
