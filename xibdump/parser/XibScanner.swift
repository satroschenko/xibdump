//
//  XibScanner.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa


class ParserContext: NSObject {
    
    let decoderHolder = DecodersHolder()
    
    let xibFile: XibFile
    var runtimeAttributes: [String: Tag] = [String: Tag]()
    var accessibilityAttributes: [String: Tag] = [String: Tag]()
    var variations: [String: [Tag]] = [String: [Tag]]()
    var imageResources: [Tag] = [Tag]()
    
    fileprivate var constrains: [String: Tag] = [String: Tag]()
    fileprivate var allTags: [String: Tag] = [String: Tag]()
    
    fileprivate var addedImageNames: [String] = [String]()
    
    init(xibFile: XibFile) {
        self.xibFile = xibFile
        super.init()
    }
    
    func clean() {
        xibFile.clean()
        runtimeAttributes.removeAll()
        accessibilityAttributes.removeAll()
        imageResources.removeAll()
        constrains.removeAll()
        variations.removeAll()
        
        addedImageNames.removeAll()
        allTags.removeAll()
    }
    
    func addImageResource(name: String) {
        
        if !addedImageNames.contains(name) {
            
            addedImageNames.append(name)
            
            let tag = Tag(name: "image")
            tag.addParameter(name: "name", value: name)
            tag.addParameter(name: "width", value: "16")
            tag.addParameter(name: "height", value: "16")
            
            imageResources.append(tag)
        }
    }
    
    func findTag(objectId: String) -> Tag? {
        
        if let tag = allTags[objectId] {
            return tag
        }
        
        return findConstraintTag(objectId: objectId)
    }
    
    func findConstraintTag(objectId: String) -> Tag? {
        
        return constrains[objectId]
    }
    
    func addTag(tag: Tag) {
        if !tag.innerObjectId.isEmpty {
            
            allTags[tag.innerObjectId] = tag
        }
    }
    
    func addConstraintTag(tag: Tag) {
        if !tag.innerObjectId.isEmpty {            
            constrains[tag.innerObjectId] = tag
        }
    }
}



extension XibParameterProtocol {
    
    func object(with context: ParserContext) -> XibObject? {
        
        if let obj = self as? XibObjectParameter {
            return context.xibFile.xibObjects[safe: obj.objectIndex]
        }
        return nil
    }
}


extension XibObject {
    
    func parameters(with context: ParserContext) -> [XibParameterProtocol] {
        
        var result = [XibParameterProtocol]()
        
        let start = xibValueIndex
        let end = xibValueIndex + valueCount
        
        for index in start ..< end {
            
            if let parameter = context.xibFile.xibParameters[safe:index] {
                
                result.append(parameter)
            }
        }
        
        return result
    }
    
    
    func firstStringValue(with context: ParserContext) -> String? {
        
        if let parameter = context.xibFile.xibParameters[safe: self.xibValueIndex] {
            return parameter.stringValue()
        }
        
        return nil
    }
    
    func parameter(with name: String, context: ParserContext) -> XibParameterProtocol? {
        
        for parameter in parameters(with: context) where parameter.name == name {
            return parameter
        }
        
        return nil
    }
    
    func findIntParameter(name: String, context: ParserContext) -> Int? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let intParameter = parameter as? XibIntParameter {
                return intParameter.value
            }
        }
        return nil
    }
    
    func findBoolParameter(name: String, context: ParserContext) -> Bool? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let boolParameter = parameter as? XibBoolParameter {
                return boolParameter.value
            }
        }
        return nil
    }
    
    func findFloatParameter(name: String, context: ParserContext) -> Float? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let floatParameter = parameter as? XibFloatParameter {
                return floatParameter.value
            }
        }
        return nil
    }
    
    func findDoubleParameter(name: String, context: ParserContext) -> Double? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let doubleParameter = parameter as? XibDoubleParameter {
                return doubleParameter.value
            }
        }
        return nil
    }
    
    func findStringParameter(name: String, context: ParserContext) -> String? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let stringObject = parameter.object(with: context) {
                return stringObject.firstStringValue(with: context)
            }
        }
        return nil
    }
    
    func findDataParameter(name: String, context: ParserContext) -> Data? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let dataParameter = parameter as? XibDataParameter {
                return dataParameter.value
            }
        }
        return nil
    }
    
    func findObjectParameter(name: String, context: ParserContext) -> XibObject? {
        
        for parameter in parameters(with: context) where parameter.name == name {
            
            if let objectParameter = parameter as? XibObjectParameter {
                return objectParameter.object(with: context)
            }
        }
        return nil
    }
    
    func findObjectParameter(name: String, objectClass: String, context: ParserContext) -> XibObject? {
        
        for parameter in parameters(with: context) where parameter.name == name {
            
            if let object = parameter.object(with: context) {
                if object.originalClassName(context: context) == objectClass {
                    return object
                }
            }
        }
        return nil
    }
    
    func findFirstObjectParameter(objectClass: String, context: ParserContext) -> XibObject? {
        
        for parameter in parameters(with: context) {
            
            if let object = parameter.object(with: context) {
                if object.originalClassName(context: context) == objectClass {
                    return object
                }
            }
        }
        return nil
    }
    
    
    func getSubObjects(parameterName: String, objectClass: String, context: ParserContext) -> [XibObject] {
        
        var result: [XibObject] = [XibObject]()
        for parameter in parameters(with: context) where parameter.name == parameterName {
            if let pObject = parameter.object(with: context) {
                if pObject.originalClassName(context: context) == objectClass {
                    result.append(pObject)
                }
            }
        }
        
        return result
    }
    
    func getSubObjects(parameterName: String, objectClassSuffix: String, context: ParserContext) -> [XibObject] {
        
        var result: [XibObject] = [XibObject]()
        for parameter in parameters(with: context) where parameter.name == parameterName {
            if let pObject = parameter.object(with: context) {
                if pObject.originalClassName(context: context).hasSuffix(objectClassSuffix) {
                    result.append(pObject)
                }
            }
        }
        
        return result
    }
    
    
    func originalClassName(context: ParserContext) -> String {
        
        var className = xibClass.name
        
        if className == "UIClassSwapper" {
            if let originalClassName = findStringParameter(name: "UIOriginalClassName", context: context) {
                className = originalClassName
            }
        }
        
        return className
    }
    
    func previousParameter(parameter: XibParameterProtocol, context: ParserContext) -> XibParameterProtocol? {
        
        var found: XibParameterProtocol?
        
        for oneParameter in parameters(with: context) {
            
            if !oneParameter.isEqual(parameter) {
                found = oneParameter
            } else {
                return found
            }
        }
        return nil
    }
    
    
    func decode(context: ParserContext, parentTag: Tag) {
        return decode(object: self, context: context, parentTag: parentTag, topLevelObject: false, tabCount: 0)
    }
    
    
    fileprivate func decode(object: XibObject, context: ParserContext, parentTag: Tag, topLevelObject: Bool, tabCount: Int = 0) {
        
        if object.isSerialized {
            return
        }
        object.isSerialized = true
        
        for parameter in object.parameters(with: context) {
            
            var isTopObject = topLevelObject
            if parameter.name == "UINibTopLevelObjectsKey" {
                isTopObject = true
            }
            
            decode(parentObject: object,
                   parameter: parameter,
                   context: context,
                   parentTag: parentTag,
                   topLevelObject: isTopObject,
                   tabCount: tabCount+1)
        }
    }
    
    fileprivate func decode(parentObject: XibObject,
                            parameter: XibParameterProtocol,
                            context: ParserContext,
                            parentTag: Tag,
                            topLevelObject: Bool,
                            tabCount: Int = 0) {
        
        if let decoder = context.decoderHolder.parser(by: parameter, context: context, isTopLevel: topLevelObject) {
            
            let result = decoder.parse(parentObject: parentObject, parameter: parameter, context: context)
            
            var cont = true
            var nextTag = parentTag
            
            switch result {
            case .tag(let tag, let needContinue):
                parentTag.add(tag: tag)
                nextTag = tag
                cont = needContinue
                
                context.addTag(tag: tag)
                
            case .parameters(let parameters, let needContinue):
                parentTag.add(parameters: parameters)
                cont = needContinue
                
            case .empty(let needContinue):
                cont = needContinue
                
            case .tags(let tags):
                parentTag.add(tags: tags)
                cont = false
                
                for tag in tags {
                    context.addTag(tag: tag)
                }
                
            }
            
            if cont {
                if let object = parameter.object(with: context) {
                    decode(object: object, context: context, parentTag: nextTag, topLevelObject: topLevelObject, tabCount: tabCount)
                }
            }
            return
        }
    }
}
