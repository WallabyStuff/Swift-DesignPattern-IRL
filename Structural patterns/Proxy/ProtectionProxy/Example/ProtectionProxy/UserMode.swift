//
//  UserMode.swift
//  ProtectionProxy
//
//  Created by 이승기 on 3/7/24.
//

import Foundation

enum UserRole: CaseIterable {
  case guest
  case admin
  
  var displayName: String {
    switch self {
    case .guest:
      "🫥 게스트"
    case .admin:
      "🕵️ 어드민"
    }
  }
}
