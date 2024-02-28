//
//  Leave+ShowPreview.swift
//  Composite
//
//  Created by 이승기 on 2/28/24.
//

import SwiftUI

struct ShowPreview: SettingComponent {
  var title: String
  
  func render() -> AnyView {
    AnyView(
      NavigationLink(destination: {
        Text("\(title) 설정 화면")
      }, label: {
        Text(title)
      })
    )
  }
}
