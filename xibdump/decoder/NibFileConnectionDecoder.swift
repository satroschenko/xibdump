//
//  NibFileConnectionDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 10/17/19.
//

import Cocoa
import SwiftCLI

class NibFileConnectionDecoderResult: NSObject, NibDecoderResult {
    
    let xibFile: XibFile
    let fileName: String
    
    init(xibFile: XibFile, fileName: String) {
        self.xibFile = xibFile
        self.fileName = fileName
        super.init()
    }
    
    func save(to url: URL) throws {
    }
}

class NibFileConnectionDecoder: NSObject {

    let initURL: URL
    let onlyNibParsing: Bool
    
    init(url: URL, onlyNibParsing: Bool = true) {
        
        self.initURL = url
        self.onlyNibParsing = onlyNibParsing
        super.init()
    }
}

extension NibFileConnectionDecoder: NibDecoder {
    
    func decode() throws -> NibDecoderResult {
        
        var finalFile = initURL.appendingPathComponent("objects-11.0+.nib")
        var exist = FileManager.default.fileExists(atPath: finalFile.path, isDirectory: nil)
        if !exist {
            finalFile = initURL.appendingPathComponent("runtime.nib")
            
            exist = FileManager.default.fileExists(atPath: finalFile.path, isDirectory: nil)
            if !exist {
                throw CLI.Error(message: "Wrong file format. Input file isn't .nib")
            }
        }
        
        let parser = XibFileParser()
        let xibFile = try parser.parse(url: URL(fileURLWithPath: finalFile.path))
        
//        print("=== CONNECTION: \(initURL.lastPathComponent) ===\n")
//        let logger = XibLogger(xibFile: xibFile)
//        logger.printDump()
//        print("\n\n\n")
        
        
        return NibFileConnectionDecoderResult(xibFile: xibFile, fileName: initURL.lastPathComponent)
    }
    
}
