//
//  BoolParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class BoolParameterDecoder: DefaultParameterDecoder {

    let inverse: Bool
    
    static func all() -> [DefaultParameterDecoder] {
        
        return [
            BoolParameterDecoder(parameterName: "UIClearsContextBeforeDrawing", tagName: "clearsContextBeforeDrawing"),
            BoolParameterDecoder(parameterName: "UIMultipleTouchEnabled", tagName: "multipleTouchEnabled"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontForContentSizeCategory", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAdjustsLetterSpacingToFit", tagName: "adjustsLetterSpacingToFitWidth"),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews"),
            BoolParameterDecoder(parameterName: "UIUserInteractionDisabled",
                                 tagName: "userInteractionEnabled",
                                 inverse: true,
                                 mapper: ["UISegment": "enabled"]),
            BoolParameterDecoder(parameterName: "UIViewDoesNotTranslateAutoresizingMaskIntoConstraints",
                                 tagName: "translatesAutoresizingMaskIntoConstraints",
                                 inverse: true),
            BoolParameterDecoder(parameterName: "UIHidden", tagName: "hidden"),
            BoolParameterDecoder(parameterName: "UIViewLayoutMarginsFollowReadableWidth", tagName: "layoutMarginsFollowReadableWidth"),
            BoolParameterDecoder(parameterName: "UIViewPreservesSuperviewMargins", tagName: "preservesSuperviewLayoutMargins"),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews"),
            BoolParameterDecoder(parameterName: "UIAutoresizeSubviews", tagName: "autoresizesSubviews"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontForContentSizeCategory", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAdjustsImageSizeForAccessibilityContentSizeCategory",
                                 tagName: "adjustsImageSizeForAccessibilityContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAnimating", tagName: "animating"),
            BoolParameterDecoder(parameterName: "UIHidesWhenStopped", tagName: "hidesWhenStopped"),
            BoolParameterDecoder(parameterName: "UIHighlighted", tagName: "highlighted"),
            BoolParameterDecoder(parameterName: "UISelected", tagName: "selected"),
            BoolParameterDecoder(parameterName: "UIHidesWhenStopped", tagName: "hidesWhenStopped"),
            BoolParameterDecoder(parameterName: "UIDisabled", tagName: "enabled", inverse: true),
            BoolParameterDecoder(parameterName: "UISwitchOn", tagName: "on", inverse: true),
            BoolParameterDecoder(parameterName: "UIReversesTitleShadowWhenHighlighted", tagName: "reversesTitleShadowWhenHighlighted"),
            BoolParameterDecoder(parameterName: "UIShowsTouchWhenHighlighted", tagName: "showsTouchWhenHighlighted"),
            BoolParameterDecoder(parameterName: "UIAdjustsImageSizeForAccessibilityContentSizeCategory",
                                 tagName: "adjustsImageSizeForAccessibilityContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UISpringLoaded", tagName: "springLoaded"),
            BoolParameterDecoder(parameterName: "UIMomentary", tagName: "momentary"),
            BoolParameterDecoder(parameterName: "UIClearsOnBeginEditing", tagName: "clearsOnBeginEditing"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontSizeToFit", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIDefersCurrentPageDisplay", tagName: "defersCurrentPageDisplay"),
            BoolParameterDecoder(parameterName: "UIHideForSinglePage", tagName: "hidesForSinglePage"),
            BoolParameterDecoder(parameterName: "UIWraps", tagName: "wraps"),
            BoolParameterDecoder(parameterName: "UIStackViewBaselineRelative", tagName: "baselineRelativeArrangement"),
            BoolParameterDecoder(parameterName: "UIEditable", tagName: "editable"),
            BoolParameterDecoder(parameterName: "UISelectable", tagName: "selectable"),
            BoolParameterDecoder(parameterName: "UIShowsHorizontalScrollIndicator", tagName: "showsHorizontalScrollIndicator"),
            BoolParameterDecoder(parameterName: "UIShowsVerticalScrollIndicator", tagName: "showsVerticalScrollIndicator"),
            BoolParameterDecoder(parameterName: "UIPagingEnabled", tagName: "pagingEnabled"),
            BoolParameterDecoder(parameterName: "UIDirectionalLockEnabled", tagName: "directionalLockEnabled"),
            BoolParameterDecoder(parameterName: "UIBounceEnabled", tagName: "bounces"),
            BoolParameterDecoder(parameterName: "UIBouncesZoom", tagName: "bouncesZoom"),
            BoolParameterDecoder(parameterName: "UIAlwaysBounceVertical", tagName: "alwaysBounceVertical"),
            BoolParameterDecoder(parameterName: "UIAlwaysBounceHorizontal", tagName: "alwaysBounceHorizontal"),
            BoolParameterDecoder(parameterName: "UIDelaysContentTouches", tagName: "delaysContentTouches"),
            BoolParameterDecoder(parameterName: "UICanCancelContentTouches", tagName: "canCancelContentTouches"),
            BoolParameterDecoder(parameterName: "UIScrollDisabled", tagName: "scrollEnabled", inverse: true),
            BoolParameterDecoder(parameterName: "UIDatePickerUseCurrentDateDuringDecoding", tagName: "useCurrentDate"),
            BoolParameterDecoder(parameterName: "UIViewInsetsLayoutMarginsFromSafeArea", tagName: "insetsLayoutMarginsFromSafeArea"),
            BoolParameterDecoder(parameterName: "MKZoomEnabled", tagName: "zoomEnabled"),
            BoolParameterDecoder(parameterName: "MKScrollEnabled", tagName: "scrollEnabled"),
            BoolParameterDecoder(parameterName: "MKRotateEnabled", tagName: "rotateEnabled"),
            BoolParameterDecoder(parameterName: "MKShowsBuildings", tagName: "showsBuildings"),
            BoolParameterDecoder(parameterName: "MKShowsCompass", tagName: "showsCompass"),
            BoolParameterDecoder(parameterName: "MKShowsScaleKey", tagName: "showsScale"),
            BoolParameterDecoder(parameterName: "MKShowsTraffic", tagName: "showsTraffic"),
            BoolParameterDecoder(parameterName: "MKShowsPointsOfInterest", tagName: "showsPointsOfInterest"),
            BoolParameterDecoder(parameterName: "MKShowsUserLocation", tagName: "showsUserLocation"),
            BoolParameterDecoder(parameterName: "MKPitchEnabled", tagName: "pitchEnabled"),
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
            
            BoolParameterDecoder(parameterName: "UIScalesPageToFit", tagName: "scalesPageToFit"),
            BoolParameterDecoder(parameterName: "allowsLinkPreview", tagName: "allowsLinkPreview"),
            BoolParameterDecoder(parameterName: "allowsBackForwardNavigationGestures", tagName: "allowsBackForwardNavigationGestures"),
            BoolParameterDecoder(parameterName: "suppressesIncrementalRendering", tagName: "suppressesIncrementalRendering"),
            BoolParameterDecoder(parameterName: "UIBarPrefersLargeTitles", tagName: "largeTitles"),
            BoolParameterDecoder(parameterName: "UILeftItemsSupplementBackButton", tagName: "leftItemsSupplementBackButton"),
            BoolParameterDecoder(parameterName: "UIEnabled", tagName: "enabled"),
            BoolParameterDecoder(parameterName: "UISpringLoaded", tagName: "springLoaded"),
            BoolParameterDecoder(parameterName: "UISearchBarTranslucence", tagName: "translucent"),
            BoolParameterDecoder(parameterName: "UIShowSearchResultsButton", tagName: "showsSearchResultsButton"),
            BoolParameterDecoder(parameterName: "UIShowsBookmarkButton", tagName: "showsBookmarkButton"),
            BoolParameterDecoder(parameterName: "UIShowsCancelButton", tagName: "showsCancelButton"),
            BoolParameterDecoder(parameterName: "UIShowsScopeBar", tagName: "showsScopeBar"),
            BoolParameterDecoder(parameterName: "UIAllowsMultipleSelection", tagName: "allowsMultipleSelection"),
            BoolParameterDecoder(parameterName: "UIAllowsSelection", tagName: "allowsSelection"),
            BoolParameterDecoder(parameterName: "UIAllowsSelectionDuringEditing", tagName: "allowsSelectionDuringEditing"),
            BoolParameterDecoder(parameterName: "UIAllowsMultipleSelectionDuringEditing", tagName: "allowsMultipleSelectionDuringEditing")
            
            
        ]
    }
    
    
    init(parameterName: String, tagName: String, inverse: Bool = false, mapper: [String: String]? = nil) {
        self.inverse = inverse
        super.init(parameterName: parameterName, tagName: tagName, mapper: mapper)
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
        if let mapper = mapper {
            let parentClassName = parentObject.originalClassName(context: context)
            if let newTag = mapper[parentClassName] {
                finalTagName = newTag
            }
        }
        
        let stringValue = value ? "YES":"NO"
        let tagParameter = TagParameter(name: finalTagName, value: stringValue)
        return .parameters([tagParameter], false)
    }
}
