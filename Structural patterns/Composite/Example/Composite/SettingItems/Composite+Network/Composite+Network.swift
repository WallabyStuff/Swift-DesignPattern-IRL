//
//  NetworkSetting.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

struct NetworkSetting: SettingComponent, Compositable {
  var title: String
  var leaves = [SettingComponent]()
  
  func render() -> AnyView {
    AnyView(
      Section {
        ForEach(leaves.indices, id: \.self) { index in
          self.leaves[index].render()
        }
      } header: {
        Text(title)
      }
    )
  }
}
