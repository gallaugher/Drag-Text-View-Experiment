//
//  SizeTableViewCell.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

class SizeTableViewCell: UITableViewCell {
    weak var delegate: SizeCellDelegate?
    
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    func configureSizeCell(size: Int) {
        fontSizeLabel.text = "\(size) pt."
        fontSizeStepper.value = Double(size)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        delegate?.fontSizeStepperPressed(Int(fontSizeStepper!.value))
    }
}
