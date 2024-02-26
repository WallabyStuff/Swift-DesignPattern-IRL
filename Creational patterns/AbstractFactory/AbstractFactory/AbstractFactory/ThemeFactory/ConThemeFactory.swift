//
//  ConThemeFactory.swift
//  AbstractFactory
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

struct ConThemeFactory: ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color.white)
        .foregroundStyle(Color(hex: "#4D4D4D"))
        .clipShape(Capsule())
    )
  }
  
  func createMyChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color(hex: "#2DA15A"))
        .foregroundStyle(Color.white)
        .clipShape(Capsule())
    )
  }
  
  func createBackground() -> AnyView {
    AnyView(
      Image("con")
        .resizable()
        .aspectRatio(contentMode: .fill)
    )
  }
}
