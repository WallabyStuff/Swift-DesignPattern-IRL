//
//  DeliveryState.swift
//  State
//
//  Created by 이승기 on 3/25/24.
//

import UIKit

protocol DeliveryState {
  var imageName: String { get }
  var description: String { get }
  func updateToNextState(context: DeliveryContext)
  func updateToPreviousState(context: DeliveryContext)
}

class DeliveryContext: ObservableObject {
  @Published var state: DeliveryState = Preparing()
  
  init(initialState: DeliveryState) {
    self.state = initialState
  }
  
  func setState(state: DeliveryState) {
    self.state = state
  }
  
  func next() {
    state.updateToNextState(context: self)
  }
  
  func previous() {
    state.updateToPreviousState(context: self)
  }
}

struct Preparing: DeliveryState {
  var imageName: String = "shippingbox.fill"
  var description: String = "배송 준비중 입니다."
  
  func updateToNextState(context: DeliveryContext) {
    print("배송중 상태로 업데이트")
    context.setState(state: OutForDelivery())
  }
  
  func updateToPreviousState(context: DeliveryContext) {
    print("이전 상태는 없습니다.")
  }
}

struct OutForDelivery: DeliveryState {
  var imageName: String = "truck.box.fill"
  var description: String = "배송 중입니다."
  
  func updateToNextState(context: DeliveryContext) {
    print("배송완료 상태로 업데이트")
    context.setState(state: Delivered())
  }
  
  func updateToPreviousState(context: DeliveryContext) {
    print("준비중 상태로 업데이트")
    context.setState(state: Preparing())
  }
}

struct Delivered: DeliveryState {
  var imageName: String = "bell.and.waves.left.and.right.fill"
  var description: String = "배송이 완료되었습니다."
  
  func updateToNextState(context: DeliveryContext) {
    print("배송이 이미 완료되었습니다.")
  }
  
  func updateToPreviousState(context: DeliveryContext) {
    print("배송중 상태로 업데이트")
    context.setState(state: OutForDelivery())
  }
}
