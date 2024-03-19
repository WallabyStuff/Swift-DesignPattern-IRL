//
//  Originator.swift
//  Memento
//
//  Created by 이승기 on 3/19/24.
//

import SwiftUI

final class CareTaker: ObservableObject {
  
  // MARK: - Properties
  
  @Published var settingsHistory: [Memento] = []
  private var currentIndex = 0 {
    didSet {
      self.currentSettings = settingsHistory[currentIndex]
    }
  }
  
  @Published var currentSettings: Memento
  
  
  // MARK: - Initializers
  
  init(initialSettings: Memento) {
    self.currentSettings = initialSettings
    settingsHistory.append(initialSettings)
  }
  
  
  // MARK: - Methods
  
  func save(settings: Memento) {
    if currentIndex < settingsHistory.count - 1 {
      settingsHistory = Array(settingsHistory.prefix(upTo: currentIndex + 1))
    }
    settingsHistory.append(settings)
    currentIndex = settingsHistory.count - 1
  }
  
  func undo() {
    if isUndoAvailable() {
      currentIndex -= 1
    }
  }
  
  func redo() {
    if isRedoAvailable() {
      currentIndex += 1
    }
  }
  
  func isUndoAvailable() -> Bool {
    currentIndex > 0 ? true : false
  }
  
  func isRedoAvailable() -> Bool {
    currentIndex < settingsHistory.count - 1 ? true : false
  }
}
