//
//  ColorTableViewCell.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit
import ColorSlider

class ColorTableViewCell: UITableViewCell, ColorSliderPreviewing {
    @IBOutlet weak var textColorFrame: UIView!
    @IBOutlet weak var textColorButton: UIButton!
    @IBOutlet weak var textBackgroundFrame: UIView!
    @IBOutlet weak var textBackgroundButton: UIButton!
    
    func colorChanged(to color: UIColor) {
        print("nothing needed here")
    }
    
    func transition(to state: PreviewState) {
        print("nothing needed here")
    }
    
    weak var delegate: ColorCellDelegate?
   var colorSlider = ColorSlider()
    
    func configureColorCell() {
        textColorFrame.layer.borderColor = Colors.buttonTint.cgColor
        textBackgroundFrame.layer.borderColor = Colors.buttonTint.cgColor
        
        let cellFrame = CGRect(x: 0 + 16, y: 40, width: UIScreen.main.bounds.width - 16*2 , height: 20)
        let previewView = DefaultPreviewView(side: .top)
        previewView.offsetAmount = 10.0

        let colorSlider = ColorSlider(orientation: .horizontal, previewView: previewView)
        colorSlider.color = textColorButton.backgroundColor!
        textColorFrame.layer.borderWidth = 1.0
        textColorButton.layer.borderWidth = 0.5
        textColorButton.layer.borderColor = UIColor.lightGray.cgColor
        textColorButton.layer.backgroundColor = UIColor.darkText.cgColor
        textBackgroundButton.layer.borderWidth = 0.5
        textBackgroundButton.layer.borderColor = UIColor.lightGray.cgColor
        colorSlider.frame = cellFrame
        contentView.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
         delegate?.changeColorSelected(slider: slider, textColorButton: textColorButton, textBackgroundButton: textBackgroundButton)
    }

    @IBAction func textColorPressed(_ sender: UIButton) {
        delegate?.setSelectedFrame(sender: sender, textColorSelected: true, textColorFrame: textColorFrame, textBackgroundFrame: textBackgroundFrame)
    }
    
    @IBAction func textBackgroundPressed(_ sender: UIButton) {
        delegate?.setSelectedFrame(sender: sender, textColorSelected: false, textColorFrame: textColorFrame, textBackgroundFrame: textBackgroundFrame)
    }
    
}
