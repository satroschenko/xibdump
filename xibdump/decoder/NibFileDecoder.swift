//
//  XibFileDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 10/16/19.
//

import Cocoa
import SwiftCLI


class NibFileDecoderResult: NSObject, NibDecoderResult {
    
    let decoder: XibDecoder
    let fileName: String
    let xibFile: XibFile
    
    
    init(decoder: XibDecoder, fileName: String, xibFile: XibFile) {
        self.decoder = decoder
        self.fileName = fileName
        self.xibFile = xibFile
        super.init()
    }
    
    func save(to url: URL) throws {
        
        let outputFile = url.appendingPathComponent(fileName).appendingPathExtension("nib")
        
        try decoder.save(to: outputFile)        
    }
    
    func nibName() -> String {
        return (fileName as NSString).deletingPathExtension
    }
}



class NibFileDecoder: NSObject {

    let initURL: URL
    
    init(url: URL) {
        
        self.initURL = url
        super.init()
    }
}


extension NibFileDecoder: NibDecoder {
    
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
        
        let decoder = XibDecoder(xibFile: xibFile, onlyNibParsing: true)
        
        decoder.decode()
        
        return NibFileDecoderResult(decoder: decoder, fileName: initURL.lastPathComponent, xibFile: xibFile)
    }
}
