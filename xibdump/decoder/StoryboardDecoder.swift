//
//  StoryboardDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/19/19.
//

import Cocoa
import AEXML
import SwiftCLI



class StoryboardFileDecoderResult: NSObject, NibDecoderResult {
    
    let fileName: String
    let nibResults: [NibFileDecoderResult]
    let connectionsResult: [NibFileConnectionDecoderResult]
    
    let parentTag: Tag = XibParentTag(fileFormat: .storyboard)
    let scenesTag: Tag = Tag(name: "scenes")
    
    init(fileName: String, nibResults: [NibFileDecoderResult], connectionsResult: [NibFileConnectionDecoderResult]) {
        self.fileName = fileName
        self.nibResults = nibResults
        self.connectionsResult = connectionsResult
        super.init()
        
        parentTag.add(tag: scenesTag)
        
        decode()
    }
    
    func save(to url: URL) throws {
                
        let soapRequest = AEXMLDocument()
        soapRequest.addChild(parentTag.getNode())
        
        guard let data = soapRequest.xml.data(using: .utf8) else {
            throw CLI.Error(message: "Error data serialization.")
        }
        
        let finalURL = url.appendingPathComponent(fileName).deletingPathExtension().appendingPathExtension("storyboard")        
        try data.write(to: finalURL)
    }
    
    
    private func decode() {
        
        for connectionResult in connectionsResult {

            let xibConnectionFile = connectionResult.xibFile

            let connectionDecoder = StoryboardConnectionDecoderHelper(xibFile: xibConnectionFile)
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
                    processConnection(connection: oneConnection, tag: objectsTag)
                }

                objectsTag.add(tag: placeholderTag)
            }
        }
    }
    
    fileprivate func processConnection(connection: StoryboardConnection, tag: Tag) {
        
        guard let xibFile = nibResults.first(where: { $0.nibName() == connection.fileName })?.xibFile else {
            return
        }
        
        let logger = XibLogger(xibFile: xibFile)
        logger.printDump()
        
        let vcTag = Tag(name: connection.rootClassName)
        vcTag.addParameter(name: "storyboardIdentifier", value: connection.storyboardIdentifier)
        vcTag.addParameter(name: "id", value: XibID.generate())
        vcTag.addParameter(name: "sceneMemberID", value: "viewController")
        tag.add(tag: vcTag)
        
        
        let fakeTag = Tag(name: "")
        let decoder = XibDecoder(xibFile: xibFile, parentTag: fakeTag, onlyNibParsing: false)
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
}



class StoryboardDecoder: NSObject, NibDecoder {

    let initURL: URL
    
    init(url: URL) {
        self.initURL = url
        super.init()
    }
    
    func decode() throws -> NibDecoderResult {
        

        let plistURL = initURL.appendingPathComponent("Info.plist")
        guard let dict = NSDictionary(contentsOf: plistURL) else {
            throw CLI.Error(message: "Cann't find Info.plist inside .storyboardc")
        }

        guard let stMap = dict["UIViewControllerIdentifiersToNibNames"] as? [String: String] else {
            throw CLI.Error(message: "Wrong file format. Cann't find 'UIViewControllerIdentifiersToNibNames' key in Info.plist")
        }

        var nibResults = [NibFileDecoderResult]()
        var connectionsResults = [NibFileConnectionDecoderResult]()
                 
        let children = try FileManager.default.contentsOfDirectory(at: initURL, includingPropertiesForKeys: nil, options: [])
        
        for oneFile in children {
            
            if case Utils.xibFileFormat(for: oneFile) = XibFileFormat.nib {
                
                let fileName = (oneFile.lastPathComponent as NSString).deletingPathExtension // Drop '.nib' extention.
                if stMap.values.contains(fileName) {
                
                    let nibDecoder = NibFileConnectionDecoder(url: oneFile, onlyNibParsing: false)
                    if let result = try nibDecoder.decode() as? NibFileConnectionDecoderResult {
                        connectionsResults.append(result)
                    }
                    
                    
                } else {
                    
                    let nibDecoder = NibFileDecoder(url: oneFile)
                    if let result = try nibDecoder.decode() as? NibFileDecoderResult {
                        nibResults.append(result)
                    }
                }
                
            }
        }

        return StoryboardFileDecoderResult(fileName: initURL.lastPathComponent, nibResults: nibResults, connectionsResult: connectionsResults)
    }
}
