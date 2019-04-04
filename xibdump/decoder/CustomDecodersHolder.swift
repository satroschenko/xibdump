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
    case tags([Tag])
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
    }
    
    fileprivate func registerDecoders() {
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibTopLevelObjectsKey",
                                             objectClassName: "NSArray",
                                             tagName: "objects",
                                             needAddId: false))
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        self.register(decoder: SizeTagDecoder(parameterName: "UIShadowOffset",
                                              objectClassName: "",
                                              tagName: "size",
                                              needAddId: false) )
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UIView",
                                             tagName: "view"))
        self.register(decoder: NewTagDecoder(parameterName: "UISubviews",
                                             objectClassName: "NSMutableArray",
                                             tagName: "subviews"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UILabel",
                                             tagName: "label"))
        self.register(decoder: PointDecoder(parameterName: "UIViewContentHuggingPriority",
                                            firstName: "horizontalHuggingPriority",
                                            secondName: "verticalHuggingPriority"))
        self.register(decoder: PointDecoder(parameterName: "UIViewContentCompressionResistancePriority",
                                            firstName: "horizontalCompressionResistancePriority",
                                            secondName: "verticalCompressionResistancePriority"))
        
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
        self.register(decoder: UIColorDecoder(parameterName: "UITextColor"))
        self.register(decoder: UIColorDecoder(parameterName: "UIHighlightedColor"))
        self.register(decoder: UIColorDecoder(parameterName: "UIShadowColor"))
        self.register(decoder: AutoresizingMaskParameterDecoder())
        self.register(decoder: RuntimeAttributesDecoder())
        self.register(decoder: AccessibilitiesDecoder())
        self.register(decoder: ConstraintsDecoder())
        self.register(decoder: ConstraintsVariationsDecoder())
        self.register(decoder: FontDecoder())
//        self.register(parser: UIViewControllerParser())
//
//        self.register(parser: UIShadowOffsetParser())
//        self.register(parser: UIFontParser())
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
    
    func parser(by parameter: XibParameterProtocol, context: ParserContext, isTopLevel: Bool) -> CustomTagDecoderProtocol? {
        
        return self.customDecoders[createDecoderKey(parameter: parameter, context: context, isTopLevel: isTopLevel)]
    }
    
    
    func createDecoderKey(parameter: XibParameterProtocol, context: ParserContext, isTopLevel: Bool) -> String {
        
        let parameterName = parameter.name
        var className = ""
        if let object = parameter.object(with: context) {
            className = object.originalClassName(context: context)
        }
        
        let prefix = isTopLevel ? "T.":"A."
        let suffix = "\(parameterName)-\(className)"
        
        return "\(prefix)\(suffix)"
    }
}
