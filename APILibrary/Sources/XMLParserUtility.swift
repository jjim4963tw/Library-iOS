//
//  XMLParserUtility.swift
//  Storage
//
//  Created by Miles Keng on 2022/7/6.
//  Copyright © 2022 asuscloud. All rights reserved.
//

import Foundation

public class XMLParserUtility {
    
    fileprivate let root = Element(name: "data")
    
    public convenience init?(fromString: String) {
        guard let data = fromString.data(using: .utf8) else {
            return nil
        }
        self.init(fromData: data)
    }
    
    public init(fromData: Data) {
        let parser = XMLParser(data: fromData)
        let delegate = XMLParserUtilDelegate(root)
        parser.delegate = delegate
        parser.parse()
    }
    
    func getJson() -> String? {
        let dic = getDictionary()
        
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: []){
            return String(data: data, encoding: String.Encoding.utf8)
        } else {
            return nil
        }
    }
    
    func getDictionary() -> [String: Any]{
        return parseElement(element: root)
    }
    
    private func parseElement(element: Element) -> [String: Any] {
        var dic = [String: Any]()
        
        if (element.attributes.isEmpty && element.childElements.isEmpty) {
            dic.updateValue(element.content!, forKey: element.name)
        }
        
        if (!element.attributes.isEmpty) {
            for (key, value) in element.attributes {
                dic.updateValue(value, forKey: key)
            }
            if let content = element.content {
                dic.updateValue(content, forKey: "undefined")
            }
        }
        
        if (!element.childElements.isEmpty) {
            let group = groupElements(childElements: element.childElements)
            for (key, value) in group {
                if (value.count == 1){
                    if (value[0].attributes.isEmpty && value[0].childElements.isEmpty) {
                        dic.updateValue(value[0].content!, forKey: value[0].name)
                    } else {
                        dic.updateValue(parseElement(element: value[0]), forKey: key)
                    }
                } else {
                    dic.updateValue(parseListElements(childElement: value), forKey: key)
                }
            }
        }
        
        return dic
    }
    
    private func parseListElements(childElement:[Element]) -> [Any] {
        var elements = [Any]()
        
        for element in childElement {
            if (element.attributes.isEmpty && element.childElements.isEmpty) {
                elements.append(element.content ?? "WTF")
            } else {
                elements.append(parseElement(element: element))
            }
        }
        
        return elements
    }
    
    private func parseGroup(group: [String: [Element]]) -> [String: Any]{
        var dic = [String: Any]()
        
        for (key, value) in group {
            if (value.count == 1){
                dic.updateValue(parseElement(element: value[0]), forKey: key)
            } else {
                dic.updateValue(parseListElements(childElement: value), forKey: key)
            }
        }
        
        return dic
    }
    
    /// 將元素進行分組
    private func groupElements(childElements:[Element]) -> [String: [Element]]{
        var group = [String: [Element]]()
        
        for element in childElements {
            let key = element.name
            if (!group.keys.contains(key)){
                group[key] = [Element]()
            }
            
            group[key]?.append(element)
        }
        
        return group
    }
}

fileprivate class Element: Codable {
    var name: String = "unnamed"
    var content: String?
    var attributes: [String: String]
    var childElements: [Element]
    
    public init(
        name: String,
        content: String? = nil,
        attributes: [String: String] = [:],
        childElements: [Element] = []
    ) {
        self.name = name
        self.content = content
        self.attributes = attributes
        self.childElements = childElements
    }
}

fileprivate class XMLParserUtilDelegate: NSObject, XMLParserDelegate {
    
    //fileprivate var documentRoot: Element
    fileprivate var stack = [Element]()
    
    fileprivate init(_ elementRoot: Element) {
        stack.append(elementRoot)
    }
    
    // 標籤起始，包含屬性
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        let node = Element(name: elementName)
        if (!attributeDict.isEmpty) {
            node.attributes = attributeDict
        }
        
        let parentNode = stack.last
        parentNode?.childElements.append(node)
        stack.append(node)
    }
    
    // 標籤內容
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (!string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            stack.last?.content = string
        }
    }
    
    // 標籤結尾
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        stack.removeLast()
    }
}
