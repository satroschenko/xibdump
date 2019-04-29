//
//  ListParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class ListParameterDecoder: DefaultParameterDecoder {

    let values: [String]
    
    static let contentModes: [String] = [
        "scaleToFill",
        "scaleAspectFit",
        "scaleAspectFill",
        "redraw",
        "center",
        "top",
        "bottom",
        "left",
        "right",
        "topLeft",
        "topRight",
        "bottomLeft",
        "bottomRight"
    ]
    
    static let aligments: [String] = [
        "left",
        "center", //TODO: On Mac: right
        "right", //TODO: On Mac: center
        "justified",
        "natural"
    ]
    
    static let lineBreaks: [String] = [
        "wordWrap",
        "characterWrap",
        "clip",
        "headTruncation",
        "tailTruncation",
        "middleTruncation"
    ]
    
    static let semanticAttributes: [String] = [
        "unspecified",
        "playback",
        "spatial",
        "forceLeftToRight",
        "forceRightToLeft"
    ]
    
    // swiftlint:disable all
    static func all() -> [DefaultParameterDecoder] {
        
        return [
            ListParameterDecoder(parameterName: "UIContentMode", tagName: "contentMode", values: ListParameterDecoder.contentModes),
            ListParameterDecoder(parameterName: "UITextAlignment", tagName: "textAlignment", values: ListParameterDecoder.aligments),
            ListParameterDecoder(parameterName: "UILineBreakMode", tagName: "lineBreakMode", values: ListParameterDecoder.lineBreaks),
            
            ListParameterDecoder(parameterName: "UIViewSemanticContentAttribute",
                                 tagName: "semanticContentAttribute",
                                 values: ListParameterDecoder.semanticAttributes),
            
            ListParameterDecoder(uiParameterName: "UIProgressViewStyle", values: ["default", "bar"]),
            
            ListParameterDecoder(parameterName: "UIActivityIndicatorViewStyle",
                                 tagName: "style",
                                 values: ["whiteLarge", "white", "gray"]),
            
            ListParameterDecoder(uiParameterName: "UIContentVerticalAlignment", values: ["center", "top", "bottom", "fill"]),
            
            ListParameterDecoder(uiParameterName: "UIContentHorizontalAlignment", values: ["center", "left", "right", "fill", "leading", "trailing"]),
            
            ListParameterDecoder(uiParameterName: "UIButtonType", values: ["custom", "roundedRect", "detailDisclosure", "infoLight", "infoDark", "contactAdd"]),
            
            ListParameterDecoder(uiParameterName: "UIBorderStyle", values: ["none", "line", "bezel", "roundedRect"]),
            
            ListParameterDecoder(uiParameterName: "UIClearButtonMode", values: ["0", "whileEditing", "unlessEditing", "always"]),
            
            ListParameterDecoder(parameterName: "UIStackViewAlignment",
                                 tagName: "alignment",
                                 values: ["fill", "top", "firstBaseline", "center", "bottom", "lastBaseline"]),
            
            ListParameterDecoder(parameterName: "UIStackViewDistribution",
                                 tagName: "distribution",
                                 values: ["fill", "fillEqually", "fillProportionally", "equalSpacing", "equalCentering"]),
            
            ListParameterDecoder(parameterName: "UIStackViewAxis",
                                 tagName: "axis",
                                 values: ["horizontal", "vertical"]),
            
            ListParameterDecoder(parameterName: "UIIndicatorStyle",
                                 tagName: "indicatorStyle",
                                 values: ["default", "black", "white"]),
            
            ListParameterDecoder(parameterName: "UIKeyboardDismissMode",
                                 tagName: "keyboardDismissMode",
                                 values: ["default", "onDrag", "interactive"]),
            
            ListParameterDecoder(parameterName: "UIDatePickerMode",
                                 tagName: "datePickerMode",
                                 values: ["time", "date", "dateAndTime", "countDownTimer"]),
            
            ListParameterDecoder(parameterName: "MKMapType",
                                 tagName: "mapType",
                                 values: ["standard", "satellite", "hybrid", "satelliteFlyover", "hybridFlyover", "mutedStandard"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableColorFormatCoderKey",
                                 tagName: "drawableColorFormat",
                                 values: ["RGBA8888", "RGB565", "SRGBA8888"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableDepthFormatCoderKey",
                                 tagName: "drawableDepthFormat",
                                 values: ["none", "16", "24"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableStencilFormatCoderKey",
                                 tagName: "drawableStencilFormat",
                                 values: ["none", "8"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableMultisampleCoderKey",
                                 tagName: "drawableMultisample",
                                 values: ["none", "4X"]),
            
            ListParameterDecoder(uiParameterName: "UIBarStyle", values: ["default", "black", "blackTranslucent"]),
            
            ListParameterDecoder(uiParameterName: "UISearchBarStyle", values: ["default", "prominent", "minimal"]),
            
            ListParameterDecoder(parameterName: "UIBarTranslucence",
                                 tagName: "translucent",
                                 values: ["NO", "YES", "NO"]),
            
            ListParameterDecoder(parameterName: "UILargeTitleDisplayMode",
                                 tagName: "largeTitleDisplayMode",
                                 values: ["automatic", "always", "never"]),
            
            ListParameterDecoder(parameterName: "UITabBarItemPositioning",
                                 tagName: "itemPositioning",
                                 values: ["automatic", "fill", "centered"]),
            
            ListParameterDecoder(uiParameterName: "UISystemItem",
                                 values: ["more", "favorites", "featured", "topRated", "recents", "contacts", "history",
                                          "bookmarks", "search", "downloads", "mostRecent", "mostViewed"]),
            
            ListParameterDecoder(uiParameterName: "UIStyle", values: ["plain", "grouped"]),
            
            ListParameterDecoder(parameterName: "UISeparatorStyle",
                                 tagName: "style",
                                 values: ["none", "", "singleLineEtched"]),
            
            ListParameterDecoder(parameterName: "UITableViewCellStyle",
                                 tagName: "style",
                                 values: ["IBUITableViewCellStyleDefault", "IBUITableViewCellStyleValue1",
                                          "IBUITableViewCellStyleValue2", "IBUITableViewCellStyleSubtitle"]),
            
            ListParameterDecoder(uiParameterName: "UISelectionStyle", values: ["none", "blue", "gray"]),
            
            ListParameterDecoder(uiParameterName: "UIAccessoryType", values: ["", "disclosureIndicator", "detailDisclosureButton", "checkmark", "detailButton"]),
            
            ListParameterDecoder(uiParameterName: "UIEditingAccessoryType", values: ["", "disclosureIndicator", "detailDisclosureButton", "checkmark", "detailButton"]),
            
            ListParameterDecoder(uiParameterName: "UIFocusStyle", values: ["", "custom"]),
            
            ListParameterDecoder(parameterName: "UIScrollViewContentInsetAdjustmentBehavior",
                                 tagName: "contentInsetAdjustmentBehavior",
                                 values: ["", "scrollableAxes", "never", "always"]),
            
            ListParameterDecoder(uiParameterName: "UISectionInsetReference", values: ["", "safeArea", "layoutMargins"]),
            
            ListParameterDecoder(parameterName: "UISwipeGestureRecognizer.direction",
                                 tagName: "direction",
                                 values: ["", "", "left", "right", "up", "", "", "", "down"])
        ]
    }
    // swiftlint:enable all
    
    
    init(parameterName: String, tagName: String, values: [String]) {
        self.values = values
        super.init(parameterName: parameterName, tagName: tagName)
    }
    
    init(uiParameterName: String, values: [String]) {
        self.values = values
        super.init(parameterName: uiParameterName, tagName: uiParameterName.systemParameterName())
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        let number = intParameter.value
        
        if let value = self.values[safe: number], !value.isEmpty {
            let tagParameter = TagParameter(name: tagName, value: value)
            return .parameters([tagParameter], false)
        }
        
        return .empty(false)
    }
}
