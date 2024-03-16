//
//  Visitor.swift
//  Visitor
//
//  Created by 이승기 on 3/16/24.
//

import Foundation

protocol Visitor {
  func visit(e: TextElement)
  func visit(e: HeaderElement)
  func visit(e: BoldTextElement)
}





class MarkdownExporter: Visitor {
  var markdown = ""
  
  func visit(e: TextElement) {
    markdown += "\n\(e.textField.text ?? "")"
  }
  
  func visit(e: HeaderElement) {
    markdown += "\n#\(e.textField.text ?? "")"
  }
  
  func visit(e: BoldTextElement) {
    markdown += "\n**\(e.textField.text ?? "")**"
  }
}

class XMLExporter: Visitor {
  var xml = ""
  
  func visit(e: TextElement) {
    xml += "<text>\(escape(e.textField.text ?? ""))</text>\n"
  }
  
  func visit(e: HeaderElement) {
    xml += "<header>\(escape(e.textField.text ?? ""))</header>\n"
  }
  
  func visit(e: BoldTextElement) {
    xml += "<bold>\(escape(e.textField.text ?? ""))</bold>\n"
  }
  
  private func escape(_ string: String) -> String {
    let escapeMap: [String: String] = [
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      "\"": "&quot;",
      "'": "&apos;"
    ]
    var escapedString = string
    for (unescaped, escaped) in escapeMap {
      escapedString = escapedString.replacingOccurrences(of: unescaped, with: escaped)
    }
    return escapedString
  }
}
