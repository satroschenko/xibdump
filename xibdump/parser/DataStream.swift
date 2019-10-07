//
//  DataStream.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class DataStream: NSObject {
    
    private let data: NSData
    private(set) var dataLength: Int
    
    let littleEndian: Bool
    
    var position: Int
    
    init(with data: NSData, littleEndian: Bool = true) {
        self.data = data
        self.position = 0
        self.dataLength = data.length
        self.littleEndian = littleEndian
        super.init()
    }
    
    func isDataAvailable() -> Bool {
        return self.position < self.dataLength
    }
    
    func readInt32() throws -> Int {
        
        let count = MemoryLayout<UInt32>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var oneValue: UInt32 = 0
        self.data.getBytes(&oneValue, range: NSRange(location: self.position, length: count))
        self.position += count
        
        if littleEndian {
            
            let value = CFSwapInt32LittleToHost(oneValue)
            return Int(value)
            
        } else {
            
            let value = CFSwapInt32BigToHost(oneValue)
            return Int(value)
        }
    }
    
    func readInt16() throws -> Int {
        
        let count = MemoryLayout<UInt16>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var oneValue: UInt16 = 0
        self.data.getBytes(&oneValue, range: NSRange(location: self.position, length: count))
        self.position += count
        
        if littleEndian {
            let value = CFSwapInt16LittleToHost(oneValue)
            return Int(value)
            
        } else {
            
            let value = CFSwapInt16BigToHost(oneValue)
            return Int(value)
        }
    }
    
    func readInt64() throws -> Int {
        
        let count = MemoryLayout<UInt64>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var oneValue: UInt64 = 0
        self.data.getBytes(&oneValue, range: NSRange(location: self.position, length: count))
        self.position += count
        
        if littleEndian {
            let value = CFSwapInt64LittleToHost(oneValue)
            return Int(truncatingIfNeeded: value)
            
        } else {
            let value = CFSwapInt64BigToHost(oneValue)
            return Int(truncatingIfNeeded: value)
        }
    }
    
    func readInt8() throws -> Int {
        let count = MemoryLayout<UInt8>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var oneValue: UInt8 = 0
        self.data.getBytes(&oneValue, range: NSRange(location: self.position, length: count))
        self.position += count
        
        return Int(oneValue)
    }
    
    func readVarInt() throws -> Int {
        
        var result: Int = 0
        var digitIndex: size_t = 0
        
        while self.isDataAvailable() {
            
            let byte = try readInt8()
            let digit = 0x7f & byte
            let isLastDigit: Bool = (0 != (0x80 & byte))
            
            let shiftAmount = 7 * digitIndex
            digitIndex += 1
            
            if shiftAmount < Int(CHAR_BIT) * MemoryLayout<Int>.size {
                
                let validBits = ~0 >> shiftAmount
                let hasInvalidBits = (0 != (~validBits & digit))
                if !hasInvalidBits {
                    result = result | (digit << shiftAmount)
                }
            }
            
            if isLastDigit {
                break
            }
        }
        
        return result
    }
    
    func readFloat() throws -> Float {
        
        let count = MemoryLayout<Float>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var value: UInt32 = 0
        self.data.getBytes(&value, range: NSRange(location: self.position, length: count))
        let intValue = CFSwapInt32(value)
        let floatValue = CFConvertFloatSwappedToHost(CFSwappedFloat32(v: intValue))
        
        self.position += count
        
        return floatValue
    }
    
    func readDouble() throws -> Double {
        
        let count = MemoryLayout<Double>.size
        guard isBytesAvailable(count) else {
            throw DataStreamError.streamEnded
        }
        
        var value: UInt64 = 0
        self.data.getBytes(&value, range: NSRange(location: self.position, length: count))
        let intValue = CFSwapInt64(value)
        let doubleValue = CFConvertDoubleSwappedToHost(CFSwappedFloat64(v: intValue))
        
        self.position += count
        
        return doubleValue
    }
    
    func readString(with length: Int) throws -> String {
        
        guard isBytesAvailable(length) else {
            throw DataStreamError.streamEnded
        }
        
        let mutableData = NSMutableData(length: length)
        let bytes = mutableData?.mutableBytes
        memcpy(bytes, self.data.bytes + self.position, length)
        
        self.position += length
        
        return String(data: mutableData! as Data, encoding: .utf8) ?? ""
    }
    
    func readData(with length: Int) throws -> Data {
        
        guard isBytesAvailable(length) else {
            throw DataStreamError.streamEnded
        }
        
        let mutableData = NSMutableData(length: length)
        let bytes = mutableData?.mutableBytes
        memcpy(bytes, self.data.bytes + self.position, length)
        
        self.position += length
        
        return mutableData! as Data
    }
    
    // MARK: Private methods.
    private func isBytesAvailable(_ count: Int) -> Bool {
        return (self.position + count) <= self.dataLength
    }
}
