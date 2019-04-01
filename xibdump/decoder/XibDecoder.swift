//
//  XibDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa
import AEXML
import SwiftCLI

class XibDecoder: NSObject {

    let parentTag: Tag = XibParentTag()
    let decoderHolder = CustomDecodersHolder()
    let context: ParserContext
    
    init(xibFile: XibFile) {
        self.context = ParserContext(xibFile: xibFile)
        super.init()
    }
    
    func decode() {

        self.context.xibFile.clean()
        if let firstObject = self.context.xibFile.xibObjects.first {
            parse(object: firstObject, context: self.context, parentTag: parentTag, topLevelObject: false)
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
    
    
    
    fileprivate func parse(object: XibObject, context: ParserContext, parentTag: Tag, topLevelObject: Bool, tabCount: Int = 0) {
        
        if object.isSerialized {
            return
        }
        object.isSerialized = true
        
        for parameter in object.parameters(with: context) {
            
            var isTopObject = topLevelObject
            if parameter.name == "UINibTopLevelObjectsKey" {
                isTopObject = true
            }
            
            parse(parameter: parameter, context: context, parentTag: parentTag, topLevelObject: isTopObject, tabCount: tabCount+1)
        }
    }
    
    fileprivate func parse(parameter: XibParameterProtocol, context: ParserContext, parentTag: Tag, topLevelObject: Bool, tabCount: Int = 0) {
        
        if let decoder = decoderHolder.parser(by: parameter, context: context, isTopLevel: topLevelObject) {
            
            let result = decoder.parse(parameter: parameter, context: context)
            
            var cont = true
            var nextTag = parentTag
            
            switch result {
            case .tag(let tag, let needContinue):
                parentTag.add(tag: tag)
                nextTag = tag
                cont = needContinue
                
            case .parameters(let parameters, let needContinue):
                parentTag.add(parameters: parameters)
                cont = needContinue

            case .empty(let needContinue):
                cont = needContinue
                
            }
            
            if cont {
                if let object = parameter.object(with: context) {
                    parse(object: object, context: context, parentTag: nextTag, topLevelObject: topLevelObject, tabCount: tabCount)
                }
            }
            return
        }
        
//        
//        if let object = parameter.object(with: context) {
//            parse(object: object, context: context, parentTag: parentTag, topLevelObject: topLevelObject, tabCount: tabCount)
//        }
    }
}

extension Tag {

    func getNode() -> AEXMLElement {

        let node = AEXMLElement(name: name)
        for parameter in allParameters() {
            node.attributes[parameter.name] = parameter.value
        }

        for child in allChildren() {
            node.addChild(child.getNode())
        }

        return node
    }
}
