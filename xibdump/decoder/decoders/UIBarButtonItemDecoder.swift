//
//  UIBarButtonItemDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class UIBarButtonItemDecoder: TagDecoderProtocol {

    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: "UINibEncoderEmptyKey", className: "UIBarButtonItem", isTopLevel: true)]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: object, context: context, key: nil)
        return .tag(tag, false)
    }
}
