//
//  ViewController.swift
//  Checklists
//
//  Created by user on 2020/08/10.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa
import Ikemen
import SnapKit

class ViewController: NSViewController {
    class TableView: NSTableView {
        unowned var viewController: ViewController!
        override func keyDown(with event: NSEvent) {
            if event.charactersIgnoringModifiers == "\u{7F}", selectedRow >= 0 {
                viewController.arrayController.remove(nil)
                return
            }
            super.keyDown(with: event)
        }
    }
    lazy var tableView = TableView() ※ { v in
        v.viewController = self
        v.headerView = nil
        v.addTableColumn(.init(identifier: .init("checkbox")) ※ { c in
            let cell = NSButtonCell() ※ { c in
                c.title = ""
                c.setButtonType(.switch)
            }
            c.width = cell.cellSize.width
        })
        v.addTableColumn(.init(identifier: .init("textfield")))
        v.allowsColumnResizing = false
        v.usesAutomaticRowHeights = true
        v.delegate = self
        v.allowsMultipleSelection = true
    }
    lazy var tableScrollView = NSScrollView() ※ { v in
        v.documentView = tableView
        v.hasVerticalScroller = true
    }
    unowned var windowController: WindowController!
    let arrayController = NSArrayController()
    
    override func loadView() {
        view = tableScrollView
        view.snp.makeConstraints { make in
            make.width.height.greaterThanOrEqualTo(100)
        }
        arrayController.bind(.contentArray, to: self, withKeyPath: "representedObject.content.checks", options: nil)
        tableView.bind(.content, to: arrayController, withKeyPath: "arrangedObjects", options: nil)
        tableView.bind(.selectionIndexes, to: arrayController, withKeyPath: "selectionIndexes", options: nil)
    }
    
    var document: Document {
        return representedObject as! Document
    }
    
    @objc func createNewCheck(_ sender: AnyObject) {
        document.content.checks.append(.init(title: ""))
        let row = document.content.checks.count - 1
        // 新しく追加した物にフォーカスを当てる
        let view = tableView.view(atColumn: 1, row: row, makeIfNecessary: true) as! WrapperView<NSTextField>
        tableView.selectRowIndexes(.init(integer: row), byExtendingSelection: false)
        view.window?.makeFirstResponder(view.wrappedView)
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch tableColumn?.identifier {
        case .init(rawValue: "checkbox"):
            let button = NSButton(checkboxWithTitle: "", target: self, action: #selector(onChecked(_:)))
            let wrapper = WrapperView(wrapped: button)
            button.bind(.value, to: wrapper, withKeyPath: "objectValue.checked", options: nil)
            return wrapper
        case .init(rawValue: "textfield"):
            let field = NSTextField(string: "")
            field.drawsBackground = false
            field.isBezeled = false
            let wrapper = WrapperView(wrapped: field)
            field.bind(.value, to: wrapper, withKeyPath: "objectValue.title", options: nil)
            return wrapper
        default:
            return nil
        }
    }
    
    @objc func onChecked(_ sender: NSButton) {
        sender.window?.makeFirstResponder(sender.superview?.superview?.superview)
    }
}
