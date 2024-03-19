//
//  ContentView.swift
//  Memento
//
//  Created by 이승기 on 3/19/24.
//

import SwiftUI

struct ContentView: View {
  
  // MARK: - Properties
  
  @StateObject var careTaker: CareTaker
  
  
  // MARK: - Views
  
  var body: some View {
    ZStack {
      VStack {
        HStack() {
          Text("History")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .padding()
          
          ScrollView {
            VStack {
              ForEach(Array(careTaker.settingsHistory.reversed().enumerated()), id: \.offset) { _, setting in
                Text("\(setting.hat)  \(setting.face)  \(setting.cloth)  \(setting.shoes)")
              }
            }
            .frame(maxWidth: .infinity)
            .padding()
          }
          .frame(maxWidth: .infinity, maxHeight: 144)
          .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
          .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
          .padding()
        }
        
        Spacer()
      }
      
      VStack {
        EmojiPickerView(emojis: Hat.allCases.map { $0.emoji },
                        selectedEmoji: $careTaker.currentSettings.hat) { newEmoji in
          careTaker.currentSettings.hat = newEmoji
          careTaker.save(settings: careTaker.currentSettings)
        }
        
        EmojiPickerView(emojis: Face.allCases.map { $0.emoji },
                        selectedEmoji: $careTaker.currentSettings.face) { newEmoji in
          careTaker.currentSettings.face = newEmoji
          careTaker.save(settings: careTaker.currentSettings)
        }
        
        EmojiPickerView(emojis: Cloth.allCases.map { $0.emoji },
                        selectedEmoji: $careTaker.currentSettings.cloth) { newEmoji in
          careTaker.currentSettings.cloth = newEmoji
          careTaker.save(settings: careTaker.currentSettings)
        }
        
        EmojiPickerView(emojis: Shoes.allCases.map { $0.emoji },
                        selectedEmoji: $careTaker.currentSettings.shoes) { newEmoji in
          careTaker.currentSettings.shoes = newEmoji
          careTaker.save(settings: careTaker.currentSettings)
        }
      }
      
      VStack {
        Spacer()
        
        HStack(spacing: 12) {
          Button {
            careTaker.undo()
          } label: {
            Image(systemName: "arrow.uturn.left")
              .font(.system(size: 20))
              .foregroundStyle(Color.black)
              .opacity(careTaker.isUndoAvailable() ? 1.0 : 0.5)
          }
          .disabled(!careTaker.isUndoAvailable())
          
          Button {
            careTaker.redo()
          } label: {
            Image(systemName: "arrow.uturn.right")
              .font(.system(size: 20))
              .foregroundStyle(Color.black)
              .opacity(careTaker.isRedoAvailable() ? 1.0 : 0.5)
          }
          .disabled(!careTaker.isRedoAvailable())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
        .padding()
      }
    }
  }
}


// MARK: - Preview

#Preview {
  let initialSetting = Memento(hat: Hat.ribbon.emoji,
                               face: Face.smile.emoji,
                               cloth: Cloth.tShirt.emoji,
                               shoes: Shoes.sneakers.emoji)
  return ContentView(careTaker: CareTaker(initialSettings: initialSetting))
}
