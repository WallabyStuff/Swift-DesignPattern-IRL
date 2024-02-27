//
//  ContentView.swift
//  Bridge
//
//  Created by 이승기 on 2/27/24.
//

import SwiftUI
import AlertToast

// 결제 방식과 결제 처리 클래스는 이전 예시와 동일하게 유지

struct PaymentView: View {
  
  @State private var selectedMethod: PaymentMethod = CreditCard()
  
  var body: some View {
    VStack {
      Text("결제 수단을 선택해 주세요")
        .font(.headline)
      
      HStack {
        Button("신용카드") {
          selectedMethod = CreditCard()
        }
        .padding()
        .background(Color.orange)
        .foregroundColor(.white)
        .cornerRadius(10)
        .opacity(type(of: selectedMethod) == CreditCard.self ? 1 : 0.6)
        
        Button("토스페이") {
          selectedMethod = Toss()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .opacity(type(of: selectedMethod) == Toss.self ? 1 : 0.6)
        
        Button("네이버페이") {
          selectedMethod = NaverPay()
        }
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
        .opacity(type(of: selectedMethod) == NaverPay.self ? 1 : 0.6)
      }
      
      Spacer()
      
      Button("결제") {
        let processor = PaymentProcessor(method: selectedMethod, amount: 100_000)
        processor.executePayment()
      }
      .padding()
      .background(Color.black)
      .foregroundColor(.white)
      .cornerRadius(10)
    }
    .padding()
  }
}

// SwiftUI 미리보기 환경
struct PaymentView_Previews: PreviewProvider {
  static var previews: some View {
    PaymentView()
  }
}
