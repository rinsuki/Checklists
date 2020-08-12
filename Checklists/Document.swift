//
//  Document.swift
//  Checklists
//
//  Created by user on 2020/08/10.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa

class Check: NSObject, Codable, NSCopying {
    @objc dynamic var checked: Bool {
        didSet {
            undoManager?.registerUndo(withTarget: self) { content in
                content.checked = oldValue
            }
        }
    }
    @objc dynamic var title: String {
        didSet {
            undoManager?.registerUndo(withTarget: self) { content in
                content.title = oldValue
            }
        }
    }
    var undoManager: UndoManager? = nil
    
    enum CodingKeys: String, CodingKey {
        case checked
        case title
    }
    
    init(title: String) {
        self.title = title
        self.checked = false
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let new = Check(title: title)
        new.checked = checked
        new.undoManager = undoManager
        return new
    }
}

class DocumentContent: NSObject, Codable {
    @objc dynamic var checks = [Check]() {
        didSet {
            registerUndoManagerToChildrens()
            undoManager?.registerUndo(withTarget: self) { content in
                content.checks = oldValue
            }
        }
    }
    var undoManager: UndoManager? = nil {
        didSet {
            registerUndoManagerToChildrens()
        }
    }
    
    enum CodingKeys: CodingKey {
        case checks
    }
    
    func registerUndoManagerToChildrens() {
        for check in checks {
            check.undoManager = undoManager
        }
    }
}

class Document: NSDocument, Codable {
    @objc dynamic var content = DocumentContent()

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        content.undoManager = undoManager
    }

    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Create the window and set the content view.
        let wc = WindowController()
        wc.viewController.representedObject = self
        self.addWindowController(wc)
    }
    
    override var fileNameExtensionWasHiddenInLastRunSavePanel: Bool {
        return false
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        let encoder = JSONEncoder()
        return try encoder.encode(self.content)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        let decoder = JSONDecoder()
        content = try decoder.decode(DocumentContent.self, from: data)
        content.undoManager = undoManager
    }


}

