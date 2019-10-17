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
        
        let fileFormat = Utils.xibFileFormat(for: fileNameUrl)
        
        guard let decoder = decoderFor(format: fileFormat, url: fileNameUrl) else {
            
            throw CLI.Error(message: "Wrong file format. Input file isn't .nib or .storyboardc")
        }
        
        let result = try decoder.decode()
        
        try result.save(to: outputDirUrl)
    }
}


private extension RestoreCommand {
    
    func decoderFor(format: XibFileFormat, url: URL) -> NibDecoder? {
        
        switch format {
        case .nib:
            
            return NibFileDecoder(url: url)
            
        case .storyboard:
            
            return StoryboardDecoder(url: url)
        
        case .unknown:
            
            return nil
        }
    }
}
