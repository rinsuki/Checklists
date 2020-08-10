//
//  Document.swift
//  Checklists
//
//  Created by user on 2020/08/10.
//  Copyright © 2020 rinsuki. All rights reserved.
//

import Cocoa
import Combine

class Check: NSObject, Codable {
    @Published var checked: Bool
    @Published var title: String
    
    init(title: String) {
        self.title = title
        self.checked = false
    }
    
    enum CodingKeys: String, CodingKey {
        case checked
        case title
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        checked = try container.decode(Bool.self, forKey: .checked)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(checked, forKey: .checked)
        try container.encode(title, forKey: .title)
    }
}

class DocumentContent: NSObject, Codable {
    var checks = [Check]()
    
    enum CodingKeys: CodingKey {
        case checks
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        checks = try container.decode([Check].self, forKey: .checks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(checks, forKey: .checks)
    }
}

class Document: NSDocument, Codable {
    @objc dynamic var content = DocumentContent()

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Create the window and set the content view.
        self.addWindowController(WindowController())
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
        self.content = try decoder.decode(DocumentContent.self, from: data)
    }


}

