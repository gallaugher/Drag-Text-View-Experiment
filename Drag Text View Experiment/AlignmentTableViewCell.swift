//
//  AlignmentTableViewCell.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

class AlignmentTableViewCell: UITableViewCell {
    weak var delegate: AlignmentCellDelegate?
    @IBOutlet weak var alignmentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var styleView: UIView!
    
    @IBAction func alignmentPressed(_ sender: UISegmentedControl) {
        delegate?.alignmentSegmentSelected(selectedSegment: alignmentSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func stylePressed(_ sender: ToggleButton) {
        delegate?.styleButtonSelected(sender)
    }

    @IBAction func colorPressed(_ sender: UIButton) {
        delegate?.colorSelectionButtonPressed(sender)
    }

}
