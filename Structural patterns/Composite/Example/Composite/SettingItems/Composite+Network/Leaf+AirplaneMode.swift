//
//  AirplaneMode.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

// AirplaneMode 에는 더이상 하위 leaf가 없기 때문에 children이 존재하지 않습니다.
struct AirplaneModeSetting: SettingComponent {
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
