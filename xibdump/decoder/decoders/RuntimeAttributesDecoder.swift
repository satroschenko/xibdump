//
//  RuntimeAttributesDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/2/19.
//

import Cocoa

class RuntimeAttributesDecoder: NSObject, CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        
        return ["A.UINibKeyValuePairsKey-NSArray"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let pairArrayObject = parameter.object(with: context) else {
            return .empty(false)
        }
        
        for oneParameter in pairArrayObject.parameters(with: context) {
            
            if let pObject = oneParameter.object(with: context) {
                if oneParameter.name == "UINibEncoderEmptyKey" {
                    
                    processPairObject(parentObject: parentObject, object: pObject, context: context)
                }
            }
        }
        
        return .empty(false)
    }
    
    
    private func processPairObject(parentObject: XibObject, object: XibObject, context: ParserContext) {
        
        guard let foundObject = object.findObjectParameter(name: "UIObject", context: context) else {
            return
        }
        
        guard let valueParameter = object.parameter(with: "UIValue", context: context) else {
            return
        }
        
        guard let keyPath = object.findStringParameter(name: "UIKeyPath", context: context) else {
            return
        }
        
        let attributeTag = getParentTag(objectId: foundObject.objectId, context: context)
        attributeTag.addParameter(name: "keyPath", value: keyPath)
        
        
        guard let valueObject = valueParameter.object(with: context) else {
            if valueParameter is XibNullParameter {
                attributeTag.addParameter(name: "type", value: "nil")
            }
            
            return
        }
        
        
        let objectClass = valueObject.originalClassName(context: context)
        
        if objectClass == "NSNumber" {
            
            processNumbers(object: valueObject, context: context, parentTag: attributeTag)
        
        } else if objectClass == "NSString" {
            
            processStrings(object: valueObject, context: context, parentTag: attributeTag)
        
        } else if objectClass == "NSValue" {
            
            processNSValues(object: valueObject, context: context, parentTag: attributeTag)
        
        } else if objectClass == "UIImageNibPlaceholder" {
            
            processImage(object: valueObject, context: context, parentTag: attributeTag)
        
        } else if objectClass == "UIColor" {
            
            processColor(parentObject: parentObject, object: valueObject, context: context, parentTag: attributeTag)
        }
    }
    
    
    fileprivate func getParentTag(objectId: String, context: ParserContext) -> Tag {
    
        var tag = context.runtimeAttributes[objectId]
        if tag == nil {
            tag = Tag(name: "userDefinedRuntimeAttributes")
            context.runtimeAttributes[objectId] = tag
        }
        
        let attributeTag = Tag(name: "userDefinedRuntimeAttribute")
        tag?.add(tag: attributeTag)
        
        return attributeTag
    }
    
    
    fileprivate func processNumbers(object: XibObject, context: ParserContext, parentTag: Tag) {
        
        if let firstParameter = object.parameters(with: context).first {
            
            if let firstIntParameter = firstParameter as? XibIntParameter {
                parentTag.addParameter(name: "type", value: "number")
                let valueTag = Tag(name: "integer")
                valueTag.addParameter(name: "key", value: "value")
                valueTag.addParameter(name: "value", value: "\(firstIntParameter.value)")
                parentTag.add(tag: valueTag)
            }
            
            if let firstFloatParameter = firstParameter as? XibFloatParameter {
                parentTag.addParameter(name: "type", value: "number")
                let valueTag = Tag(name: "real")
                valueTag.addParameter(name: "key", value: "value")
                valueTag.addParameter(name: "value", value: "\(firstFloatParameter.value)")
                parentTag.add(tag: valueTag)
            }
            
            if let firstDoubleParameter = firstParameter as? XibDoubleParameter {
                parentTag.addParameter(name: "type", value: "number")
                let valueTag = Tag(name: "real")
                valueTag.addParameter(name: "key", value: "value")
                valueTag.addParameter(name: "value", value: "\(firstDoubleParameter.value)")
                parentTag.add(tag: valueTag)
            }
            
        } else {
            // Bool with YES.
            parentTag.addParameter(name: "type", value: "boolean")
            parentTag.addParameter(name: "value", value: "YES")
        }
    }
    
    
    fileprivate func processStrings(object: XibObject, context: ParserContext, parentTag: Tag) {
        if let stringValue = object.firstStringValue(with: context) {
            parentTag.addParameter(name: "type", value: "string")
            parentTag.addParameter(name: "value", value: stringValue)
        }
    }
    
    fileprivate func processImage(object: XibObject, context: ParserContext, parentTag: Tag) {
        
        guard let param = object.parameter(with: "UIResourceName", context: context) else {
            return
        }
        
        guard let stringObject = param.object(with: context) else {
            return
        }
        
        guard let value = stringObject.firstStringValue(with: context) else {
            return
        }
        
        parentTag.addParameter(name: "type", value: "image")
        parentTag.addParameter(name: "value", value: value)
        
        context.addImageResource(name: value)
    }
    
    fileprivate func processColor(parentObject: XibObject, object: XibObject, context: ParserContext, parentTag: Tag) {
    
        let colorTag = UIColorDecoder.extractColorTag(parentObject: parentObject,
                                                      object: object,
                                                      tagName: "color",
                                                      parameterName: "value",
                                                      context: context)
        
        parentTag.addParameter(name: "type", value: "color")
        parentTag.add(tag: colorTag)
    }
    
    
    fileprivate func processNSValues(object: XibObject, context: ParserContext, parentTag: Tag) {
        
        guard let spesialParameter = object.parameter(with: "NS.special", context: context) else {
            return
        }
        
        guard let spesialIntParameter = spesialParameter as? XibIntParameter else {
            return
        }
        
        if spesialIntParameter.value == 1 {
            processNSPoint(object: object, context: context, parentTag: parentTag)
            
        } else if spesialIntParameter.value == 2 {
            processSize(object: object, context: context, parentTag: parentTag)
        
        } else if spesialIntParameter.value == 3 {
            processRect(object: object, context: context, parentTag: parentTag)
        
        } else if spesialIntParameter.value == 4 {
            processRenge(object: object, context: context, parentTag: parentTag)
        }
    }
    
    
    fileprivate func processNSPoint(object: XibObject, context: ParserContext, parentTag: Tag) {
        // Point.
        if let pointValParam = object.parameter(with: "NS.pointval", context: context),
            let stringValueObject = pointValParam.object(with: context),
            let stringValue  = stringValueObject.firstStringValue(with: context) {
            
            let point = NSPointFromString(stringValue)
            
            let valueTag = Tag(name: "point")
            valueTag.addParameter(name: "key", value: "value")
            valueTag.addParameter(name: "x", value: "\(point.x)")
            valueTag.addParameter(name: "y", value: "\(point.y)")
            
            parentTag.addParameter(name: "type", value: "point")
            parentTag.add(tag: valueTag)
        }
    }
    
    fileprivate func processSize(object: XibObject, context: ParserContext, parentTag: Tag) {
        // Point.
        if let valParam = object.parameter(with: "NS.sizeval", context: context),
            let stringValueObject = valParam.object(with: context),
            let stringValue  = stringValueObject.firstStringValue(with: context) {
            
            let size = NSSizeFromString(stringValue)
            
            let valueTag = Tag(name: "size")
            valueTag.addParameter(name: "key", value: "value")
            valueTag.addParameter(name: "width", value: "\(size.width)")
            valueTag.addParameter(name: "height", value: "\(size.height)")
            
            parentTag.addParameter(name: "type", value: "size")
            parentTag.add(tag: valueTag)
        }
    }
    
    fileprivate func processRect(object: XibObject, context: ParserContext, parentTag: Tag) {
        // Point.
        if let valParam = object.parameter(with: "NS.rectval", context: context),
            let stringValueObject = valParam.object(with: context),
            let stringValue  = stringValueObject.firstStringValue(with: context) {
            
            let rect = NSRectFromString(stringValue)
            
            let valueTag = Tag(name: "rect")
            valueTag.addParameter(name: "key", value: "value")
            valueTag.addParameter(name: "x", value: "\(rect.origin.x)")
            valueTag.addParameter(name: "y", value: "\(rect.origin.y)")
            valueTag.addParameter(name: "width", value: "\(rect.width)")
            valueTag.addParameter(name: "height", value: "\(rect.height)")
            
            parentTag.addParameter(name: "type", value: "rect")
            parentTag.add(tag: valueTag)
        }
    }
    
    fileprivate func processRenge(object: XibObject, context: ParserContext, parentTag: Tag) {
        // Point.
        guard let valLengthParam = object.parameter(with: "NS.rangeval.length", context: context),
            let valueLengthObject = valLengthParam.object(with: context),
            let firstLengthParam  = valueLengthObject.parameter(with: "NS.intval", context: context),
            let intLengthParam = firstLengthParam as? XibIntParameter else {
            return
        }
        
        guard let valLocParam = object.parameter(with: "NS.rangeval.location", context: context),
            let valueLocObject = valLocParam.object(with: context),
            let firstLocParam  = valueLocObject.parameter(with: "NS.intval", context: context),
            let intLocParam = firstLocParam as? XibIntParameter else {
                return
        }
        
        let valueTag = Tag(name: "range")
        valueTag.addParameter(name: "key", value: "value")
        valueTag.addParameter(name: "length", value: "\(intLengthParam.value)")
        valueTag.addParameter(name: "location", value: "\(intLocParam.value)")
        
        parentTag.addParameter(name: "type", value: "range")
        parentTag.add(tag: valueTag)
    }
}
