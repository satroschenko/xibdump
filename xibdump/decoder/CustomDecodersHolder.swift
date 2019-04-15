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
        "MKMapView", "UIWebView", "UINavigationBar", "UIToolbar", "UITabBar", "UITableView", "UITableViewCell",
        "UICollectionView", "UICollectionViewCell", "UICollectionReusableView", "UITapGestureRecognizer",
        "UIPinchGestureRecognizer", "UIRotationGestureRecognizer", "UISwipeGestureRecognizer", "UIPanGestureRecognizer",
        "UIScreenEdgePanGestureRecognizer", "UIGestureRecognizer"
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
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UITableViewCellContentView",
                                             tagName: "tableViewCellContentView",
                                             needAddId: true,
                                             mapper: nil,
                                             keyParameter: "contentView"))
        
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UITableViewLabel",
                                             tagName: "label"))
        
        self.register(decoder: NewTagDecoder(parameterName: "UICollectionLayout",
                                             objectClassName: "UICollectionViewFlowLayout",
                                             tagName: "collectionViewFlowLayout",
                                             needAddId: true,
                                             mapper: nil,
                                             keyParameter: "collectionViewLayout"))
        
        self.register(decoder: NewTagDecoder(parameterName: "UICollectionLayout",
                                             objectClassName: "UICollectionViewLayout",
                                             tagName: "collectionViewLayout",
                                             needAddId: true,
                                             mapper: nil,
                                             keyParameter: "collectionViewLayout"))
        
        self.register(decoder: NewTagDecoder(parameterName: "UIAttributedText",
                                             objectClassName: "NSMutableAttributedString",
                                             tagName: "attributedString",
                                             needAddId: false,
                                             mapper: nil,
                                             keyParameter: "attributedText"))

        
        
        self.register(decoder: MTKViewDecoder())
        self.register(decoder: UIBarButtonItemDecoder())
        self.register(decoder: UITabbarItemDecoder())
        self.register(decoder: ScreenEdgePanGestureRecognizerDecoder())
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "GLKView", tagName: "glkView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "SCNView", tagName: "sceneKitView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "ARSCNView", tagName: "arscnView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "WKWebView", tagName: "wkWebView"))
        self.register(decoder: NewTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UILongPressGestureRecognizer",
                                             tagName: "pongPressGestureRecognizer")) // WTF
        
        
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        self.register(decoder: OutletsDecoder())
        
        
        self.register(decoder: NewTagDecoder(parameterName: "UISubviews",
                                             objectClassName: "NSMutableArray",
                                             tagName: "subviews",
                                             needAddId: false,
                                             mapper: ["UISegmentedControl": "segments", "UITableViewCell": "", "UICollectionViewCell": ""]))
        
        self.register(decoder: NewTagDecoder(parameterName: "UIItems",
                                             objectClassName: "NSArray",
                                             tagName: "items",
                                             needAddId: false))
        self.register(decoder: NewTagDecoder(parameterName: "UIItems",
                                             objectClassName: "NSMutableArray",
                                             tagName: "items",
                                             needAddId: false))
        
        self.register(decoder: NewTagDecoder(parameterName: "UITapGestureRecognizer._imp", objectClassName: "UITapRecognizer", tagName: ""))
        self.register(decoder: NewTagDecoder(parameterName: "UILongPressGestureRecognizer._imp", objectClassName: "UITapRecognizer", tagName: ""))
        
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
        self.register(decoders: UITextInputTraitsDecoder.allDecoders())
        self.register(decoders: DateDecoder.allDecoders())
        self.register(decoders: VisualEffectDecoder.allDecoders())
        self.register(decoders: SKViewDecoder.allDecoders())
        self.register(decoders: UITextAttributesDecoder.allDecoders())
        self.register(decoders: UINavigationItemDecoder.allDecoders())
        self.register(decoders: PointTagDecoder.allDecoders())
        self.register(decoders: StringArrayDecoder.allDecoders())
        self.register(decoders: UIRectDecoder.allDecoders())
        self.register(decoders: AttributedTextDecoder.allDecoders())
        
        self.register(decoder: UIBoundsDecoder())
        
        self.register(decoder: MarginDecoder())
        self.register(decoder: StateDecoder())
        self.register(decoder: AutoresizingMaskParameterDecoder())
        self.register(decoder: RuntimeAttributesDecoder())
        self.register(decoder: AccessibilitiesDecoder())
        self.register(decoder: ConstraintsDecoder())
        self.register(decoder: ConstraintsVariationsDecoder())
        self.register(decoder: FontDecoder())
        self.register(decoder: NSLocaleDecoder())
        self.register(decoder: WebViewConfigurationDecoder())
        
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
