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
    lazy var tableView = NSTableView() ※ { v in
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
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        windowController.beforeAppear()
        print(representedObject)
    }
    
    @objc func createNewCheck(_ sender: AnyObject) {
        let document = representedObject as! Document
        document.content.checks.append(.init(title: ""))
        let row = document.content.checks.count - 1
        // 新しく追加した物にフォーカスを当てる
        let view = tableView.view(atColumn: 1, row: row, makeIfNecessary: true) as! WrapperView<NSTextField>
        print(view)
        tableView.selectRowIndexes(.init(integer: row), byExtendingSelection: false)
        view.window?.makeFirstResponder(view.wrappedView)
    }
}

