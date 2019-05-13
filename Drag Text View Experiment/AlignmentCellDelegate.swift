//
//  AlignmentCellDelegate.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import UIKit

// This links the one or two buttons in the cusetom table view cells with the View Controller so that actions can be taken when the buttons are pressed
protocol AlignmentCellDelegate: class {
    func alignmentSegmentSelected(selectedSegment: Int)
    func styleButtonSelected(_ sender: ToggleButton)
}
