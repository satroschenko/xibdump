//
//  StoryboardDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/19/19.
//

import Cocoa
import AEXML
import SwiftCLI

class StoryboardDecoder: NSObject {

    let initialURL: URL
    let mapping: [String: String]
    let parentTag: Tag = XibParentTag(fileFormat: .storyboard)
    let scenesTag: Tag = Tag(name: "scenes")
    
    init(initialURL: URL, mapping: [String: String]) {
        self.initialURL = initialURL
        self.mapping = mapping
        super.init()
        parentTag.add(tag: scenesTag)
    }
    
    
    func decode() throws {
        
        let parser = XibFileParser()
        
        for (_, value) in mapping {
                                    
            let nibURL = initialURL.appendingPathComponent(value).appendingPathExtension("nib")
            let xibConnectionFile = try parser.parse(url: nibURL)
            
            let logger = XibLogger(xibFile: xibConnectionFile)
            logger.printDump()
            print("\n\n\n")
            
            let connectionDecoder = StoryboardConnectionDecoder(xibFile: xibConnectionFile)
            if let connections = connectionDecoder.findStoryboardConnections() {

                let sceneTag = Tag(name: "scene")
                sceneTag.addParameter(name: "sceneID", value: XibID.generate())
                scenesTag.add(tag: sceneTag)
                
                let objectsTag = Tag(name: "objects")
                sceneTag.add(tag: objectsTag)
                
                let placeholderTag = Tag(name: "placeholder")
                placeholderTag.addParameter(name: "placeholderIdentifier", value: "IBFirstResponder")
                placeholderTag.addParameter(name: "id", value: XibID.generate())
                placeholderTag.addParameter(name: "userLabel", value: "First Responder")
                placeholderTag.addParameter(name: "sceneMemberID", value: "firstResponder")
                
                
                for oneConnection in connections {
                    
                    let finalURL = initialURL.appendingPathComponent(oneConnection.fileName).appendingPathExtension("nib")
                    let xibFile = try parser.parse(url: finalURL)
                    
                    let logger = XibLogger(xibFile: xibFile)
                    logger.printDump()
                    
                    let vcTag = Tag(name: oneConnection.rootClassName)
                    vcTag.addParameter(name: "storyboardIdentifier", value: oneConnection.storyboardIdentifier)
                    vcTag.addParameter(name: "id", value: XibID.generate())
                    vcTag.addParameter(name: "sceneMemberID", value: "viewController")
                    objectsTag.add(tag: vcTag)
                    
                    
                    let fakeTag = Tag(name: "")
                    let decoder = XibDecoder(xibFile: xibFile, parentTag: fakeTag)
                    decoder.decode()
                    
                    if let first = fakeTag.allChildren().first {
                        
                        if let tableView = first.allChildren().filter({$0.name == "tableView"}).first,
                            let dataSource = first.allChildren().filter({$0.name == "tableViewDataSource"}).first,
                            let sections = dataSource.allChildren().first {
                            
                            first.removeChildren(name: "tableViewDataSource")
                            tableView.add(tag: sections)
                            tableView.addParameter(name: "dataMode", value: "static")
                        }
                        
                        for tag in first.allChildren() {
                            if tag.name.lowercased().hasSuffix("view") {
                                tag.addParameter(name: "key", value: "view")
                            }
                            vcTag.add(tag: tag)
                        }
                    }
                }
                
                objectsTag.add(tag: placeholderTag)
            }
        }
    }
    
    
    func save(to url: URL) throws {
        
        let soapRequest = AEXMLDocument()
        soapRequest.addChild(parentTag.getNode())
        
        guard let data = soapRequest.xml.data(using: .utf8) else {
            throw CLI.Error(message: "Error data serialization.")
        }
        
        try data.write(to: url)
    }
}
