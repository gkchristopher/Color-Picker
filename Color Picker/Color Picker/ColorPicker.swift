//Copyright © 2019 Roving Mobile, LLC. All rights reserved.

import UIKit

@IBDesignable
class ColorPicker: UIControl {

    var selectedIndex: Int = -1 {
        didSet {
            select(selectedIndex)
        }
    }
    private var buttons = [SelectableButton]()
    private var stackView: UIStackView!
    private var colors: [UIColor]!

    init(colors: [UIColor]) {
        super.init(frame: .zero)
        self.colors = colors
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        colors = [UIColor]()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        colors = [UIColor]()
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        buttons = createButtons()
        addColorButtonsStackView(buttons)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buttons.forEach { $0.cornerRadius = stackView.bounds.height / 2 }
    }

    func insertColor(_ color: UIColor, at position: Int) {
        let index = max(min(position, numberOfItems), 0)
        colors.insert(color, at: index)
        let button = createButton(with: color)
        stackView.insertArrangedSubview(button, at: index)
        buttons.insert(button, at: index)
    }

    var numberOfItems: Int {
        return colors.count
    }

    private func createButtons() -> [SelectableButton] {
        var buttons = [SelectableButton]()
        colors.forEach { color in
            let circleButton = createButton(with: color)
            buttons.append(circleButton)
        }
        return buttons
    }

    private func createButton(with color: UIColor) -> SelectableButton {
        let circleButton = SelectableButton(frame: .zero)
        circleButton.backgroundColor = color
        circleButton.borderWidth = 1.5
        circleButton.borderColor = UIColor(named: "barTint")!
        circleButton.isSelected = false
        circleButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            circleButton.widthAnchor.constraint(equalToConstant: 34),
            circleButton.heightAnchor.constraint(equalToConstant: 34)
            ])
        return circleButton
    }

    private func addColorButtonsStackView(_ buttons: [SelectableButton]) {
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        buttons.forEach { $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true }
    }

    private func select(_ index: Int) {
        for (i, button) in buttons.enumerated() {
            button.isSelected = i == index
        }
    }

    @objc private func handleSelection(_ sender: SelectableButton) {
        for (index, button) in buttons.enumerated() {
            if sender === button {
                button.isSelected = true
                selectedIndex = index
            } else {
                button.isSelected = false
            }
        }
        sendActions(for: .valueChanged)
    }
}
