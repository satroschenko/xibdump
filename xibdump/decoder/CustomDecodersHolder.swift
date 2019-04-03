//
//  CustomDecodersHolder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

enum TagDecoderResult {
    
    case tag(Tag, Bool)
    case parameters([TagParameter], Bool)
    case empty(Bool)
}


protocol CustomTagDecoderProtocol {
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult
    func handledClassNames() -> [String]
}

class CustomDecodersHolder: NSObject {

    fileprivate var customDecoders = [String: CustomTagDecoderProtocol]()
    fileprivate var allowedClassNames = [String]()
    
    override init() {
        super.init()
        self.registerDecoders()
        self.registerAllowedClassNames()
    }
    
    fileprivate func registerDecoders() {
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibTopLevelObjectsKey",
                                             objectClassName: "NSArray",
                                             tagName: "objects",
                                             needAddId: false))
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UIView",
                                             tagName: "view"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UIClassSwapper",
                                             tagName: "view"))
        self.register(decoder: NewTagDecoder(parameterName: "UISubviews",
                                             objectClassName: "NSMutableArray",
                                             tagName: "subviews"))
        
//        self.register(parser: NewTagParser(xibClassName: "UIView", tagName: "view"))
//        self.register(parser: NewTagParser(xibClassName: "UILabel", tagName: "label"))
//        self.register(parser: NewTagParser(xibClassName: "UIImageView", tagName: "imageView"))
//        self.register(parser: NewTagParser(xibClassName: "UIButton", tagName: "button"))
//        self.register(parser: NewTagParser(xibClassName: "UISubviews", tagName: "subviews", needAddId: false))
//        self.register(parser: NewTagParser(xibClassName: "UIViewAutolayoutConstraints", tagName: "constraints", needAddId: false))
//
//
//
        self.register(decoders: DefaultParameterDecoder.allDecoders())
        
        self.register(decoder: UIBoundsDecoder())
        self.register(decoder: UIRectDecoder())
        self.register(decoder: MarginDecoder())
        self.register(decoder: UIColorDecoder(parameterName: "UIBackgroundColor"))
        self.register(decoder: UIColorDecoder(parameterName: "UITintColor"))
        self.register(decoder: AutoresizingMaskParameterDecoder())
        self.register(decoder: RuntimeAttributesDecoder())
//        self.register(parser: UIViewControllerParser())
//
//        self.register(parser: UIShadowOffsetParser())
//        self.register(parser: UIFontParser())
//        self.register(parser: UILayoutConstraintParser())
//        self.register(parser: UIAttributeTraitStorageRecordParser())
    }
    
    fileprivate func register(decoder: CustomTagDecoderProtocol) {
        
        for key in decoder.handledClassNames() {
            self.customDecoders[key] = decoder
        }
    }
    
    fileprivate func register(decoders: [CustomTagDecoderProtocol]) {
        for one in decoders {
            self.register(decoder: one)
        }
    }
    
    fileprivate func  registerAllowedClassNames() {
        
//        self.allowedClassNames.append("NSArray")
//        self.allowedClassNames.append("NSMutableArray")
//        self.allowedClassNames.append("UIImageNibPlaceholder")
//        self.allowedClassNames.append("_UITraitStorageList")
//        self.allowedClassNames.append("UILayoutGuide")
//        self.allowedClassNames.append("UITraitCollection")
//        self.allowedClassNames.append("_NSLayoutConstraintConstant")
//        self.allowedClassNames.append("_UIAttributeTraitStorageRecord")
        
    }
    
    func parser(by parameter: XibParameterProtocol, context: ParserContext, isTopLevel: Bool) -> CustomTagDecoderProtocol? {
        
        let className = parameter.name
        let objectName = parameter.object(with: context)?.xibClass.name ?? ""
        
        let prefix = isTopLevel ? "T.":"A."
        let suffix = "\(className)-\(objectName)"
        
        return self.customDecoders["\(prefix)\(suffix)"]
    }
    
    func isClassNameAllowed(name: String) -> Bool {
        return self.allowedClassNames.contains(name)
    }
}
