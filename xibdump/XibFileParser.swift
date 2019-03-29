//
//  XibFileParser.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class XibFileParser: NSObject {
    
    
    enum XibParameterType: Int {
        case int8 = 0
        case int16 = 1
        case int32 = 2
        case int64 = 3
        case aFalse = 4
        case aTrue = 5
        case float = 6
        case double = 7
        case data = 8
        case null = 9
        case object = 10
    }


    static private let NibFileMagic = "NIBArchive"

    static private let EmptyNibArchive: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Magic number
        0x01, 0x00, 0x00, 0x00, // (?) Major version
        0x09, 0x00, 0x00, 0x00, // (?) Minor version
        0x00, 0x00, 0x00, 0x00, // Object count
        0x32, 0x00, 0x00, 0x00, // Object list file offset
        0x00, 0x00, 0x00, 0x00, // Key count
        0x32, 0x00, 0x00, 0x00, // Key list file offset
        0x00, 0x00, 0x00, 0x00, // Value count
        0x32, 0x00, 0x00, 0x00, // Value list file offset
        0x00, 0x00, 0x00, 0x00, // Class name count
        0x32, 0x00, 0x00, 0x00 // Class name list file offset
    ]

    static let NibArchiveHeaderLength = EmptyNibArchive.count

    func parse(url: URL) throws -> XibFile {

        let data = try Data(contentsOf: url)
        let dataStream = DataStream(with: data as NSData)

        guard dataStream.dataLength >= XibFileParser.NibArchiveHeaderLength else {
            throw DataStreamError.streamTooShort
        }

        let headerString = try dataStream.readString(with: XibFileParser.NibFileMagic.count)
        guard headerString == XibFileParser.NibFileMagic else {
            throw DataStreamError.wrongXibHeader
        }

        let xibFile = XibFile()

        xibFile.majorVersion = try dataStream.readInt32()
        xibFile.minorVersion = try dataStream.readInt32()
        xibFile.objectCount = try dataStream.readInt32()
        xibFile.objectFileOffset = try dataStream.readInt32()
        xibFile.keyCount = try dataStream.readInt32()
        xibFile.keyFileOffset = try dataStream.readInt32()
        xibFile.parametersCount = try dataStream.readInt32()
        xibFile.parametersFileOffset = try dataStream.readInt32()
        xibFile.classNameCount = try dataStream.readInt32()
        xibFile.classNameFileOffset = try dataStream.readInt32()

        guard xibFile.majorVersion == XibArchiveHeaderValues.majorVersion.rawValue else {
            throw DataStreamError.wrongMajorVersion
        }

        guard xibFile.minorVersion == XibArchiveHeaderValues.minorVersion.rawValue else {
            throw DataStreamError.wrongMinorVersion
        }

        xibFile.xibKeys =
            try readKeys(offset: xibFile.keyFileOffset, count: xibFile.keyCount, dataStream: dataStream)
        xibFile.xibClasses =
            try readClasses(offset: xibFile.classNameFileOffset, count: xibFile.classNameCount, dataStream: dataStream)
        xibFile.xibObjects =
            try readObjects(offset: xibFile.objectFileOffset, count: xibFile.objectCount, dataStream: dataStream, classes: xibFile.xibClasses)
        xibFile.xibParameters =
            try readParameters(offset: xibFile.parametersFileOffset, count: xibFile.parametersCount, dataStream: dataStream, keys: xibFile.xibKeys)

        return xibFile

    }

    fileprivate func readKeys(offset: Int, count: Int, dataStream: DataStream) throws -> [String] {

        var keysArray = [String]()

        dataStream.position = offset
        if !dataStream.isDataAvailable() {
            throw DataStreamError.wrongFileFormat
        }

        for _ in 0..<count {

            let length = try dataStream.readVarInt()
            let key = try dataStream.readString(with: length)
            keysArray.append(key)
        }

        return keysArray
    }

    fileprivate func readClasses(offset: Int, count: Int, dataStream: DataStream) throws -> [XibClass] {

        var classesArray = [XibClass]()

        dataStream.position = offset
        if !dataStream.isDataAvailable() {
            throw DataStreamError.wrongFileFormat
        }

        for _ in 0..<count {

            let length = try dataStream.readVarInt()
            var extraCount = try dataStream.readVarInt()

            var values = [Int]()
            while extraCount > 0 {
                let value = try dataStream.readInt32()
                values.append(value)
                extraCount -= 1
            }

            var name = try dataStream.readString(with: length)
            if name.hasSuffix("\0") {
                name = String(name.dropLast())
            }

            let xibClass = XibClass(name: name, extraValues: values)

            classesArray.append(xibClass)
        }

        return classesArray
    }

    fileprivate func readObjects(offset: Int, count: Int, dataStream: DataStream, classes: [XibClass]) throws -> [XibObject] {

        var xibObjects = [XibObject]()

        dataStream.position = offset
        if !dataStream.isDataAvailable() {
            throw DataStreamError.wrongFileFormat
        }

        for _ in 0..<count {

            let nameIndex = try dataStream.readVarInt()
            let valueIndex = try dataStream.readVarInt()
            let valueCount = try dataStream.readVarInt()

            guard let xibClass = classes[safe: nameIndex] else {
                throw DataStreamError.wrongFileFormat
            }

            let xibObject = XibObject(xibClass: xibClass, xibValueIndex: valueIndex, valueCount: valueCount)
            xibObjects.append(xibObject)
        }

        return xibObjects
    }

    fileprivate func readParameters(offset: Int, count: Int, dataStream: DataStream, keys: [String]) throws -> [XibParameterProtocol] {

        var xibParameters = [XibParameterProtocol]()

        dataStream.position = offset
        if !dataStream.isDataAvailable() {
            throw DataStreamError.wrongFileFormat
        }

        for _ in 0..<count {

            if let parameter = try readParameter(keys: keys, dataStream: dataStream) {
                xibParameters.append(parameter)
            }
        }

        return xibParameters
    }
    
    
    
    fileprivate func readParameter(keys: [String], dataStream: DataStream) throws -> XibParameterProtocol? {
        
        let index = try dataStream.readVarInt()
        let type = try dataStream.readInt8()
        
        guard let xibType = XibParameterType.init(rawValue: type) else {
            throw DataStreamError.wrongFileFormat
        }
        
        let name = keys[safe: index] ?? "Unknown"
        
        switch xibType {
        case .int8:
            return try XibIntParameter(name: name, value: dataStream.readInt8())
            
        case .int16:
            return try XibIntParameter(name: name, value: dataStream.readInt16())

        case .int32:
            return try XibIntParameter(name: name, value: dataStream.readInt32())

        case .int64:
            return try XibIntParameter(name: name, value: dataStream.readInt64())

        case .float:
            return try XibFloatParameter(name: name, value: dataStream.readFloat())

        case .double:
            return try XibDoubleParameter(name: name, value: dataStream.readDouble())

        case .aTrue:
            return XibBoolParameter(name: name, value: true)

        case .aFalse:
            return XibBoolParameter(name: name, value: false)

        case .null:
            return XibNullParameter(name: name)

        case .data:
            let dataLength = try dataStream.readVarInt()
            return try XibDataParameter.parameter(with: name, value: dataStream.readData(with: dataLength))

        case .object:
            return try XibObjectParameter(name: name, objectIndex: dataStream.readInt32())
            
        }
    }
}
