//
//  XibParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

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

class XibParameter: NSObject {

    let name: String
    let type: XibParameterType
    var rawData: Data?
    var objectIndex: Int?

    init(name: String, type: XibParameterType) {
        self.name = name
        self.type = type
        super.init()
    }

    func intValue() -> Int? {

        do {
            switch type {
            case .int8:
                return Int(try DataStream(with: self.rawData! as NSData).readInt8())

            case .int16:
                return Int(try DataStream(with: self.rawData! as NSData).readInt16())

            case .int32:
                return Int(try DataStream(with: self.rawData! as NSData).readInt32())

            case .int64:
                return Int(try DataStream(with: self.rawData! as NSData).readInt64())

            default:
                return nil
            }
        } catch {
        }

        return nil
    }

    func floatValue() -> Float? {

        do {
            switch type {
            case .float:
                return try DataStream(with: self.rawData! as NSData).readFloat()

            default:
                return nil
            }
        } catch {
        }

        return nil
    }

    func doubleValue() -> Double? {

        do {
            switch type {
            case .double:
                return try DataStream(with: self.rawData! as NSData).readDouble()

            default:
                return nil
            }
        } catch {
        }

        return nil
    }

    func boolValue() -> Bool? {

        switch type {
        case .aTrue:
            return true

        case .aFalse:
            return false

        default:
            return nil
        }
    }

    func readData(stream: DataStream) throws {

        switch type {

        case .int8:
            self.rawData = try stream.readData(with: MemoryLayout<UInt8>.size)

        case .int16:
            self.rawData = try stream.readData(with: MemoryLayout<UInt16>.size)

        case .int32:
            self.rawData = try stream.readData(with: MemoryLayout<UInt32>.size)

        case .int64:
            self.rawData = try stream.readData(with: MemoryLayout<UInt64>.size)

        case .float:
            self.rawData = try stream.readData(with: MemoryLayout<Float>.size)

        case .double:
            self.rawData = try stream.readData(with: MemoryLayout<Double>.size)

        case .aTrue, .aFalse, .null:
            break

        case .data:
            let dataLength = try stream.readVarInt()
            self.rawData = try stream.readData(with: dataLength)

        case .object:
            self.objectIndex = try stream.readInt32()

        }
    }

    func stringForPrinting() -> String {

        switch type {

        case .int8:
            return "(int8)\(self.name): \(intValue() ?? 0)"

        case .int16:
            return "(int16)\(self.name): \(intValue() ?? 0)"

        case .int32:
            return "(int32)\(self.name): \(intValue() ?? 0)"

        case .int64:
            return "(int64)\(self.name): \(intValue() ?? 0)"

        case .float:
            return "(float)\(self.name): \(floatValue() ?? 0.0)"

        case .double:
            return "(double)\(self.name): \(doubleValue() ?? 0.0)"

        case .aTrue:
            return "(bool)\(self.name): YES"

        case .aFalse:
            return "(bool)\(self.name): NO"

        case .null:
            return "(null)\(self.name)"

        case .data:
            let string = String(data: self.rawData!, encoding: .utf8) ?? ""
            return "(data)\(self.name): \(string)"

        case .object:
            return "(object)\(self.name):"

        }
    }

    func defaultString() -> String? {

        do {

            switch type {

            case .int8:
                return String(try DataStream(with: self.rawData! as NSData).readInt8())

            case .int16:
                return String(try DataStream(with: self.rawData! as NSData).readInt16())

            case .int32:
                return String(try DataStream(with: self.rawData! as NSData).readInt32())

            case .int64:
                return String(try DataStream(with: self.rawData! as NSData).readInt64())

            case .float:
                return String(try DataStream(with: self.rawData! as NSData).readFloat())

            case .double:
                return String(try DataStream(with: self.rawData! as NSData).readDouble())

            case .aTrue:
                return "YES"

            case .aFalse:
                return "NO"

            case .null:
                return "null"

            case .data:
                return String(data: self.rawData!, encoding: .utf8) ?? ""

            case .object:
                return nil

            }
        } catch {

        }

        return nil
    }

}
