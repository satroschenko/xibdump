//
//  AttributedTextDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/11/19.
//

import Cocoa


struct AttributedIndex {
    let index: Int
    let location: Int
    let length: Int
}


class AttributedTextDecoder: DefaultTagDecoder {

    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            AttributedTextDecoder(parameterName: "UIAttributedText",
                                  objectClassName: "NSMutableAttributedString",
                                  tagName: "attributedString",
                                  needAddId: true,
                                  tagMapper: nil,
                                  keyParameter: "attributedText")
        ]
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let fullText = parentObject.findStringParameter(name: "UIText", context: context) else {
            return .empty(false)
        }
        
        if let attrObject = object.findObjectParameter(name: "NSAttributes", objectClass: "NSMutableArray", context: context) {
            
            return parseAttributesArray(fullText: fullText, object: object, attrObject: attrObject, context: context)
        
        } else if let dictObject = object.findObjectParameter(name: "NSAttributes", objectClass: "NSDictionary", context: context) {
            
            return parseAttributesDict(fullText: fullText, object: object, attrObject: dictObject, context: context)
        }
        
        
        return .empty(false)
    }
    
    
    fileprivate func parseAttributesArray(fullText: String, object: XibObject, attrObject: XibObject, context: ParserContext) -> TagDecoderResult {
        
        guard let attributeInfo = object.findObjectParameter(name: "NSAttributeInfo", objectClass: "NSMutableData", context: context) else {
            return .empty(false)
        }
        
        guard let info = attributeInfo.findDataParameter(name: "NS.bytes", context: context) else {
            return .empty(false)
        }
        
        var rangeList: [AttributedIndex] = [AttributedIndex]()
        
        do {
            
            var startPosition = 0
            let stream = DataStream(with: info as NSData)
            while stream.isDataAvailable() {
                
                let length = try stream.readInt8()
                let index = try stream.readInt8()
                
                let attributedIndex = AttributedIndex(index: index, location: startPosition, length: length)
                startPosition += length
                
                rangeList.append(attributedIndex)
                
            }
        } catch {}
        
        let tag = Tag(name: "attributedString")
        tag.addParameter(name: "key", value: "attributedText")
        
        var fragments: [Tag] = [Tag]()
        
        for fragmentObject in attrObject.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "NSDictionary", context: context) {
            let fragmentTag = parseFragment(parentObject: attrObject, object: fragmentObject, context: context)
            fragments.append(fragmentTag)
        }
        
        if rangeList.count == 0 {
            
            if let fragmentTag = fragments.first {
                let textTag = Tag(name: "string")
                textTag.addParameter(name: "key", value: "content")
                textTag.value = fullText
                fragmentTag.add(tag: textTag)
                tag.add(tag: fragmentTag)
                
                return .tag(tag, false)
            }
            return .empty(false)
        }
        
        for range in rangeList {
            
            if let textTag = textTag(range: range, fullText: fullText), let fragmentTag = fragments[safe: range.index] {
                
                let frTag = fragmentTag.copyTag()
                frTag.add(tag: textTag)
                tag.add(tag: frTag)
            }
        }
        
        return .tag(tag, false)
    }
    
    
    fileprivate func parseAttributesDict(fullText: String, object: XibObject, attrObject: XibObject, context: ParserContext) -> TagDecoderResult {
        
        let tag = Tag(name: "attributedString")
        tag.addParameter(name: "key", value: "attributedText")
        
        let fragmentTag = parseFragment(parentObject: object, object: attrObject, context: context)
        let textTag = Tag(name: "string")
        textTag.addParameter(name: "key", value: "content")
        textTag.value = fullText
        fragmentTag.add(tag: textTag)
        tag.add(tag: fragmentTag)
        
        return .tag(tag, false)
    }
    
    
    fileprivate func parseFragment(parentObject: XibObject, object: XibObject, context: ParserContext) -> Tag {
        
        let fragmentTag = Tag(name: "fragment")
        let tag = Tag(name: "attributes")
        fragmentTag.add(tag: tag)
        
        
        var prevKey: String = ""
        for parameter in object.parameters(with: context) where parameter.name == "UINibEncoderEmptyKey" {
            
            if let pObject = parameter.object(with: context) {
                if pObject.originalClassName(context: context) == "NSString" {
                    prevKey = pObject.firstStringValue(with: context) ?? ""
                }
                
                if pObject.originalClassName(context: context) == "UIColor" {
                    
                    let colorTag = pObject.extractColorTag(parentObject: object,
                                                           tagName: "color",
                                                           parameterName: "",
                                                           context: context,
                                                           key: prevKey)
                    tag.add(tag: colorTag)
                }
                
                if pObject.originalClassName(context: context) == "UIFont" {
                    
                    let fontTag = pObject.extractFontTag(tagName: "font", key: prevKey, context: context)
                    tag.add(tag: fontTag)
                    
                    
                }
                
                if pObject.originalClassName(context: context) == "NSMutableParagraphStyle" || pObject.originalClassName(context: context) == "NSParagraphStyle" {

                    let paragraphTag = extractParagraphTag(object: pObject, tagName: "paragraphStyle", key: prevKey, context: context)
                    tag.add(tag: paragraphTag)
                }
            }
        }
        
        
        return fragmentTag
    }
    
    fileprivate func textTag(range: AttributedIndex, fullText: String) -> Tag? {
        
        let startIndex = fullText.index(fullText.startIndex, offsetBy: range.location)
        let endIndex = fullText.index(fullText.startIndex, offsetBy: range.location + range.length)
        let stringRange = startIndex ..< endIndex
     
        let subString = String(fullText[stringRange])
        if subString.isEmpty {
            return nil
        }
        
        let tag = Tag(name: "string")
        tag.addParameter(name: "key", value: "content")
        tag.value = subString
        
        return tag
    }
    
    
    fileprivate func extractParagraphTag(object: XibObject, tagName: String, key: String, context: ParserContext) -> Tag {
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: key)
        
        fillParameter(object: object, parameterName: "NSLineSpacing", keyName: "lineSpacing", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSParagraphSpacing", keyName: "paragraphSpacing", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSParagraphSpacingBefore", keyName: "paragraphSpacingBefore", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSFirstLineHeadIndent", keyName: "firstLineHeadIndent", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSHeadIndent", keyName: "headIndent", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSTailIndent", keyName: "tailIndent", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSMinLineHeight", keyName: "minimumLineHeight", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSMaxLineHeight", keyName: "maximumLineHeight", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSLineHeightMultiple", keyName: "lineHeightMultiple", context: context, tag: tag)
        fillParameter(object: object, parameterName: "NSHyphenationFactor", keyName: "hyphenationFactor", context: context, tag: tag)
        
        if let aligment = object.findIntParameter(name: "NSAlignment", context: context) {
            let values: [String] = ["left", "right", "center", "justified", "natural"]
            if let value = values[safe: aligment], !values.isEmpty {
                tag.addParameter(name: "alignment", value: value)
            }
        }
        
        if let breakMode = object.findIntParameter(name: "NSLineBreakMode", context: context) {
            let values: [String] = ["", "", "", "", "charWrapping"]
            if let value = values[safe: breakMode], !values.isEmpty {
                tag.addParameter(name: "lineBreakMode", value: value)
            }
        }
        
        if let direction = object.findIntParameter(name: "NSWritingDirection", context: context) {
            let values: [String] = ["natural", "leftToRight", "rightToLeft"]
            if let value = values[safe: direction], !values.isEmpty {
                tag.addParameter(name: "baseWritingDirection", value: value)
            }
        }
        
        return tag
    }
    
    fileprivate func fillParameter(object: XibObject, parameterName: String, keyName: String, context: ParserContext, tag: Tag) {

        if let param = object.parameter(with: parameterName, context: context) {
            tag.addParameter(name: keyName, value: param.stringValue())
        }
    }
    
}
