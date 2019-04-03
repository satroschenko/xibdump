//
//  ConstraintsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/3/19.
//

import Cocoa

class ConstraintsDecoder: NSObject, CustomTagDecoderProtocol {
    
    fileprivate let names = [
        "notAnAttribute",
        "left",
        "right",
        "top",
        "bottom",
        "leading",
        "trailing",
        "width",
        "height",
        "centerX",
        "centerY",
        "lastBaseline",
        "lastBaseline",
        "firstBaseline"
        ]

    func handledClassNames() -> [String] {
        
        return [
            "T.UIViewAutolayoutConstraints-NSMutableArray",
            "T.UIViewAutolayoutConstraints-NSArray"
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let arrayObject = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let parentTag = Tag(name: "constraints")
        parentTag.innerObjectId = parentObject.objectId
        
        for oneParameter in arrayObject.parameters(with: context) {
            
            if let pObject = oneParameter.object(with: context) {
                if oneParameter.name == "UINibEncoderEmptyKey" {
                    
                    let subTag = processOneObject(object: pObject, context: context)
                    context.constrains[subTag.innerObjectId] = subTag
                    parentTag.add(tag: subTag)
                }
            }
        }
        
        if parentTag.allChildren().count > 0 {
            return .tag(parentTag, false)
        }
        
        return .empty(false)
    }
    
    // swiftlint:disable cyclomatic_complexity
    fileprivate func processOneObject(object: XibObject, context: ParserContext) -> Tag {
        
        let tag = Tag(name: "constraint")
        tag.addParameter(name: "id", value: object.objectId)
        tag.innerObjectId = object.objectId
        
        if let firstAttribute = findIntAttribute(object: object, context: context, name1: "NSFirstAttribute", name2: "NSFirstAttributeV2") {
            if let name = self.names[safe: firstAttribute] {
                tag.addParameter(name: "firstAttribute", value: name)
            }
        }
        
        if let secondAttribute = findIntAttribute(object: object, context: context, name1: "NSSecondAttribute", name2: "NSSecondAttributeV2") {
            if let name = self.names[safe: secondAttribute] {
                tag.addParameter(name: "secondAttribute", value: name)
            }
        }
        
        if let constant = findDoubleAttribute(object: object, context: context, name1: "NSConstant", name2: "NSConstantV2") {
            tag.addParameter(name: "constant", value: "\(constant)")
        }
        
        if let multiplier = findDoubleAttribute(object: object, context: context, name1: "NSMultiplier", name2: "NSMultiplier") {
            tag.addParameter(name: "multiplier", value: "\(multiplier)")
        }
        
        if let priority = findIntAttribute(object: object, context: context, name1: "NSPriority", name2: "NSPriority") {
            tag.addParameter(name: "priority", value: "\(priority)")
        }
        
        if let identifier = findStringAttribute(object: object, context: context, name: "NSLayoutIdentifier") {
            tag.addParameter(name: "identifier", value: identifier)
        }
        
        if let firstItemId = findViewId(object: object, context: context, name: "NSFirstItem") {
            tag.addParameter(name: "firstItem", value: firstItemId)
        }
        
        if let secondItemId = findViewId(object: object, context: context, name: "NSSecondItem") {
            tag.addParameter(name: "secondItem", value: secondItemId)
        }
        
        if let relation = findIntAttribute(object: object, context: context, name1: "NSRelation", name2: "NSRelation") {
            
            var relationName: String?
            if relation == -1 {
                relationName = "lessThanOrEqual"
            } else if relation == 0 {
                relationName = "equal"
            } else if relation == 1 {
                relationName = "greaterThanOrEqual"
            }
            
            if let relationName = relationName {
                tag.addParameter(name: "relation", value: relationName)
            }
        }
        
        return tag
    }
    // swiftlint:enable cyclomatic_complexity

    
    fileprivate func findIntAttribute(object: XibObject, context: ParserContext, name1: String, name2: String) -> Int? {
        
        if let value = object.findIntParameter(name: name1, context: context) {
            return value
        }
        
        if let value = object.findIntParameter(name: name2, context: context) {
            return value
        }
        
        return nil
    }
    
    fileprivate func findDoubleAttribute(object: XibObject, context: ParserContext, name1: String, name2: String) -> Double? {
        
        if let value = object.findDoubleParameter(name: name1, context: context) {
            return value
        }
        
        if let value = object.findDoubleParameter(name: name2, context: context) {
            return value
        }
        
        return nil
    }
    
    fileprivate func findStringAttribute(object: XibObject, context: ParserContext, name: String) -> String? {
        
        if let value = object.findStringParameter(name: name, context: context) {
            return value
        }
        
        return nil
    }
    
    
    fileprivate func findViewId(object: XibObject, context: ParserContext, name: String) -> String? {
        
        if let param = object.parameter(with: name, context: context) {
            if let object = param.object(with: context) {
                return object.objectId
            }
        }
        
        return nil
    }
}
