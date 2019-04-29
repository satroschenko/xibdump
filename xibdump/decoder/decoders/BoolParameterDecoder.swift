//
//  BoolParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class BoolParameterDecoder: DefaultParameterDecoder {

    let inverse: Bool
    
    
    static let uiBoolParametersNamesList: [String] = [
        "UIClearsContextBeforeDrawing", "UIMultipleTouchEnabled", "UIAdjustsFontForContentSizeCategory",
        "UIHidden", "UIAdjustsFontForContentSizeCategory", "UIAdjustsImageSizeForAccessibilityContentSizeCategory",
        "UIViewLayoutMarginsFollowReadableWidth", "UIAnimating", "UIHidesWhenStopped", "UIHighlighted", "UISelected",
        "UIHidesWhenStopped", "UIReversesTitleShadowWhenHighlighted", "UIShowsTouchWhenHighlighted", "UISpringLoaded",
        "UIMomentary", "UIClearsOnBeginEditing", "UIDefersCurrentPageDisplay", "UIWraps", "UIEditable", "UISelectable",
        "UIShowsHorizontalScrollIndicator", "UIShowsVerticalScrollIndicator", "UIPagingEnabled", "UIDirectionalLockEnabled",
        "UIBouncesZoom", "UIAlwaysBounceVertical", "UIAlwaysBounceHorizontal", "UIDelaysContentTouches", "UICanCancelContentTouches",
        "MKZoomEnabled", "MKScrollEnabled", "MKRotateEnabled", "MKShowsBuildings", "MKShowsCompass", "MKShowsTraffic",
        "MKShowsPointsOfInterest", "MKShowsUserLocation", "MKPitchEnabled", "UIScalesPageToFit", "UILeftItemsSupplementBackButton",
        "UIEnabled", "UISpringLoaded", "UIShowsBookmarkButton", "UIShowsCancelButton", "UIShowsScopeBar", "UIAllowsMultipleSelection",
        "UIAllowsSelection", "UIAllowsSelectionDuringEditing", "UIAllowsMultipleSelectionDuringEditing", "UIShowsReorderControl"
        
        
    ]
    
    // swiftlint:disable all
    static func all() -> [TagDecoderProtocol] {
        
        var result = [DefaultParameterDecoder]()
        
        BoolParameterDecoder.uiBoolParametersNamesList.forEach { name in
            result.append(BoolParameterDecoder(uiParameterName: name))
        }
        
        result.append(contentsOf: [
            BoolParameterDecoder(parameterName: "UIAdjustsLetterSpacingToFit", tagName: "adjustsLetterSpacingToFitWidth"),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews"),
            BoolParameterDecoder(parameterName: "UIUserInteractionDisabled",
                                 tagName: "userInteractionEnabled",
                                 inverse: true,
                                 tagMapper: ["UISegment": "enabled"]),
            BoolParameterDecoder(parameterName: "UIViewDoesNotTranslateAutoresizingMaskIntoConstraints",
                                 tagName: "translatesAutoresizingMaskIntoConstraints",
                                 inverse: true),
            BoolParameterDecoder(parameterName: "UIViewPreservesSuperviewMargins", tagName: "preservesSuperviewLayoutMargins"),
            BoolParameterDecoder(parameterName: "UIAutoresizeSubviews", tagName: "autoresizesSubviews"),

            BoolParameterDecoder(parameterName: "UIDisabled", tagName: "enabled", inverse: true),
            BoolParameterDecoder(parameterName: "UISwitchOn", tagName: "on", inverse: true),
            
            BoolParameterDecoder(parameterName: "UIAdjustsFontSizeToFit", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIHideForSinglePage", tagName: "hidesForSinglePage"),
            BoolParameterDecoder(parameterName: "UIStackViewBaselineRelative", tagName: "baselineRelativeArrangement"),
            BoolParameterDecoder(parameterName: "UIBounceEnabled", tagName: "bounces"),
            BoolParameterDecoder(parameterName: "UIScrollDisabled", tagName: "scrollEnabled", inverse: true),
            BoolParameterDecoder(parameterName: "UIDatePickerUseCurrentDateDuringDecoding", tagName: "useCurrentDate"),
            BoolParameterDecoder(parameterName: "UIViewInsetsLayoutMarginsFromSafeArea", tagName: "insetsLayoutMarginsFromSafeArea"),
            BoolParameterDecoder(parameterName: "MKShowsScaleKey", tagName: "showsScale"),
            BoolParameterDecoder(parameterName: "MTKViewEnableSetNeedsDisplayCoderKey", tagName: "enableSetNeedsDisplay"),
            BoolParameterDecoder(parameterName: "MTKViewPausedCoderKey", tagName: "paused"),
            BoolParameterDecoder(parameterName: "MTKViewAutoResizeDrawableCoderKey", tagName: "autoResizeDrawable"),
            BoolParameterDecoder(parameterName: "GLKViewEnableSetNeedsDisplayCoderKey", tagName: "enableSetNeedsDisplay"),
            BoolParameterDecoder(parameterName: "allowsCameraControl", tagName: "allowsCameraControl"),
            BoolParameterDecoder(parameterName: "jitteringEnabled", tagName: "jitteringEnabled"),
            BoolParameterDecoder(parameterName: "ibWantsMultisampling", tagName: "wantsMultisampling"),
            BoolParameterDecoder(parameterName: "autoenablesDefaultLighting", tagName: "autoenablesDefaultLighting"),
            BoolParameterDecoder(parameterName: "playing", tagName: "playing"),
            BoolParameterDecoder(parameterName: "loops", tagName: "loops"),
            
            BoolParameterDecoder(parameterName: "_paused", tagName: "paused"),
            BoolParameterDecoder(parameterName: "_asynchronous", tagName: "asynchronous"),
            BoolParameterDecoder(parameterName: "_allowsTransparency", tagName: "allowsTransparency"),
            BoolParameterDecoder(parameterName: "_ignoresSiblingOrder", tagName: "ignoresSiblingOrder"),
            BoolParameterDecoder(parameterName: "_shouldCullNonVisibleNodes", tagName: "shouldCullNonVisibleNodes"),
            
            BoolParameterDecoder(parameterName: "allowsLinkPreview", tagName: "allowsLinkPreview"),
            BoolParameterDecoder(parameterName: "allowsBackForwardNavigationGestures", tagName: "allowsBackForwardNavigationGestures"),
            BoolParameterDecoder(parameterName: "suppressesIncrementalRendering", tagName: "suppressesIncrementalRendering"),
            BoolParameterDecoder(parameterName: "UIBarPrefersLargeTitles", tagName: "largeTitles"),
            BoolParameterDecoder(parameterName: "UISearchBarTranslucence", tagName: "translucent"),
            BoolParameterDecoder(parameterName: "UIShowSearchResultsButton", tagName: "showsSearchResultsButton"),
            BoolParameterDecoder(parameterName: "UICollectionViewPrefetchingEnabled", tagName: "prefetchingEnabled"),
            
            BoolParameterDecoder(parameterName: "UIGestureRecognizer.delaysTouchesBegan", tagName: "delaysTouchesBegan"),
            BoolParameterDecoder(parameterName: "UIGestureRecognizer.delaysTouchesEnded", tagName: "delaysTouchesEnded"),
            BoolParameterDecoder(parameterName: "UIGestureRecognizer.disabled", tagName: "enabled", inverse: true),
            BoolParameterDecoder(parameterName: "UIGestureRecognizer.cancelsTouchesInView", tagName: "cancelsTouchesInView")
        ])
        // swiftlint:enable all
        
        return result
    }
    
    
    init(parameterName: String, tagName: String, inverse: Bool = false, tagMapper: [String: String]? = nil) {
        self.inverse = inverse
        super.init(parameterName: parameterName, tagName: tagName, tagMapper: tagMapper)
    }
    
    init(uiParameterName: String) {
        self.inverse = false
        super.init(parameterName: uiParameterName, tagName: uiParameterName.systemParameterName(), tagMapper: nil)
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let boolParameter = parameter as? XibBoolParameter else {
            return .empty(false)
        }
        
        
        var value = boolParameter.value
        if self.inverse {
            value  = !value
        }
        
        var finalTagName = tagName
        if let tagMapper = tagMapper {
            let parentClassName = parentObject.originalClassName(context: context)
            if let newTag = tagMapper[parentClassName] {
                finalTagName = newTag
            }
        }
        
        let stringValue = value ? "YES":"NO"
        let tagParameter = TagParameter(name: finalTagName, value: stringValue)
        return .parameters([tagParameter], false)
    }
}
