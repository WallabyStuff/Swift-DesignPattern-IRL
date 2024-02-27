//
//  ApeachThemeFactory.swift
//  AbstractFactory
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

struct AppeachThemeFactory: ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color(hex: "#F9E1E7"))
        .foregroundStyle(Color(hex: "#6A696A"))
        .clipShape(Capsule())
    )
  }
  
  func createMyChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color.white)
        .foregroundStyle(Color(hex: "#6A696A"))
        .clipShape(Capsule())
    )
  }
  
  func createBackground() -> AnyView {
    AnyView(
      Image("apeach")
        .resizable()
        .aspectRatio(contentMode: .fill)
    )
  }
}
