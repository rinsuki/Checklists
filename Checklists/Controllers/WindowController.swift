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
        viewController.tableView.dataSource = self
    }
    
    @objc func createNewCheck(_ sender: AnyObject) {
        documentTyped.content.checks.append(.init(title: ""))
        let row = documentTyped.content.checks.count-1
        let indexSet = IndexSet(integer: row)
        viewController.tableView.beginUpdates()
        viewController.tableView.insertRows(at: indexSet, withAnimation: [])
        viewController.tableView.endUpdates()
        viewController.tableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        // 新しく追加した物にフォーカスを当てる
        window?.makeFirstResponder(viewController.tableView.view(atColumn: 1, row: row, makeIfNecessary: false))
    }
}

extension WindowController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let check = documentTyped.content.checks[row]
        switch tableColumn?.identifier {
        case .init(rawValue: "checkbox"):
            let button = CheckButton(checkboxWithTitle: "", target: self, action: #selector(onChecked(_:)))
            button.assign(check: check)
            return button
        case .init(rawValue: "textfield"):
            let field = CheckTitleField(string: String(repeating: "A", count: row))
            field.assign(check: check)
            field.stringValue = check.title
            field.drawsBackground = false
            field.isBezeled = false
            return field
        default:
            return nil
        }
    }
    
    @objc func onChecked(_ sender: NSButton) {
        window?.makeFirstResponder(sender.superview?.superview)
    }
}

extension WindowController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return documentTyped.content.checks.count
    }
}

