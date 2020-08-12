//
//  WindowController.swift
//  Checklists
//
//  Created by user on 2020/08/10.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    let viewController = ViewController()
    
    var documentTyped: Document {
        return document as! Document
    }
    
    init() {
        let window = NSWindow(contentViewController: viewController)
        window.center()
        super.init(window: window)
        viewController.windowController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var controller = NSArrayController(content: documentTyped.content.checks)
    
    func beforeAppear() {
        viewController.tableView.delegate = self
//        viewController.tableView.dataSource = self
    }
    
    
}

extension WindowController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let check = documentTyped.content.checks[row]
        switch tableColumn?.identifier {
        case .init(rawValue: "checkbox"):
            let button = NSButton(checkboxWithTitle: "", target: self, action: #selector(onChecked(_:)))
            let wrapper = WrapperView(wrapped: button)
            button.bind(.value, to: wrapper, withKeyPath: "objectValue.checked", options: nil)
            return wrapper
        case .init(rawValue: "textfield"):
            let field = NSTextField(string: String(repeating: "A", count: row))
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
        window?.makeFirstResponder(sender.superview?.superview?.superview)
    }
}
