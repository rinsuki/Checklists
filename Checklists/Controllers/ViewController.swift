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
    }
    lazy var tableScrollView = NSScrollView() ※ { v in
        v.documentView = tableView
        v.hasVerticalScroller = true
    }
    unowned var windowController: WindowController!
    
    override func loadView() {
        view = tableScrollView
        view.snp.makeConstraints { make in
            make.width.height.greaterThanOrEqualTo(100)
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        windowController.beforeAppear()
    }
}

