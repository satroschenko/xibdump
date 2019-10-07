//
//  DecodeCommand.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa
import SwiftCLI


class RestoreCommand: Command {
    
    let name: String = "restore"
    let shortDescription: String = "Restore structure of compiled .nib or .storyboardc files"
    
    var fileName = Parameter(completion: .filename)
    var outputDir = Parameter(completion: .filename)
    
    func execute() throws {
        
        let outputDirUrl = URL(fileURLWithPath: outputDir.value)
        try FileManager.default.createDirectory(at: outputDirUrl, withIntermediateDirectories: true, attributes: nil)
        
        let fileNameUrl = URL(fileURLWithPath: fileName.value)
        
        let isDir = try isDirectory(url: fileNameUrl)
        
        let (fileFormat, extention) = xibFileFormatInfo(for: fileNameUrl)
        
        let outputFileUrl = outputDirUrl.appendingPathComponent(fileNameUrl.lastPathComponent).appendingPathExtension(extention)
        
        if isDir {
            
            try processDir(dirUrl: fileNameUrl, outputFileUrl: outputFileUrl, fileFormat: fileFormat)
        
        } else {
          
            try processSingleFile(fileUrl: fileNameUrl, outputFileUrl: outputFileUrl)
        }
    }

    fileprivate func processSingleFile(fileUrl: URL, outputFileUrl: URL) throws {

        let parser = XibFileParser()
        let xibFile = try parser.parse(url: URL(fileURLWithPath: fileUrl.path))
        
        let decoder = XibDecoder(xibFile: xibFile)
        decoder.decode()
        
        try decoder.save(to: outputFileUrl)
    }
    
    
    fileprivate func processDir(dirUrl: URL, outputFileUrl: URL, fileFormat: XibFileFormat) throws {
        
        if fileFormat == .nib || fileFormat == .unknown {
            
            var finalFile = dirUrl.appendingPathComponent("objects-11.0+.nib")
            var exist = FileManager.default.fileExists(atPath: finalFile.path, isDirectory: nil)
            if !exist {
                finalFile = dirUrl.appendingPathComponent("runtime.nib")
                
                exist = FileManager.default.fileExists(atPath: finalFile.path, isDirectory: nil)
                if !exist {
                    throw CLI.Error(message: "Wrong file format. Input file isn't .nib")
                }
            }
            
            try processSingleFile(fileUrl: finalFile, outputFileUrl: outputFileUrl)
        
        } else if fileFormat == .storyboard {
            
            let plistURL = dirUrl.appendingPathComponent("Info.plist")
            guard let dict = NSDictionary(contentsOf: plistURL) else {
                throw CLI.Error(message: "Cann't find Info.plist inside .storyboardc")
            }
            
            
            guard let stMap = dict["UIViewControllerIdentifiersToNibNames"] as? [String: String] else {
                throw CLI.Error(message: "Wrong file format. Cann't find 'UIViewControllerIdentifiersToNibNames' key in Info.plist")
            }
        
            let decoder = StoryboardDecoder(initialURL: dirUrl, mapping: stMap)
            try decoder.decode()
            
            try decoder.save(to: outputFileUrl)
        }
    }
}


private extension RestoreCommand {
    
    
    func isDirectory(url: URL) throws -> Bool {
        
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        guard exist else {
            throw CLI.Error(message: "Input file doesn't exist")
        }
        
        return isDir.boolValue
    }
    
    func xibFileFormatInfo(for url: URL) -> (format: XibFileFormat, extention: String) {
        
        if url.pathExtension == "nib" {

            return (format: .nib, extention: "xib")
        
        } else if url.pathExtension == "storyboardc" {
            
            return (format: .storyboard, extention: "storyboard")
        }
        
        return (format: .unknown, extention: "xib")
    }
}
