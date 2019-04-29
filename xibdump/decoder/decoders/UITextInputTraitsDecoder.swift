//
//  UITextInputTraitsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/5/19.
//

import Cocoa

class UITextInputTraitsDecoder: NewTagDecoder {
    
    
    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            UITextInputTraitsDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "UITextField", tagName: "textField"),
            UITextInputTraitsDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "UITextView", tagName: "textView"),
            UITextInputTraitsDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "UISearchBar", tagName: "searchBar"),
            DataDetectorTypesDecoder()
        ]
    }
    
    
    let returnKeyTypes: [String] = ["", "go", "google", "join", "next", "route", "search", "send", "yahoo", "done", "emergencyCall", "continue"]
    
    let keyboardTypes: [String] = ["", "alphabet", "numbersAndPunctuation", "URL", "numberPad", "phonePad",
                                   "namePhonePad", "emailAddress", "decimalPad", "twitter", "webSearch", "ASCIICapableNumberPad"]
    
    let keyboardLooks: [String] = ["", "alert", "light"]
    let noYesTypes: [String] = ["", "no", "yes"]
    let autoCapitalizationTypes: [String] = ["none", "words", "sentences", "allCharacters"]

    init() {
        super.init(parameterName: "UINibEncoderEmptyKey", objectClassName: "UITextField", tagName: "textField")
    }
    
    override init(parameterName: String, objectClassName: String, tagName: String, needAddId: Bool = true, mapper: [String: String]? = nil, keyParameter: String? = nil) {
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName, needAddId: needAddId, mapper: mapper, keyParameter: keyParameter)
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        
        if case let .tag(tag, _)  = result {
            
            let traitsTag = Tag(name: "textInputTraits")
            traitsTag.addParameter(name: "key", value: "textInputTraits")
            tag.add(tag: traitsTag)
            
            parseTraits(parentObject: parentObject, parameter: parameter, context: context, tag: traitsTag)
        }
        
        return result
    }
    
    
    fileprivate func parseTraits(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext, tag: Tag) {
        
        guard let object = parameter.object(with: context) else {
            return
        }
        
        if let contentType = object.findStringParameter(name: "UITextContentType", context: context) {
            tag.addParameter(name: "textContentType", value: contentType)
        }
        
        if let secure = object.findBoolParameter(name: "UISecureTextEntry", context: context) {
            tag.addParameter(name: "secureTextEntry", value: secure ? "YES" : "NO")
        }
        
        if let retKey = object.findBoolParameter(name: "UIEnablesReturnKeyAutomatically", context: context) {
            tag.addParameter(name: "enablesReturnKeyAutomatically", value: retKey ? "YES" : "NO")
        }
        
        if let retKeyType = object.findIntParameter(name: "UIReturnKeyType", context: context) {
            
            let name = returnKeyTypes[safe: retKeyType] ?? ""
            tag.addParameter(name: "returnKeyType", value: name)
        }
        
        if let keyboardType = object.findIntParameter(name: "UIKeyboardType", context: context) {
            
            let name = keyboardTypes[safe: keyboardType] ?? ""
            tag.addParameter(name: "keyboardType", value: name)
        }
        
        if let look = object.findIntParameter(name: "UIKeyboardAppearance", context: context) {
            
            let name = keyboardLooks[safe: look] ?? ""
            tag.addParameter(name: "keyboardAppearance", value: name)
        }
        
        if let autoCap = object.findIntParameter(name: "UIAutocapitalizationType", context: context) {
            
            let name = autoCapitalizationTypes[safe: autoCap] ?? ""
            tag.addParameter(name: "autocapitalizationType", value: name)
        }
        
        addNoYesTag(object: object, name: "UITextSmartQuotesType", context: context, tagName: "smartQuotesType", tag: tag)
        addNoYesTag(object: object, name: "UITextSmartInsertDeleteType", context: context, tagName: "smartInsertDeleteType", tag: tag)
        addNoYesTag(object: object, name: "UITextSmartDashesType", context: context, tagName: "smartDashesType", tag: tag)
        addNoYesTag(object: object, name: "UIAutocorrectionType", context: context, tagName: "autocorrectionType", tag: tag)
    }
    
    
    fileprivate func addNoYesTag(object: XibObject, name: String, context: ParserContext, tagName: String, tag: Tag) {
        
        if let value = object.findIntParameter(name: name, context: context) {
            
            let name = noYesTypes[safe: value] ?? ""
            tag.addParameter(name: tagName, value: name)
        }
    }
}
