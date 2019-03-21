//Copyright © 2019 Roving Mobile. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorPicker: ColorPicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        [UIColor.red, .blue, .green, .yellow, .orange, .purple, .gray, .magenta, .brown, .lightGray].forEach {
            colorPicker.insertColor($0, at: colorPicker.numberOfItems)
        }
        colorPicker.alignment = .fill
        colorPicker.tintColor = .black
    }


}

