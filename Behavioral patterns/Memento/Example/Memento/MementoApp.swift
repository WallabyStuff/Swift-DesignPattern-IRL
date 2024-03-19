//
//  MementoApp.swift
//  Memento
//
//  Created by 이승기 on 3/19/24.
//

import SwiftUI

@main
struct MementoApp: App {
  var body: some Scene {
    WindowGroup {
      let initialSetting = Memento(hat: Hat.ribbon.emoji,
                                   face: Face.smile.emoji,
                                   cloth: Cloth.tShirt.emoji,
                                   shoes: Shoes.sneakers.emoji)
      ContentView(careTaker: CareTaker(initialSettings: initialSetting))
    }
  }
}
