//
//  AccessibilitiesDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/3/19.
//

import Cocoa

class AccessibilitiesDecoder: NSObject, TagDecoderProtocol {
    
    struct AccessibilityTraitsOptionSet: OptionSet {
        
        let rawValue: Int
        
        static let button                   = AccessibilityTraitsOptionSet(rawValue: 1 << 0)
        static let link                     = AccessibilityTraitsOptionSet(rawValue: 1 << 1)
        static let image                    = AccessibilityTraitsOptionSet(rawValue: 1 << 2)
        static let selected                 = AccessibilityTraitsOptionSet(rawValue: 1 << 3)
        static let playsSound               = AccessibilityTraitsOptionSet(rawValue: 1 << 4)
        static let keyboardKey              = AccessibilityTraitsOptionSet(rawValue: 1 << 5)
        static let staticText               = AccessibilityTraitsOptionSet(rawValue: 1 << 6)
        static let summaryElement           = AccessibilityTraitsOptionSet(rawValue: 1 << 7)
        static let unknown1                 = AccessibilityTraitsOptionSet(rawValue: 1 << 8) // 256
        static let updatesFrequently        = AccessibilityTraitsOptionSet(rawValue: 1 << 9)
        static let searchField              = AccessibilityTraitsOptionSet(rawValue: 1 << 10)
        static let startsMediaSession       = AccessibilityTraitsOptionSet(rawValue: 1 << 11)
        static let adjustable               = AccessibilityTraitsOptionSet(rawValue: 1 << 12)
        static let allowsDirectInteraction  = AccessibilityTraitsOptionSet(rawValue: 1 << 13)
        static let causesPageTurn           = AccessibilityTraitsOptionSet(rawValue: 1 << 14)
        static let unknown2                 = AccessibilityTraitsOptionSet(rawValue: 1 << 15)
        static let header                   = AccessibilityTraitsOptionSet(rawValue: 1 << 16)

    }
    
    
    
    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: "UINibAccessibilityConfigurationsKey", className: "NSArray", isTopLevel: false)]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let arrayObject = parameter.object(with: context) else {
            return .empty(false)
        }
        
        for oneParameter in arrayObject.parameters(with: context) {
            
            if let pObject = oneParameter.object(with: context) {
                if oneParameter.name == "UINibEncoderEmptyKey" {
                    
                    processOneObject(object: pObject, context: context)
                }
            }
        }
        
        return .empty(false)
    }
    
    fileprivate func processOneObject(object: XibObject, context: ParserContext) {
        
        guard let foundObject = object.findObjectParameter(name: "UIAccessibileObject", context: context) else {
            return
        }
        
        let parentTag = getParentTag(objectId: foundObject.objectId, context: context)
        
        if let hintParam = object.parameter(with: "UIAccessibilityHint", context: context),
            let hintObj = hintParam.object(with: context),
            let hint = hintObj.firstStringValue(with: context) {
            
            parentTag.addParameter(name: "hint", value: hint)
        }
        
        if let idParam = object.parameter(with: "UIAccessibilityIdentifier", context: context),
            let idObj = idParam.object(with: context),
            let idString = idObj.firstStringValue(with: context) {
            
            parentTag.addParameter(name: "identifier", value: idString)
        }
        
        if let labelParam = object.parameter(with: "UIAccessibilityLabel", context: context),
            let labelObj = labelParam.object(with: context),
            let label = labelObj.firstStringValue(with: context) {
            
            parentTag.addParameter(name: "label", value: label)
        }
        
        if let isAccParam = object.parameter(with: "UIIsAccessibilityElement", context: context),
            let isAccObj = isAccParam.object(with: context),
            let value = isAccObj.findIntParameter(name: "NS.intval", context: context) {
            
            let isElementTag = Tag(name: "bool")
            isElementTag.addParameter(name: "key", value: "isElement")
            isElementTag.addParameter(name: "value", value: (value == 0 ? "NO" : "YES"))
            
            parentTag.add(tag: isElementTag)
        }
        
        extractAccessibilityTraits(object: object, context: context, parentTag: parentTag)
    }
    
    
    // swiftlint:disable cyclomatic_complexity
    fileprivate func extractAccessibilityTraits(object: XibObject, context: ParserContext, parentTag: Tag) {
        if let configParam = object.parameter(with: "UIAccessibilityTraits", context: context),
            let configObject = configParam.object(with: context),
            let config = configObject.findIntParameter(name: "NS.intval", context: context) {
            
            let optionSet = AccessibilityTraitsOptionSet(rawValue: config)
            
            let tag = Tag(name: "accessibilityTraits")
            tag.addParameter(name: "key", value: "traits")
            
            if optionSet.contains(.button) {
                tag.addParameter(name: "button", value: "YES")
            }
            if optionSet.contains(.link) {
                tag.addParameter(name: "link", value: "YES")
            }
            if optionSet.contains(.image) {
                tag.addParameter(name: "image", value: "YES")
            }
            if optionSet.contains(.selected) {
                tag.addParameter(name: "selected", value: "YES")
            }
            if optionSet.contains(.playsSound) {
                tag.addParameter(name: "playsSound", value: "YES")
            }
            if optionSet.contains(.keyboardKey) {
                tag.addParameter(name: "keyboardKey", value: "YES")
            }
            if optionSet.contains(.staticText) {
                tag.addParameter(name: "staticText", value: "YES")
            }
            if optionSet.contains(.summaryElement) {
                tag.addParameter(name: "summaryElement", value: "YES")
            }
            if optionSet.contains(.updatesFrequently) {
                tag.addParameter(name: "updatesFrequently", value: "YES")
            }
            if optionSet.contains(.searchField) {
                tag.addParameter(name: "searchField", value: "YES")
            }
            if optionSet.contains(.startsMediaSession) {
                tag.addParameter(name: "startsMediaSession", value: "YES")
            }
            if optionSet.contains(.adjustable) {
                tag.addParameter(name: "adjustable", value: "YES")
            }
            if optionSet.contains(.allowsDirectInteraction) {
                tag.addParameter(name: "allowsDirectInteraction", value: "YES")
            }
            if optionSet.contains(.causesPageTurn) {
                tag.addParameter(name: "causesPageTurn", value: "YES")
            }
            if optionSet.contains(.header) {
                tag.addParameter(name: "header", value: "YES")
            }
            
            parentTag.add(tag: tag)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    
    fileprivate func getParentTag(objectId: String, context: ParserContext) -> Tag {
        
        var tag = context.accessibilityAttributes[objectId]
        if tag == nil {
            tag = Tag(name: "accessibility")
            context.accessibilityAttributes[objectId] = tag
        }
        
        tag?.addParameter(name: "key", value: "accessibilityConfiguration")
        
        return tag!
    }
}
