//
//  CustomDecodersHolder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

enum TagDecoderResult {
    
    case beginNewTag(Tag)
    case endNewTag(Tag)
    case childTags([Tag])
    case childParams([TagParameter])
    case empty
}


protocol CustomTagProtocol {
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult
    func handledClassName() -> String
}

class CustomDecodersHolder: NSObject {

    fileprivate var customParsers = [String: CustomTagProtocol]()
    fileprivate var allowedClassNames = [String]()
    
    override init() {
        super.init()
        self.registerSerializers()
        self.registerAllowedClassNames()
    }
    
    fileprivate func registerSerializers() {
        
        self.register(parser: NewTagParser(xibClassName: "UINibTopLevelObjectsKey", tagName: "objects", needAddId: false))
        
//        self.register(parser: NewTagParser(xibClassName: "UIView", tagName: "view"))
//        self.register(parser: NewTagParser(xibClassName: "UILabel", tagName: "label"))
//        self.register(parser: NewTagParser(xibClassName: "UIImageView", tagName: "imageView"))
//        self.register(parser: NewTagParser(xibClassName: "UIButton", tagName: "button"))
//        self.register(parser: NewTagParser(xibClassName: "UISubviews", tagName: "subviews", needAddId: false))
//        self.register(parser: NewTagParser(xibClassName: "UIViewAutolayoutConstraints", tagName: "constraints", needAddId: false))
//
//
//
//        self.register(parsers: DefaultPropertyParser.allParsers())
        
//        self.register(parser: UIBoundsParser())
//        self.register(parser: UIViewControllerParser())
//        self.register(parser: UIColorParser())
//        self.register(parser: UIShadowOffsetParser())
//        self.register(parser: UIFontParser())
//        self.register(parser: UILayoutConstraintParser())
//        self.register(parser: UIAttributeTraitStorageRecordParser())
    }
    
    fileprivate func register(parser: CustomTagProtocol) {
        self.customParsers[parser.handledClassName()] = parser
    }
    
    fileprivate func register(parsers: [CustomTagProtocol]) {
        for one in parsers {
            self.register(parser: one)
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
    
    func parser(by name: String, parameterName: String) -> CustomTagProtocol? {
        
        if let parser = self.customParsers[name] {
            return parser
        }
        
        if parameterName.count > 0 {
            return self.customParsers[parameterName]
        }
        
        return nil
    }
    
    func isClassNameAllowed(name: String) -> Bool {
        return self.allowedClassNames.contains(name)
    }
}
