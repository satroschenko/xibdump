//
//  ConstraintsVariationsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class ConstraintsVariationsDecoder: NSObject, TagDecoderProtocol {

    func handledClassNames() -> [String] {
        
        return [
            Utils.decoderKey(parameterName: "A.UINibTraitStorageListsKey", className: "NSMutableArray", isTopLevel: false),
            Utils.decoderKey(parameterName: "A.UINibTraitStorageListsKey", className: "NSArray", isTopLevel: false)
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let arrayObject = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let traitStorageList = arrayObject.findObjectParameter(name: "UINibEncoderEmptyKey",
                                                                     objectClass: "_UITraitStorageList",
                                                                     context: context) else {
            return .empty(false)
        }
        
        guard let traitStorageArray = traitStorageList.findObjectParameter(name: "UITraitStorages", objectClass: "NSArray", context: context) else {
            return .empty(false)
        }
        
        
        let attributeStorageArray = traitStorageArray.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                                    objectClass: "_UIAttributeTraitStorage",
                                                                    context: context)
        
        for attributeStorage in attributeStorageArray {
            parseAttributeStorage(object: attributeStorage, context: context)
        }
        
        
        let relationshipStorageArray = traitStorageArray.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                                       objectClass: "_UIRelationshipTraitStorage",
                                                                       context: context)
        
        for relationshipStorage in relationshipStorageArray {
            parseRelationshipStorage(object: relationshipStorage, context: context)
        }
        
     
        return .empty(false)
    }
    
    
    fileprivate func parseAttributeStorage(object: XibObject, context: ParserContext) {
        
        guard let variationObject = object.findObjectParameter(name: "UIObject", context: context) else {
            return
        }
        
        guard let variationTag = context.findTag(objectId: variationObject.objectId) else {
            return
        }
        
        var keyPath: String = ""
        if let keyPathObj = object.findObjectParameter(name: "UIKeyPath", objectClass: "NSString", context: context) {
            if let string = keyPathObj.firstStringValue(with: context) {
                keyPath = string
            }
        }
        
        guard let recordsArrayObject = object.findObjectParameter(name: "UIRecords", objectClass: "NSMutableArray", context: context) else {
            return
        }
        
        let recordsArray = recordsArrayObject.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "_UIAttributeTraitStorageRecord",
                                                            context: context)
        
        for oneRecord in recordsArray {
            parseRecord(object: oneRecord, context: context, parentTag: variationTag, keyPath: keyPath)
        }
    }
    
    
    fileprivate func parseRecord(object: XibObject, context: ParserContext, parentTag: Tag, keyPath: String) {
        
        guard let traintCollectionObject = object.findObjectParameter(name: "UITraitCollection",
                                                                      objectClass: "UITraitCollection",
                                                                      context: context) else {
            return
        }
        
        guard let valueObject = object.findObjectParameter(name: "UIValue",
                                                           context: context) else {
                                                                
            return
        }
        
        var variations = [String: Int]()
        
        for param in traintCollectionObject.parameters(with: context) {
            if let intParam = param as? XibIntParameter {
                let name = intParam.name
                variations[name] = intParam.value
            }
        }
        
        if variations.count == 0 {
            return
        }
        
        let variationName = createVariationName(keys: variations)
        var variationTag = Tag(name: "variation")
        variationTag.addParameter(name: "key", value: variationName)
        // Try to find exist variation tag with the same name.
        
        if let found = parentTag.allChildren().filter({($0.name == "variation") && ($0.parameterValue(name: "key") == variationName)}).first {
            variationTag = found
        } else {
            parentTag.add(tag: variationTag)
        }
        
        let originalName = valueObject.originalClassName(context: context)
        if originalName == "_NSLayoutConstraintConstant" {
            parseConstraintVariation(object: valueObject, context: context, variationTag: variationTag, keyPath: keyPath)
        
        } else if originalName == "UIColor" {
            parseColorVariation(object: valueObject, context: context, variationTag: variationTag, keyPath: keyPath)
        
        } else if originalName == "UIFont" {
            parseFontVariation(object: valueObject, context: context, variationTag: variationTag, keyPath: keyPath)
        
        } else if originalName == "NSNumber" {
            parseNumberVariation(object: valueObject, context: context, variationTag: variationTag, keyPath: keyPath)
        
        } else if originalName == "UIImageNibPlaceholder" {
            parseImageVariation(object: valueObject, context: context, variationTag: variationTag, keyPath: keyPath)
        }
    }
    
    
    
    fileprivate func parseConstraintVariation(object: XibObject, context: ParserContext, variationTag: Tag, keyPath: String) {
        
        guard let doubleConstant = object.findDoubleParameter(name: "UINumericConstant", context: context) else {
            return
        }

        variationTag.addParameter(name: "constant", value: "\(doubleConstant)")
    }
    
    fileprivate func parseColorVariation(object: XibObject, context: ParserContext, variationTag: Tag, keyPath: String) {
        
        let colorTag = object.extractColorTag(parentObject: object,
                                              tagName: "color",
                                              parameterName: "",
                                              context: context,
                                              key: keyPath,
                                              keyMapper: nil)
        variationTag.add(tag: colorTag)
    }
    
    fileprivate func parseFontVariation(object: XibObject, context: ParserContext, variationTag: Tag, keyPath: String) {
        
        let fontTag = object.extractFontTag(tagName: "fontDescription", key: "fontDescription", context: context)
        variationTag.add(tag: fontTag)
    }
    
    fileprivate func parseNumberVariation(object: XibObject, context: ParserContext, variationTag: Tag, keyPath: String) {
        
        if let parameter = object.firstStringValue(with: context) {
            variationTag.addParameter(name: keyPath, value: parameter)
        }
    }
    
    fileprivate func parseImageVariation(object: XibObject, context: ParserContext, variationTag: Tag, keyPath: String) {
        
        guard let value = object.findStringParameter(name: "UIResourceName", context: context) else {
            return
        }
        
        context.addImageResource(name: value)
        variationTag.addParameter(name: keyPath, value: value)
    }
    
    
    fileprivate func parseRelationshipStorage(object: XibObject, context: ParserContext) {
        
        guard let viewObject = object.findObjectParameter(name: "UIObject", objectClass: "UIView", context: context) else {
            return
        }
        
        guard let recordsArrayObject = object.findObjectParameter(name: "UIRecords", objectClass: "NSMutableArray", context: context) else {
            return
        }
        
        let recordsArray = recordsArrayObject.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "_UIRelationshipTraitStorageRecord",
                                                            context: context)
        
        for oneRecord in recordsArray {
            parseRelationshipRecord(object: oneRecord, context: context, viewObjectId: viewObject.objectId)
        }
    }
    
    
    fileprivate func parseRelationshipRecord(object: XibObject, context: ParserContext, viewObjectId: String) {
        
        guard let traintCollectionObject = object.findObjectParameter(name: "UITraitCollection",
                                                                      objectClass: "UITraitCollection",
                                                                      context: context) else {
                                                                        return
        }
        
        guard let addedObjects = object.findObjectParameter(name: "UIAddedObjects",
                                                            objectClass: "NSSet",
                                                            context: context) else {
                                                                
                                                                return
        }
        
        guard let removedObjects = object.findObjectParameter(name: "UIRemovedObjects",
                                                              objectClass: "NSSet",
                                                              context: context) else {
                                                                
                                                                return
        }
        
        
        var variations = [String: Int]()
        
        for param in traintCollectionObject.parameters(with: context) {
            
            if let intParam = param as? XibIntParameter {
                
                let name = intParam.name
                variations[name] = intParam.value
            }
        }
        
        if variations.count > 0 {
            
            let variationTag = Tag(name: "variation")
            variationTag.addParameter(name: "key", value: createVariationName(keys: variations))
            let maskTag = Tag(name: "mask")
            maskTag.addParameter(name: "key", value: "constraints")
            variationTag.add(tag: maskTag)
            
            let includedList = addedObjects.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "NSLayoutConstraint", context: context)
            for one in includedList {
                let includeTag = Tag(name: "include")
                includeTag.addParameter(name: "reference", value: one.objectId)
                maskTag.add(tag: includeTag)
            }
            
            let excludedList = removedObjects.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "NSLayoutConstraint",
                                                            context: context)
            for one in excludedList {
                let excludeTag = Tag(name: "exclude")
                excludeTag.addParameter(name: "reference", value: one.objectId)
                maskTag.add(tag: excludeTag)
            }
            
            var tagsArray = context.variations[viewObjectId]
            if tagsArray == nil {
                tagsArray = [Tag]()
            }
            
            tagsArray?.append(variationTag)
            context.variations[viewObjectId] = tagsArray
        }
    }
    
    
    fileprivate func createVariationName(keys: [String: Int]) -> String {
        
        var result: [String] = [String]()
        let sortedKeys = keys.keys.sorted()
        
        
        for key in sortedKeys {
            
            let value = keys[key]
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameDisplayGamut" {
                if value == 0 {
                    result.append("displayGamut=sRGB")
                }
                
                if value == 1 {
                    result.append("displayGamut=P3")
                }
            }
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameHorizontalSizeClass" {
                if value == 1 {
                    result.append("widthClass=compact")
                }
                if value == 2 {
                    result.append("widthClass=regular")
                }
            }
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameVerticalSizeClass" {
                if value == 1 {
                    result.append("heightClass=compact")
                }
                if value == 2 {
                    result.append("heightClass=regular")
                }
            }
        }
        
        
        return result.joined(separator: "-")
    }
}
