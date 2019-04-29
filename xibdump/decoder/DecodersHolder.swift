//
//  DecodersHolder.swift
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


protocol TagDecoderProtocol {
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult
    func handledClassNames() -> [String]
}

class DecodersHolder: NSObject {

    fileprivate var customDecoders = [String: TagDecoderProtocol]()
    
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
        "UIScreenEdgePanGestureRecognizer", "UIGestureRecognizer", "UIViewController", "UITableViewController",
        "UITableViewSection", "UITableViewDataSource", "AVPlayerViewController"
    ]
    
    // swiftlint:disable all
    fileprivate func registerDecoders() {
        
        DecodersHolder.uiClassNamesList.forEach { name in 
            register(decoder: DefaultTagDecoder(uiKitName: name))
        }
        
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibTopLevelObjectsKey",
                                             objectClassName: "NSArray",
                                             tagName: "objects",
                                             needAddId: false))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UISegment",
                                             tagName: "segment",
                                             needAddId: false))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UITableViewCellContentView",
                                             tagName: "tableViewCellContentView",
                                             needAddId: true,
                                             tagMapper: nil,
                                             keyParameter: "contentView"))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UITableViewLabel",
                                             tagName: "label"))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UIView",
                                             objectClassName: "UIView",
                                             tagName: "view"))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UICollectionLayout",
                                             objectClassName: "UICollectionViewFlowLayout",
                                             tagName: "collectionViewFlowLayout",
                                             needAddId: true,
                                             tagMapper: nil,
                                             keyParameter: "collectionViewLayout"))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UICollectionLayout",
                                             objectClassName: "UICollectionViewLayout",
                                             tagName: "collectionViewLayout",
                                             needAddId: true,
                                             tagMapper: nil,
                                             keyParameter: "collectionViewLayout"))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UIAttributedText",
                                             objectClassName: "NSMutableAttributedString",
                                             tagName: "attributedString",
                                             needAddId: false,
                                             tagMapper: nil,
                                             keyParameter: "attributedText"))

        self.register(decoder: DefaultTagDecoder(parameterName: "UITableSections",
                                             objectClassName: "NSArray",
                                             tagName: "sections",
                                             needAddId: false))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UITableSectionRows",
                                             objectClassName: "NSArray",
                                             tagName: "cells",
                                             needAddId: false))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UITableRowCell",
                                             objectClassName: "UITableViewCell",
                                             tagName: "tableViewCell"))
        
        
        self.register(decoder: MTKViewDecoder())
        self.register(decoder: UIBarButtonItemDecoder())
        self.register(decoder: UITabbarItemDecoder())
        self.register(decoder: ScreenEdgePanGestureRecognizerDecoder())
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "GLKView", tagName: "glkView"))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "SCNView", tagName: "sceneKitView"))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "ARSCNView", tagName: "arscnView"))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "WKWebView", tagName: "wkWebView"))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey",
                                             objectClassName: "UILongPressGestureRecognizer",
                                             tagName: "pongPressGestureRecognizer")) // WTF
        
        
        self.register(decoder: ProxyObjectDecoder())
        self.register(decoder: PlaceholderDecoder())
        self.register(decoder: OutletsDecoder())
        
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UISubviews",
                                             objectClassName: "NSMutableArray",
                                             tagName: "subviews",
                                             needAddId: false,
                                             tagMapper: ["UISegmentedControl": "segments", "UITableViewCell": "", "UICollectionViewCell": ""]))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UIItems",
                                             objectClassName: "NSArray",
                                             tagName: "items",
                                             needAddId: false))
        self.register(decoder: DefaultTagDecoder(parameterName: "UIItems",
                                             objectClassName: "NSMutableArray",
                                             tagName: "items",
                                             needAddId: false))
        
        self.register(decoder: DefaultTagDecoder(parameterName: "UITapGestureRecognizer._imp", objectClassName: "UITapRecognizer", tagName: ""))
        self.register(decoder: DefaultTagDecoder(parameterName: "UILongPressGestureRecognizer._imp", objectClassName: "UITapRecognizer", tagName: ""))
        self.register(decoder: DefaultTagDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "UITableViewRow", tagName: ""))
        
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
        
    }
    // swiftlint:enable all
    
    fileprivate func register(decoder: TagDecoderProtocol) {
        
        for key in decoder.handledClassNames() {
            self.customDecoders[key] = decoder
        }
    }
    
    fileprivate func register(decoders: [TagDecoderProtocol]) {
        for one in decoders {
            self.register(decoder: one)
        }
    }
    
    func parser(by parameter: XibParameterProtocol, context: ParserContext, isTopLevel: Bool) -> TagDecoderProtocol? {
        return self.customDecoders[createDecoderKey(parameter: parameter, context: context, isTopLevel: isTopLevel)]
    }
    
    
    func createDecoderKey(parameter: XibParameterProtocol, context: ParserContext, isTopLevel: Bool) -> String {
        
        let parameterName = parameter.name
        var className = ""
        if let object = parameter.object(with: context) {
            className = object.originalClassName(context: context)
        }
        
        return Utils.decoderKey(parameterName: parameterName, className: className, isTopLevel: isTopLevel)
    }
}
