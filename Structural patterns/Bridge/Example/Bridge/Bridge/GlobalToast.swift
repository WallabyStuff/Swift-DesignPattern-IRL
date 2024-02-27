//
//  GlobalToast.swift
//  Bridge
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

final class GlobalToast: ObservableObject {
  
  static let shared = GlobalToast()
  
  @Published var isShown = false
  @Published var title: String = ""
  
  private init() { }
  
  public func showToast(title: String) {
    self.title = title
    isShown = true
  }
}
