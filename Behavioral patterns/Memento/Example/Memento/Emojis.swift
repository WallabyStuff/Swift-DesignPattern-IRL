//
//  EmojiIngredients.swift
//  Memento
//
//  Created by 이승기 on 3/19/24.
//

import Foundation

enum Hat: CaseIterable {
  case ribbon
  case army
  case cap
  case magician
  case graduation
  
  var emoji: String {
    switch self {
    case .ribbon:
      return "👒"
    case .army:
      return "🪖"
    case .cap:
      return "🧢"
    case .magician:
      return "🎩"
    case .graduation:
      return "🎓"
    }
  }
}

enum Face: CaseIterable {
  case smile
  case wink
  case laughing
  case surprised
  case sad
  
  var emoji: String {
    switch self {
    case .smile:
      return "😊"
    case .wink:
      return "😉"
    case .laughing:
      return "😆"
    case .surprised:
      return "😯"
    case .sad:
      return "😢"
    }
  }
}

enum Cloth: CaseIterable {
  case tShirt
  case pinkTop
  case swimmingWear
  case dress
  case coat
  
  var emoji: String {
    switch self {
    case .tShirt:
      return "👕"
    case .pinkTop:
      return "👚"
    case .swimmingWear:
      return "🩱"
    case .dress:
      return "👗"
    case .coat:
      return "🧥"
    }
  }
}

enum Shoes: CaseIterable {
  case sneakers
  case boots
  case highHeels
  case sandals
  case loafers
  
  var emoji: String {
    switch self {
    case .sneakers:
      return "👟"
    case .boots:
      return "👢"
    case .highHeels:
      return "👠"
    case .sandals:
      return "🩴"
    case .loafers:
      return "👞"
    }
  }
}
