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
    
    init() {
        let window = NSWindow(contentViewController: viewController)
        window.center()
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
