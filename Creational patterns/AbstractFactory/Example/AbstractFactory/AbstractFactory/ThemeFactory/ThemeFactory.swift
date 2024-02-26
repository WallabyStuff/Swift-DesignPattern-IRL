//
//  ThemeFactory.swift
//  AbstractFactory
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

protocol ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView
  func createMyChatBubble(text: String) -> AnyView
  func createBackground() -> AnyView
}
