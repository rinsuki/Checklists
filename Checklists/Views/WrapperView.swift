//
//  TableButtonCellView.swift
//  Checklists
//
//  Created by user on 2020/08/12.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa
import SnapKit

class WrapperView<T: NSView>: NSView {
    @objc dynamic var objectValue: Any?
    var wrappedView: T
    
    init(wrapped: T) {
        wrappedView = wrapped
        super.init(frame: .zero)
        addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceptsFirstResponder: Bool {
        return wrappedView.acceptsFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return wrappedView.resignFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return wrappedView.resignFirstResponder()
    }
}
