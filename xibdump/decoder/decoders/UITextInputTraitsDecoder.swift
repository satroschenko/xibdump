//
//  UITextInputTraitsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/5/19.
//

import Cocoa

class UITextInputTraitsDecoder: DefaultTagDecoder {
    
    
    static func allDecoders() -> [TagDecoderProtocol] {
        
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
    
    init(parameterName: String, objectClassName: String, tagName: String) {
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName, needAddId: false, tagMapper: nil, keyParameter: nil, keyMapper: nil)
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
        
        tag.addNoYesParameter(object: object, name: "UITextSmartQuotesType", context: context, tagName: "smartQuotesType")
        tag.addNoYesParameter(object: object, name: "UITextSmartInsertDeleteType", context: context, tagName: "smartInsertDeleteType")
        tag.addNoYesParameter(object: object, name: "UITextSmartDashesType", context: context, tagName: "smartDashesType")
        tag.addNoYesParameter(object: object, name: "UIAutocorrectionType", context: context, tagName: "autocorrectionType")
    }
    
}
