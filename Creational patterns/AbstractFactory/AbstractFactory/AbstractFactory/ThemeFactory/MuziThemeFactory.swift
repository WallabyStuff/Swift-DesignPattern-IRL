//
//  MuziThemeFactory.swift
//  AbstractFactory
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

struct MuziThemeFactory: ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color.white)
        .foregroundStyle(Color.black)
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.black, lineWidth: 1.0)
        )
    )
  }
  
  func createMyChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color(hex: "#FEF2B5"))
        .foregroundStyle(Color.black)
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.black, lineWidth: 1.0)
        )
    )
  }
  
  func createBackground() -> AnyView {
    AnyView(
      Color(hex: "#FFED71")
    )
  }
}
