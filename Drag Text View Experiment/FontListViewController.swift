//
//  FontListViewController.swift
//  Drag Text View Experiment
//
//  Created by John Gallaugher on 5/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

protocol PassFontDelegate {
    func getSelectedFont(selectedFont: UIFont)
}

class FontListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var fontList: [String] = []
    var selectedFontIndex: Int!
    var selectedFont: UIFont!
    let fontSizeForCells: CGFloat = 20.0
    var delegate: PassFontDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if selectedFont == nil {
            print("😡 ERROR: For some reason a font wasn't passed into FontListViewController.")
            selectedFont = UIFont.systemFont(ofSize: fontSizeForCells)
        }
        fontList = UIFont.familyNames
        fontList.sort()
        tableView.reloadData()
        
        let foundFontIndex = fontList.firstIndex(of: selectedFont.fontName)
        if foundFontIndex == nil {
            print("😡 ERROR: Font \(selectedFont.fontName) cannot be found on this device. Using System Font")
            selectedFontIndex = 0
        } else {
            selectedFontIndex = foundFontIndex!
        }
        selectedFont = UIFont(name: fontList[selectedFontIndex], size: fontSizeForCells)
        tableView.selectRow(at: IndexPath(row: selectedFontIndex, section: 0), animated: true, scrollPosition: .middle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Make sure the selectedFont variable has been updated with the current selection, since this value is about to be passed back to the prior viewController in unwindFromFonts
        selectedFont = UIFont(name: fontList[selectedFontIndex], size: fontSizeForCells)
        delegate.getSelectedFont(selectedFont: selectedFont)
    }
}

extension FontListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCheckmark(for: cell, at: indexPath)
        let cellFont = UIFont(name: fontList[indexPath.row], size: 20.0)
        cell.textLabel?.font = cellFont
        cell.textLabel?.text = fontList[indexPath.row]
        return cell
    }
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        let selectedFontIndexPath = IndexPath(row: selectedFontIndex, section: 0)
        if selectedFontIndexPath == indexPath {
            // add check
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldSelectedIndexPath = IndexPath(row: selectedFontIndex, section: 0)
        let oldCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: oldSelectedIndexPath)
        configureCheckmark(for: oldCell, at: oldSelectedIndexPath)
        selectedFontIndex = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCheckmark(for: cell, at: indexPath)
        tableView.reloadData()
    }
}