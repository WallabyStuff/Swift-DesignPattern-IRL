//
//  Root.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

// Wifi Setting에는 하위 leaf들을 가지고 있기 때문에 하위 leaf를 추가할 수 있는 Compositable을 같이 채택
struct WifiSetting: SettingComponent, Compositable {
  var title: String
  var leaves = [SettingComponent]()
  
  func render() -> AnyView {
    AnyView(
      NavigationLink {
        List {
          ForEach(leaves.indices, id: \.self) { index in
            self.leaves[index].render()
          }
        }
      } label: {
        Text(title)
      }
    )
  }
}
