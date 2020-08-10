//
//  CheckTitleField.swift
//  Checklists
//
//  Created by user on 2020/08/11.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa
import Combine

class CheckTitleField: NSTextField {
    var cancellables = Set<AnyCancellable>()
    
    func assign(check: Check) {
        check.$title
            .assign(to: \.stringValue, on: self)
            .store(in: &cancellables)
        NotificationCenter.default.publisher(for: NSControl.textDidChangeNotification, object: self)
            .map(\.object)
            .map { $0 as! NSTextField }
            .map(\.stringValue)
            .assign(to: \.title, on: check)
            .store(in: &cancellables)
    }

    
}
