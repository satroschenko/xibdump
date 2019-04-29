//
//  UIBarButtonItemDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class UIBarButtonItemDecoder: CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        return ["T.UINibEncoderEmptyKey-UIBarButtonItem"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: object, context: context, key: nil)
        return .tag(tag, false)
    }
}
