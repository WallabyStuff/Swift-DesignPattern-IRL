//
//  AlertBuildㄷㄱ.swift
//  Builder
//
//  Created by 이승기 on 2/27/24.
//

import UIKit

protocol AlertBuilder {
  func setTitle(_ title: String) -> AlertBuilder
  func setMessage(_ message: String) -> AlertBuilder
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> AlertBuilder
  func build() -> UIAlertController
}

class CustomAlertBuilder: AlertBuilder {
  private var title: String?
  private var message: String?
  private var actions: [UIAlertAction] = []
  
  @discardableResult
  func setTitle(_ title: String) -> AlertBuilder {
    self.title = title
    return self
  }
  
  @discardableResult
  func setMessage(_ message: String) -> AlertBuilder {
    self.message = message
    return self
  }
  
  @discardableResult
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> AlertBuilder {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    actions.append(action)
    return self
  }
  
  func build() -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach { alert.addAction($0) }
    return alert
  }
}
