//
//  FirstStringDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/2/19.
//

import Cocoa

class FirstStringDecoder: DefaultParameterDecoder {

    static func all() -> [DefaultParameterDecoder] {
        
        return [
            FirstStringDecoder(parameterName: "UIText", tagName: "text"),
            FirstStringDecoder(parameterName: "UIResourceName", tagName: "image"),
            FirstStringDecoder(parameterName: "UIRestorationIdentifier", tagName: "restorationIdentifier"),
            FirstStringDecoder(parameterName: "UIClassName", tagName: "customClass"),
            FirstStringDecoder(parameterName: "UITitle", tagName: "title"),
            FirstStringDecoder(parameterName: "UISegmentInfo", tagName: "title"),
            FirstStringDecoder(parameterName: "UIPlaceholder", tagName: "placeholder"),
            FirstStringDecoder(parameterName: "ibSceneName", tagName: "sceneName"),
            FirstStringDecoder(parameterName: "customUserAgent", tagName: "customUserAgent"),
            FirstStringDecoder(parameterName: "UIPrompt", tagName: "prompt"),
            FirstStringDecoder(parameterName: "UIBadgeValue", tagName: "badgeValue"),
            FirstStringDecoder(parameterName: "UIReuseIdentifier", tagName: "reuseIdentifier"),
            FirstStringDecoder(parameterName: "UITableSectionHeaderTitle", tagName: "headerTitle"),
            FirstStringDecoder(parameterName: "UITableSectionFooterTitle", tagName: "footerTitle")
            
        ]
    }
    
    override func handledClassNames() -> [String] {
        return [
            Utils.decoderKey(parameterName: parameterName, className: "NSString", isTopLevel: topLevelDecoder),
            Utils.decoderKey(parameterName: parameterName, className: "NSMutableString", isTopLevel: topLevelDecoder),
            Utils.decoderKey(parameterName: parameterName, className: "NSLocalizableString", isTopLevel: topLevelDecoder)
        ]
    }
    
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {

        if let object = parameter.object(with: context), let value = object.firstStringValue(with: context) {
            return .parameters([TagParameter(name: tagName, value: value)], false)
        }
        
        return .empty(false)
    }
}
