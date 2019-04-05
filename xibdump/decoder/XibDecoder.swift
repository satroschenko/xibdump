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

        self.context.clean()
        if let firstObject = self.context.xibFile.xibObjects.first {
            parse(object: firstObject, context: self.context, parentTag: parentTag, topLevelObject: false)
        }
        
        let flatArray = parentTag.flatArray()
        addMissingColorsToLabels(array: flatArray)
        addDefaultOpaque(array: flatArray, classNames: ["view", "label", "button"])
        
        for (objectId, tag) in self.context.runtimeAttributes {
            if let foundTag = findSubTag(array: flatArray, innerId: objectId) {
                foundTag.add(tag: tag)
            }
        }
        
        for (objectId, tag) in self.context.accessibilityAttributes {
            if let foundTag = findSubTag(array: flatArray, innerId: objectId) {
                foundTag.add(tag: tag)
            }
        }
        
        for (objectId, tags) in self.context.variations {
            if let foundTag = findSubTag(array: flatArray, innerId: objectId) {
                foundTag.add(tags: tags)
            }
        }
        
        if !context.imageResources.isEmpty {
            let resourcesTag = Tag(name: "resources")
            resourcesTag.add(tags: context.imageResources)
            parentTag.add(tag: resourcesTag)
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
            
            parse(parentObject: object,
                  parameter: parameter,
                  context: context,
                  parentTag: parentTag,
                  topLevelObject: isTopObject,
                  tabCount: tabCount+1)
        }
    }
    
    fileprivate func parse(parentObject: XibObject,
                           parameter: XibParameterProtocol,
                           context: ParserContext,
                           parentTag: Tag,
                           topLevelObject: Bool,
                           tabCount: Int = 0) {
        
        if let decoder = decoderHolder.parser(by: parameter, context: context, isTopLevel: topLevelObject) {
            
            let result = decoder.parse(parentObject: parentObject, parameter: parameter, context: context)
            
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
            
            case .tags(let tags):
                parentTag.add(tags: tags)
                cont = false
                
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
    
    
    private func findSubTag(array: [Tag], innerId: String) -> Tag? {
    
        for item in array where item.innerObjectId == innerId {
            return item
        }
        
        return nil
    }
    
    
    
    fileprivate func addMissingColorsToLabels(array: [Tag]) {
     
        for tag in array where tag.name == "label" {
            addMissingColor(tag: tag, colorList: ["textColor", "highlightedColor"])
        }
    }
    
    fileprivate func addDefaultOpaque(array: [Tag], classNames: [String]) {
        
        for tag in array where classNames.contains(tag.name) {
            if tag.parameterValue(name: "opaque") == nil {
                tag.addParameter(name: "opaque", value: "NO")
            }
        }
    }
    
    fileprivate func addMissingColor(tag: Tag, colorList: [String]) {
    
        for colorName in colorList {
            var colorNameFound = false
            for colorTag in tag.allChildren() where colorTag.name == "color" {
                if let name = colorTag.parameterValue(name: "key") {
                    if name == colorName {
                        colorNameFound = true
                    }
                }
            }
            
            if !colorNameFound {
                let nilTag = Tag(name: "nil")
                nilTag.addParameter(name: "key", value: colorName)
                
                tag.add(tag: nilTag)
            }
        }
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
    
    func flatArray() -> [Tag] {
        
        var result: [Tag] = [Tag]()
        result.append(self)
        
        for child in allChildren() {
            result.append(contentsOf: child.flatArray())
        }
        
        return result
    }
    
    func parameterValue(name: String) -> String? {
        
        for parameter in allParameters() where parameter.name == name {
            return parameter.value
        }
        return nil
    }
}
