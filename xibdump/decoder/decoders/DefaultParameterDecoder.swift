//
//  DefaultPropertyDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class DefaultParameterDecoder: NSObject, TagDecoderProtocol {

    let parameterName: String
    let tagName: String
    let tagMapper: [String: String]?
    var topLevelDecoder: Bool = true
    
    static let uiParametersNamesList: [String] = [
        "UIOpaque", "UIPreferredMaxLayoutWidth", "UIMinimumScaleFactor", "UINumberOfLines", "UITag", "UIAlpha",
        "UIMinimumFontSize", "UIProgress", "UIValue", "UIMinValue", "UIMaxValue", "UISelectedSegmentIndex",
        "UINumberOfPages", "UICurrentPage", "UIMinimumValue", "UIMaximumValue", "UIStepValue", "UIMaximumZoomScale",
        "UIMinimumZoomScale", "UIMinuteInterval", "UICountDownDuration", "UISectionIndexMinimumDisplayRowCount",
        "UIEstimatedRowHeight", "UIRowHeight", "UISectionHeaderHeight", "UIEstimatedSectionHeaderHeight",
        "UISectionFooterHeight", "UIEstimatedSectionFooterHeight", "UIIndentationLevel", "UIIndentationWidth"
    ]
    
    static func allDecoders() -> [TagDecoderProtocol] {
        
        var result = [TagDecoderProtocol]()
        
        DefaultParameterDecoder.uiParametersNamesList.forEach { name in
            result.append(DefaultParameterDecoder(uiKitName: name))
        }
        
        result.append(contentsOf: [

            DefaultParameterDecoder(parameterName: "UIStackViewSpacing", tagName: "spacing"),
            DefaultParameterDecoder(parameterName: "MTKViewClearDepthCoderKey", tagName: "clearDepth"),
            DefaultParameterDecoder(parameterName: "MTKViewClearStencilCoderKey", tagName: "clearStencil"),
            DefaultParameterDecoder(parameterName: "MTKViewSampleCountCoderKey", tagName: "sampleCount"),
            DefaultParameterDecoder(parameterName: "MTKViewPreferredFramesPerSecondCoderKey", tagName: "preferredFramesPerSecond"),
            DefaultParameterDecoder(parameterName: "ibPreferredRenderingAPI", tagName: "preferredRenderingAPI"),
            DefaultParameterDecoder(parameterName: "_preferredFramesPerSecond", tagName: "preferredFramesPerSecond"),
            DefaultParameterDecoder(parameterName: "UITabBarItemWidth", tagName: "itemWidth"),
            DefaultParameterDecoder(parameterName: "UITabBarItemSpacing", tagName: "itemSpacing"),
            DefaultParameterDecoder(parameterName: "UIInsetsContentViewsToSafeArea", tagName: "contentViewInsetsToSafeArea"),
            DefaultParameterDecoder(parameterName: "UILineSpacing", tagName: "minimumLineSpacing"),
            DefaultParameterDecoder(parameterName: "UIInteritemSpacing", tagName: "minimumInteritemSpacing"),
            
            DefaultParameterDecoder(parameterName: "UITapRecognizer.numberOfTapsRequired", tagName: "numberOfTapsRequired"),
            DefaultParameterDecoder(parameterName: "UITapRecognizer.numberOfTouchesRequired", tagName: "numberOfTouchesRequired"),
            DefaultParameterDecoder(parameterName: "UISwipeGestureRecognizer.numberOfTouchesRequired", tagName: "numberOfTouchesRequired"),
            DefaultParameterDecoder(parameterName: "UIPanGestureRecognizer.maximumNumberOfTouches", tagName: "maximumNumberOfTouches"),
            DefaultParameterDecoder(parameterName: "UIPanGestureRecognizer.minimumNumberOfTouches", tagName: "minimumNumberOfTouches"),
            DefaultParameterDecoder(parameterName: "UILongPressGestureRecognizer.minimumPressDuration", tagName: "minimumPressDuration"),
            DefaultParameterDecoder(parameterName: "UILongPressGestureRecognizer.allowableMovement", tagName: "allowableMovement")
                        
            ])
        
        result.append(contentsOf: ListParameterDecoder.all())
        result.append(contentsOf: BoolParameterDecoder.all())
        result.append(contentsOf: FirstStringDecoder.all())
        
        return result
    }
    
    
    init(parameterName: String, tagName: String, tagMapper: [String: String]? = nil) {
        self.parameterName = parameterName
        self.tagName = tagName
        self.tagMapper = tagMapper
        super.init()
    }
    
    convenience init(uiKitName: String) {
        self.init(parameterName: uiKitName, tagName: uiKitName.systemParameterName(), tagMapper: nil)
    }
    
    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: parameterName, className: "", isTopLevel: topLevelDecoder)]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        if parameter.name == parameterName {
            let parameterValue = parameter.stringValue()
            
            var finalTagName = tagName
            if let tagMapper = tagMapper {
                let parentClassName = parentObject.originalClassName(context: context)
                if let newTag = tagMapper[parentClassName] {
                    finalTagName = newTag
                }
            }
            
            let tagParameter = TagParameter(name: finalTagName, value: parameterValue)
            return .parameters([tagParameter], false)
        }
        
        return .empty(false)
    }
}
