//
//  BridgeApp.swift
//  Bridge
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI
import AlertToast

@main
struct BridgeApp: App {
  
  @StateObject var globalToast = GlobalToast.shared
  
  var body: some Scene {
    WindowGroup {
      PaymentView()
        .toast(isPresenting: $globalToast.isShown) {
          .init(displayMode: .alert, type: .regular, title: globalToast.title)
        }
    }
  }
}
