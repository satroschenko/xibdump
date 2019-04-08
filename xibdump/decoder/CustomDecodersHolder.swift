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
        
        
        // UIKit
        self.register(decoder: NewTagDecoder(uiKitName: "UIView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIWindow"))
        self.register(decoder: NewTagDecoder(uiKitName: "UILabel"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIImageView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIProgressView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIActivityIndicatorView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIPickerView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UISwitch"))
        self.register(decoder: NewTagDecoder(uiKitName: "UISlider"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIButton"))
        self.register(decoder: NewTagDecoder(uiKitName: "UISegmentedControl"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIPageControl"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIStepper"))
        self.register(decoder: NewTagDecoder(uiKitName: "UIStackView"))
        self.register(decoder: NewTagDecoder(uiKitName: "UITextView"))
        
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibTopLevelObjectsKey",
                                             objectClassName: "NSArray",
                                             tagName: "objects",
                                             needAddId: false))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UISegment",
                                             tagName: "segment",
                                             needAddId: false))
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        
        self.register(decoder: NewTagDecoder(parameterName: "UISubviews",
                                             objectClassName: "NSMutableArray",
                                             tagName: "subviews",
                                             needAddId: false,
                                             mapper: ["UISegmentedControl": "segments"]))
        self.register(decoder: PointDecoder(parameterName: "UIViewContentHuggingPriority",
                                            firstName: "horizontalHuggingPriority",
                                            secondName: "verticalHuggingPriority"))
        self.register(decoder: PointDecoder(parameterName: "UIViewContentCompressionResistancePriority",
                                            firstName: "horizontalCompressionResistancePriority",
                                            secondName: "verticalCompressionResistancePriority"))
        
        self.register(decoders: DefaultParameterDecoder.allDecoders())
        self.register(decoders: UIColorDecoder.allDecoders())
        self.register(decoders: ImageDecoder.allDecoders())
        self.register(decoders: SizeTagDecoder.allDecoders())
        self.register(decoders: UITextFieldDecoder.allDecoders())
        
        self.register(decoder: UIBoundsDecoder())
        self.register(decoder: UIRectDecoder())
        self.register(decoder: MarginDecoder())
        self.register(decoder: StateDecoder())
        self.register(decoder: AutoresizingMaskParameterDecoder())
        self.register(decoder: RuntimeAttributesDecoder())
        self.register(decoder: AccessibilitiesDecoder())
        self.register(decoder: ConstraintsDecoder())
        self.register(decoder: ConstraintsVariationsDecoder())
        self.register(decoder: FontDecoder())
//        self.register(parser: UIViewControllerParser())
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
