//
//  ColorCellDelegate.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import UIKit
import ColorSlider

// This links the one or two buttons in the cusetom table view cells with the View Controller so that actions can be taken when the buttons are pressed
protocol ColorCellDelegate: class {
    func changeColorSelected(slider: ColorSlider, textColorButton: UIButton, textBackgroundButton: UIButton)
    func setSelectedFrame(sender: UIButton, textColorSelected: Bool, textColorFrame: UIView, textBackgroundFrame: UIView)
}
