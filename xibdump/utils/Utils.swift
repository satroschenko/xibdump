//
//  Utils.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa
import SwiftCLI

class Utils: NSObject {

    
    static func decoderKey(parameterName: String, className: String, isTopLevel: Bool) -> String {
        
        let prefix = isTopLevel ? "T." : "A."
        let suffix = "\(parameterName)-\(className)"
        
        return "\(prefix)\(suffix)"
    }
    
    static func isDirectory(url: URL) throws -> Bool {
    
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        guard exist else {
            throw CLI.Error(message: "Input file doesn't exist")
        }

        return isDir.boolValue
    }
    
    static func xibFileFormat(for url: URL) -> XibFileFormat {
        
        if url.pathExtension == "nib" {

            return .nib
        
        } else if url.pathExtension == "storyboardc" {
            
            return .storyboard
        }
        
        return .unknown
    }
}
