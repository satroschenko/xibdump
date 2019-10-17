//
//  Decoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 10/16/19.
//

import Cocoa

protocol NibDecoder {

    func decode() throws -> NibDecoderResult
}

protocol NibDecoderResult {
 
    func save(to url: URL) throws
}
