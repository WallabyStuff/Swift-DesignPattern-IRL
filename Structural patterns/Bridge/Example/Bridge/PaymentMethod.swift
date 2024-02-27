//
//  PaymentMethod.swift
//  Bridge
//
//  Created by 이승기 on 2/27/24.
//

import Foundation

// 결제 방식에 대한 추상화
protocol PaymentMethod {
  func processPayment(amount: Double)
}

class CreditCard: PaymentMethod {
  func processPayment(amount: Double) {
    GlobalToast.shared.showToast(title: "신용카드로 \(amount)원 결제 중입니다..")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      GlobalToast.shared.showToast(title: "\(amount)원 결제 완료 (결제수단: 신용카드)")
    }
  }
}

class Toss: PaymentMethod {
  func processPayment(amount: Double) {
    GlobalToast.shared.showToast(title: "토스로 \(amount)원 결제 중입니다..")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      GlobalToast.shared.showToast(title: "\(amount)원 결제 완료 (결제수단: 토스페이)")
    }
  }
}

class NaverPay: PaymentMethod {
  func processPayment(amount: Double) {
    GlobalToast.shared.showToast(title: "네이버페이로 \(amount)원 결제 중입니다..")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      GlobalToast.shared.showToast(title: "\(amount)원 결제 완료 (결제수단: 네이버페이)")
    }
  }
}

// 결제 처리에 대한 추상화
class PaymentProcessor {
  private let method: PaymentMethod
  private let amount: Double
  
  init(method: PaymentMethod, amount: Double) {
    self.method = method
    self.amount = amount
  }
  
  func executePayment() {
    method.processPayment(amount: amount)
  }
}
