//
//  CheckButton.swift
//  Checklists
//
//  Created by user on 2020/08/10.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa
import Combine

class CheckButton: NSButton {
    var cancellables = Set<AnyCancellable>()
    
    func assign(check: Check) {
        check.$checked
            .map { $0 ? NSControl.StateValue.on : NSControl.StateValue.off }
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
        publisher(for: \.cell!.state, options: [.new])
            .map {
                switch $0 {
                case .on:
                    return true
                case .off:
                    return false
                case .mixed:
                    fallthrough
                 default:
                    fatalError("wtf?")
                }
            }
            .assign(to: \.checked, on: check)
            .store(in: &cancellables)
    }
}
