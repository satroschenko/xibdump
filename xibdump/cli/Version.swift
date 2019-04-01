//
//  Version.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/27/19.
//

import Cocoa

public struct Version {
    
    public static let info = "Command-line application for printing structure of .nib or .storyboardc files."
    
    public let value: String
    public static let current = Version(value: "0.3.0")
}
