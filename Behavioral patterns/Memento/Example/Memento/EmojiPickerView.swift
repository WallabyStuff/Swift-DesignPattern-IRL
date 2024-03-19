//
//  EmojiPickerView.swift
//  Memento
//
//  Created by 이승기 on 3/19/24.
//

import SwiftUI

struct EmojiPickerView: View {
  
  // MARK: - Properties
  
  let emojis: [String]
  @Binding var selectedEmoji: String
  @State private var currentIndex = 0
  let didChangeSelection: (String) -> Void

  
  // MARK: - Views
  
  var body: some View {
    HStack(spacing: 20) {
      Button {
        currentIndex -= 1
        didChangeSelection(emojis[currentIndex])
      } label: {
        Image(systemName: "arrowtriangle.backward.fill")
          .font(.system(size: 28))
          .foregroundStyle(Color.gray.opacity(0.5))
          .opacity(currentIndex == 0 ? 0.5 : 1.0)
      }
      .disabled(currentIndex == 0)
      
      Text(selectedEmoji)
        .font(.system(size: 50))
      
      Button {
        currentIndex += 1
        didChangeSelection(emojis[currentIndex])
      } label: {
        Image(systemName: "arrowtriangle.right.fill")
          .font(.system(size: 28))
          .foregroundStyle(Color.gray.opacity(0.5))
          .opacity(currentIndex == (emojis.count - 1) ? 0.5 : 1.0)
      }
      .disabled(currentIndex == (emojis.count - 1))
    }
    .onChange(of: currentIndex) { index in
      selectedEmoji = emojis[index]
    }
    .onChange(of: selectedEmoji) { newValue in
      currentIndex = emojis.firstIndex(of: selectedEmoji)!
    }
  }
}

// MARK: - Preview

#Preview {
  struct ContentView: View {
    @State private var selectedEmoji = Hat.cap.emoji
    var body: some View {
      EmojiPickerView(emojis: Hat.allCases.map { $0.emoji },
                      selectedEmoji: $selectedEmoji,
                      didChangeSelection: { _ in })
    }
  }
  
  return ContentView()
}
