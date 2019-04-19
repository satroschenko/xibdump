//
//  DecodeCommand.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa
import SwiftCLI


enum XibFileFormat {
    case unknown
    case nib
    case storyboard
}

class RestoreCommand: Command {
    
    let name: String = "restore"
    let shortDescription: String = "Restore structure of compiled .nib or .storyboardc files"
    
    let fileName = Parameter(completion: .filename)
    let outputDir = Parameter(completion: .filename)
    
    func execute() throws {
        
        let outputDirUrl = URL(fileURLWithPath: outputDir.value)
        try FileManager.default.createDirectory(at: outputDirUrl, withIntermediateDirectories: true, attributes: nil)
        
        let fileNameUrl = URL(fileURLWithPath: fileName.value)
        
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: fileNameUrl.path, isDirectory: &isDir)
        guard exist else {
            throw CLI.Error(message: "Input file doesn't exist")
        }
        
        var fileFormat: XibFileFormat = .unknown
        if fileNameUrl.pathExtension == "nib" {
            fileFormat = .nib
        } else if fileNameUrl.pathExtension == "storyboardc" {
            fileFormat = .storyboard
        }
        let outputFileUrl = outputDirUrl.appendingPathComponent(fileNameUrl.lastPathComponent).appendingPathExtension("xib")
        
        if isDir.boolValue {
            
            try processDir(dirUrl: fileNameUrl, outputFileUrl: outputFileUrl, fileFormat: fileFormat)
            
        } else {
            
            try processSingleFile(fileUrl: fileNameUrl, outputFileUrl: outputFileUrl)
        }
    }
    
    
    fileprivate func processSingleFile(fileUrl: URL, outputFileUrl: URL) throws {

        let parser = XibFileParser()
        let xibFile = try parser.parse(url: URL(fileURLWithPath: fileUrl.path))
        
//        let logger = XibLogger(xibFile: xibFile)
//        logger.printDump()

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
            throw CLI.Error(message: "Wrong file format. Input file isn't .nib")
        
        }
    }
}
