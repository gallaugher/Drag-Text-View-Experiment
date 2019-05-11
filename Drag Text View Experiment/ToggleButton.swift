//
//  ToggleButton.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    // default blue in hex: 4585F0
    // RGB: 69, 133, 240
    
    var buttonTextColor = UIColor.blue // UIColor.init(red: 69, green: 133, blue: 240, alpha: 1.0)
    var buttonBackgroundColor = UIColor.white
    var buttonSelected = false
    var underlinedButton = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        if tag == 2 { // It's the underline button
            let stringAttributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor : Colors.buttonTint,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
            ]
            let attributeString = NSMutableAttributedString(string: "U",
                                                            attributes: stringAttributes)
            setAttributedTitle(attributeString, for: .normal)
        } else {
            setTitleColor(Colors.buttonTint, for: .normal)
        }
        // layer.cornerRadius = 5.0
        backgroundColor = UIColor.white
        addTarget(self, action: #selector(ToggleButton.buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        buttonSelected.toggle()
        buttonTextColor = buttonSelected ? UIColor.white : Colors.buttonTint
        buttonBackgroundColor = buttonSelected ?  Colors.buttonTint: UIColor.white
        if tag == 2 { // It's the underline button
            let stringAttributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor : buttonTextColor,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
            ]
            let attributeString = NSMutableAttributedString(string: "U",
                                                            attributes: stringAttributes)
            setAttributedTitle(attributeString, for: .normal)
        } else {
            setTitleColor(buttonTextColor, for: .normal)
        }
    
        backgroundColor = buttonBackgroundColor
    }
}
