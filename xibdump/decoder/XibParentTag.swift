//
//  XibParentTag.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibParentTag: Tag {
    
    let fileFormat: XibFileFormat

    init(fileFormat: XibFileFormat = .nib) {
        self.fileFormat = fileFormat
        super.init(name: "document")
        
        if fileFormat == .storyboard {
            self.addParameter(name: "type", value: "com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB")
        } else {
            self.addParameter(name: "type", value: "com.apple.InterfaceBuilder3.CocoaTouch.XIB")
        }
        self.addParameter(name: "version", value: "3.0")
        self.addParameter(name: "toolsVersion", value: "14460.31")
        self.addParameter(name: "targetRuntime", value: "iOS.CocoaTouch")
        self.addParameter(name: "propertyAccessControl", value: "none")
        self.addParameter(name: "useAutolayout", value: "YES")
        self.addParameter(name: "useTraitCollections", value: "YES")
        self.addParameter(name: "useSafeAreas", value: "YES")
        self.addParameter(name: "colorMatched", value: "YES")
        
        let deviceTag = Tag(name: "device")
        deviceTag.addParameter(name: "id", value: "retina4_7")
        deviceTag.addParameter(name: "orientation", value: "portrait")
        
        let adaptation = Tag(name: "adaptation")
        adaptation.addParameter(name: "id", value: "fullscreen")
        deviceTag.add(tag: adaptation)
        
        self.add(tag: deviceTag)
        
        let dependencies = Tag(name: "dependencies")
        let deployment = Tag(name: "deployment")
        deployment.addParameter(name: "identifier", value: "iOS")
        dependencies.add(tag: deployment)
        
        let plugIn = Tag(name: "plugIn")
        plugIn.addParameter(name: "identifier", value: "com.apple.InterfaceBuilder.IBCocoaTouchPlugin")
        plugIn.addParameter(name: "version", value: "14460.20")
        dependencies.add(tag: plugIn)
        
        let capability1 = Tag(name: "capability")
        capability1.addParameter(name: "name", value: "Safe area layout guides")
        capability1.addParameter(name: "minToolsVersion", value: "9.0")
        dependencies.add(tag: capability1)
        
        let capability2 = Tag(name: "capability")
        capability2.addParameter(name: "name", value: "documents saved in the Xcode 8 format")
        capability2.addParameter(name: "minToolsVersion", value: "8.0")
        dependencies.add(tag: capability2)
        
        self.add(tag: dependencies)
    }
}
