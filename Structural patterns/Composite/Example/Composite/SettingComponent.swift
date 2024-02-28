//
//  SettingComponent.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

protocol SettingComponent {
  var title: String { get }
  func render() -> AnyView
}

// 얘는 하위 leaf 들을 포함하고 있는 Composite임.
// 편의를 위해 protocol로 뺐음.
protocol Compositable {
  var leaves: [SettingComponent] { get set }
  mutating func addComponent(_ component: SettingComponent)
}

extension Compositable {
  mutating func addComponent(_ component: SettingComponent) {
    self.leaves.append(component)
  }
}
