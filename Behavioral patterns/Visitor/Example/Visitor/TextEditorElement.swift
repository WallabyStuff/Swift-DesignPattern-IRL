//
//  TextEditorElement.swift
//  Visitor
//
//  Created by 이승기 on 3/16/24.
//

import UIKit

protocol TextEditorElement {
  var textField: UITextField { get set }
  func render() -> UIView
  func accept(visitor: Visitor)
}




class TextElement: TextEditorElement {
  var textField = UITextField()
  
  func render() -> UIView {
    textField.font = .systemFont(ofSize: 16, weight: .regular)
    textField.placeholder = "내용을 입력해 주세요"
    return textField
  }
  
  func accept(visitor: Visitor) {
    visitor.visit(e: self)
  }
}

class HeaderElement: TextEditorElement {
  var textField = UITextField()
  
  func render() -> UIView {
    textField.font = .systemFont(ofSize: 32, weight: .bold)
    textField.placeholder = "내용을 입력해 주세요"
    return textField
  }
  
  func accept(visitor: Visitor) {
    visitor.visit(e: self)
  }
}

class BoldTextElement: TextEditorElement {
  var textField = UITextField()
  
  func render() -> UIView {
    textField.font = .systemFont(ofSize: 16, weight: .bold)
    textField.placeholder = "내용을 입력해 주세요"
    return textField
  }
  
  func accept(visitor: Visitor) {
    visitor.visit(e: self)
  }
}
