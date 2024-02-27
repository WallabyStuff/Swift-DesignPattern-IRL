//
//  ContentView.swift
//  AbstractFactory
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI

struct ContentView: View {
  
  // MARK: - Properties
  
  enum Theme: String, CaseIterable {
    case muji
    case apeach
    case con
    
    var factory: ThemeFactory {
      switch self {
      case .muji:
        return MuziThemeFactory()
      case .apeach:
        return AppeachThemeFactory()
      case .con:
        return ConThemeFactory()
      }
    }
  }
  
  @State private var currentTheme: Theme = .muji
  
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      HStack {
        currentTheme.factory.createOpponentChatBubble(text: "안녕하세요")
        Spacer()
      }
      
      HStack {
        Spacer()
        currentTheme.factory.createMyChatBubble(text: "안녕하세요☺️")
      }
      
      HStack {
        Spacer()
        currentTheme.factory.createMyChatBubble(text: "아래에서 segment에서 테마를 선택할 수 있어요")
      }
      
      Spacer()
      
      Picker("테마를 선택해 주세요", selection: $currentTheme) {
        ForEach(Theme.allCases, id: \.self) { theme in
          Text(theme.rawValue)
        }
      }
      .pickerStyle(.segmented)
    }
    .padding(12)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      currentTheme.factory.createBackground()
        .ignoresSafeArea()
    )
  }
}

#Preview {
  ContentView()
}
