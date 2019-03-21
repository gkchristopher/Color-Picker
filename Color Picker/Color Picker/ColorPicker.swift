//Copyright © 2019 Roving Mobile, LLC. All rights reserved.

import UIKit

@IBDesignable
class ColorPicker: UIControl {

    var selectedIndex: Int = -1 {
        didSet {
            select(selectedIndex)
        }
    }

    var maxPerRow: Int = 7
    var alignment: UIStackView.Alignment = .fill {
        didSet {
            container.alignment = alignment
        }
    }

    private var buttons = [SelectableButton]()
    private let container = UIStackView(frame: .zero)
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
        backgroundColor = .white

        container.axis = .vertical
        container.alignment = alignment
        container.distribution = .fill
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        buttons = createButtons()
        addColorButtonsStackView(buttons)

        setNeedsLayout()
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
        buttons.forEach { $0.cornerRadius = $0.bounds.height / 2 }
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
        circleButton.borderColor = tintColor
        circleButton.isSelected = false
        circleButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)
        return circleButton
    }

    private func addColorButtonsStackView(_ buttons: [SelectableButton]) {
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        container.addArrangedSubview(stackView)

//        buttons.forEach { $0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true }
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

    override func tintColorDidChange() {
        super.tintColorDidChange()
        buttons.forEach { $0.borderColor = tintColor }
    }
}
