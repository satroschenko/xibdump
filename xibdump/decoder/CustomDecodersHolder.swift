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
    
    static let uiClassNamesList: [String] = [
        "UIView", "UIWindow", "UILabel", "UIImageView", "UIProgressView", "UIActivityIndicatorView",
        "UIPickerView", "UISwitch", "UISlider", "UIButton", "UISegmentedControl", "UIPageControl",
        "UIStepper", "UIStackView", "UITextView", "UIScrollView", "UIDatePicker", "UIVisualEffectView",
        "MKMapView"
    ]
    
    fileprivate func registerDecoders() {
        
        CustomDecodersHolder.uiClassNamesList.forEach { name in 
            register(decoder: NewTagDecoder(uiKitName: name))
        }
        
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibTopLevelObjectsKey",
                                             objectClassName: "NSArray",
                                             tagName: "objects",
                                             needAddId: false))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UISegment",
                                             tagName: "segment",
                                             needAddId: false))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "MTKView", tagName: "mtkView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "GLKView", tagName: "glkView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "SCNView", tagName: "sceneKitView"))
        
        
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        self.register(decoder: SKViewDecoder())
        
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
        
        self.register(decoder: DataColorDecoder(parameterName: "MTKViewClearColorCoderKey"))
        
        self.register(decoders: DefaultParameterDecoder.allDecoders())
        self.register(decoders: UIColorDecoder.allDecoders())
        self.register(decoders: ImageDecoder.allDecoders())
        self.register(decoders: SizeTagDecoder.allDecoders())
        self.register(decoders: UITextFieldDecoder.allDecoders())
        self.register(decoders: DateDecoder.allDecoders())
        self.register(decoders: VisualEffectDecoder.allDecoders())
        
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
        self.register(decoder: NSLocaleDecoder())
        
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
