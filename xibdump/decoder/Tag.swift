//
//  Tag.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class Tag: NSObject {

    let name: String
    var parent: Tag?
    var innerObjectId: String = ""
    var value: String?
    
    private var children = [Tag]()
    private var params = [TagParameter]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func add(tag: Tag) {
        if self != tag {
            tag.parent = self
            self.children.append(tag)
        }
    }
    
    func add(tags: [Tag]) {
        for tag in tags {
            self.add(tag: tag)
        }
    }
    
    func add(parameter: TagParameter) {
        self.params.append(parameter)
    }
    
    func add(parameters: [TagParameter]) {
        self.params.append(contentsOf: parameters)
    }
    
    func addParameter(name: String, value: String) {
        self.add(parameter: TagParameter(name: name, value: value))
    }
    
    func allParameters() -> [TagParameter] {
        return params
    }
    
    func allChildren() -> [Tag] {
        return children
    }
    
    func removeChildren(name: String) {
        children.removeAll(where: {$0.name == name})
    }

    
    func copyTag() -> Tag {
        
        let copy = Tag(name: name)
        copy.parent = parent
        copy.innerObjectId = innerObjectId
        copy.value = value
        
        for child in allChildren() {
            copy.add(tag: child.copyTag())
        }
        
        for parameter in allParameters() {
            copy.addParameter(name: parameter.name, value: parameter.value)
        }
        
        return copy
    }
    
    override var debugDescription: String {
        return "<\(name) id='\(innerObjectId)'>"        
    }
    
    
    // For testing only. Need to remove later.
    func printTag(tabCount: Int) {
        
        if name.count > 0 {
            var string = "\(String(repeating: "\t", count: tabCount))<\(self.name)"
            for param in self.params {
                string += " \"\(param.name)\"=\"\(param.value)\""
            }
            
            if self.children.count > 0 {
                string += ">"
            } else {
                string += "/>"
            }
            
            print(string)
        }
        
        var newTabCount = tabCount
        if name.count > 0 {
            newTabCount += 1
        }
        
        for children in self.children {
            children.printTag(tabCount: newTabCount)
        }
        
        if name.count > 0 && self.children.count > 0 {
            print("\(String(repeating: "\t", count: tabCount))</\(self.name)>")
        }
    }
}


extension String {
    
    static let systemPrefixes: [String] = ["GLK", "AV"]
    
    func xmlParameterName() -> String {
        if self.hasPrefix("UI") || self.hasPrefix("NS") || self.hasPrefix("MK") {
            let res = String(self.dropFirst(2))
            if res.count > 0 {
                return res.lowercasingFirstLetter()
            }
        }
        
        for prefix in String.systemPrefixes {
            if self.hasPrefix(prefix) {
                return prefix.lowercased() + self.dropFirst(prefix.count)
            }
        }
        
        return self
    }
    
    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func lowercasingFirstLetter() {
        self = self.lowercasingFirstLetter()
    }
}
