//
//  Leave+ScheduledSummary.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

struct ScheduledSummary: SettingComponent {
  var title: String
  @Binding var isOn: Bool
  
  init(title: String, isOn: Binding<Bool>) {
    self.title = title
    _isOn = isOn
  }
  
  func render() -> AnyView {
    AnyView(
      Toggle(title, isOn: $isOn)
    )
  }
}
