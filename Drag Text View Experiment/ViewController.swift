//
//  ViewController.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 4/30/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit
import MKColorPicker
import ColorSlider

class ViewController: UIViewController, UITextFieldDelegate {
    
    struct TextBlock {
        var text = ""
        var origin = CGPoint(x: 0, y: 0)
        var fontColor = UIColor.black
        var fontSize: CGFloat = 20.0
        var font = UIFont.systemFont(ofSize: 20.0)
        var backgroundColor = UIColor.clear
        var isBold = false
        var isItalic = false
        var isUnderlined = false
    }
    
    @IBOutlet weak var screenView: UIView! // a 320 x 240 view
    @IBOutlet var fieldCollection: [UITextField]! // Not connected, fields created programmatically
    let colorPicker = ColorPickerViewController()
    @IBOutlet weak var tableView: UITableView!
    
    var textColorSelected = true // if not, then textBackground must be selected
    let cells = ["Alignment", "Font", "Size", "Color"]
    var textBlocks: [TextBlock] = []
    var selectedTextBlockIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        createNewField()
    }
    
    // Select / deselect text fields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderStyle = .none
    }
    
    // UITextField created & added to fieldCollection
    func createNewField() {
        let newBlock = TextBlock()
        textBlocks.append(newBlock)
        selectedTextBlockIndex = textBlocks.count-1
        var newFieldRect = CGRect(x: 0, y: 0, width: 320, height: 30)
        let newField = PaddedTextField(frame: newFieldRect)
        newField.borderStyle = .roundedRect
        newField.isUserInteractionEnabled = true
        newField.addGestureRecognizer(addGestureToField())
        // newField.backgroundColor = UIColor.red
        newField.sizeToFit()
        let newFieldHeight = newField.frame.height
        newFieldRect = CGRect(x: 0, y: 0, width: 320, height: newFieldHeight)
        newField.frame = newFieldRect
        screenView.addSubview(newField)
        if fieldCollection == nil {
            fieldCollection = [newField]
        } else {
            fieldCollection.append(newField)
        }
        newField.delegate = self
        newField.becomeFirstResponder()
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSAttributedString.Key.font:self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: Double.infinity), nil)
    }
    
    func addGestureToField() -> UIPanGestureRecognizer {
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        return panGesture
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFonts" { // then tableView cell was clicked
            let destination = segue.destination as! FontListViewController
            destination.delegate = self
            destination.selectedFont = UIFont.systemFont(ofSize: 20.0)
        } else {
            print("ERROR: Should not have arrived in the else in prepareForSegue")
        }
    }
    
    //    @IBAction func unwindFromFonts(for segue: UIStoryboardSegue, sender: Any?) {
    //        print("<><><> I'm in the Unwind! <><><>")
    //        let source = segue.source as! FontListViewController
    //        textBlocks[selectedTextBlockIndex].font = source.selectedFont
    //    }
    
    // event handler when a field(view) is dragged
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        sender.view!.becomeFirstResponder()
        let selectedView = sender.view as! UITextField
        selectedTextBlockIndex = fieldCollection.firstIndex(of: selectedView)!
        print("*** YOU JUST SELECTED VIEW # \(selectedTextBlockIndex)")
        selectedView.bringSubviewToFront(selectedView)
        let translation = sender.translation(in: screenView)
        selectedView.center = CGPoint(x: selectedView.center.x + translation.x, y: selectedView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: screenView)
    }
    
    @IBAction func addFieldPressed(_ sender: UIButton) {
        createNewField()
    }
    
}

class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 8)
    let noPadding = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.borderStyle == .none {
            let content = bounds.inset(by: padding)
            return content
        } else {
            return bounds.inset(by: noPadding)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case "Alignment":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Alignment", for: indexPath) as! AlignmentTableViewCell
            cell.styleView.layer.cornerRadius = 5.0
            cell.styleView.layer.borderWidth = 1.0
            cell.styleView.layer.borderColor = Colors.buttonTint.cgColor
            cell.delegate = self
            return cell
        case "Font":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Font", for: indexPath) as! FontTableViewCell
            cell.configureFontCell(selectedFont: textBlocks[selectedTextBlockIndex].font)
            return cell
        case "Size":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Size", for: indexPath) as! SizeTableViewCell
            // TODO: cell.delegate = self
            return cell
        case "Color":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Color", for: indexPath) as! ColorTableViewCell
            cell.delegate = self
            cell.configureColorCell()
            return cell
        default:
            print("HEY THIS SHOULD NOT HAVE OCCURRED *** ERROR ***")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 70
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cells[indexPath.row] == "Font" {
            performSegue(withIdentifier: "ShowFonts", sender: nil)
        }
    }
}

// Created protocol to handle clicks within custom cells
extension ViewController: AlignmentCellDelegate, ColorCellDelegate {
    
    func changeColorSelected(slider: ColorSlider, textColorButton: UIButton, textBackgroundButton: UIButton) {
        let color = slider.color
        print("slider.color is = \(color)")
        if textColorSelected {
            textColorButton.backgroundColor = color
        } else {
            textBackgroundButton.backgroundColor = color
        }
    }
    
    func setSelectedFrame(sender: UIButton, textColorSelected: Bool, textColorFrame: UIView, textBackgroundFrame: UIView) {
        print("**** textColorSelected pressed *** and it equals \(textColorSelected)")
        if textColorSelected {
            textColorFrame.layer.borderWidth = 1.0
            textBackgroundFrame.layer.borderWidth = 0.0
        } else {
            textColorFrame.layer.borderWidth = 0.0
            textBackgroundFrame.layer.borderWidth = 1.0
        }
        self.textColorSelected = textColorSelected
    }
    
    func alignmentSegmentSelected(selectedSegment: Int) {
        print("*** HEY, you pressed alignment segment # \(selectedSegment)")
    }
    
    func styleButtonSelected(_ sender: ToggleButton) {
        print("*** HEY, you pressed buttton tagged \(sender.tag)")
        sender.isSelected = !sender.isSelected
    }
    
    func colorSelectionButtonPressed(_ sender: UIButton) {
        print("*** HEY, you pressed the COLOR button")
        //To inialize the picker as popover controller
        colorPicker.style = .square
        if let popoverController = colorPicker.popoverPresentationController{
            popoverController.delegate = colorPicker
            popoverController.permittedArrowDirections = .any
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(colorPicker, animated: true, completion: nil)
        
        colorPicker.selectedColor = { color in
            sender.backgroundColor = color
        }
    }
}

extension ViewController: PassFontDelegate {
    
    func getSelectedFont(selectedFont: UIFont) {
        print("<><><> I'm running GET_SELECTED_FONT! <><><>")
        textBlocks[selectedTextBlockIndex].font = selectedFont
        fieldCollection[selectedTextBlockIndex].font = selectedFont
        tableView.reloadData()
    }
    
}
