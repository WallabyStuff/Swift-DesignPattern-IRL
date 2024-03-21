//
//  ContentView.swift
//  State
//
//  Created by 이승기 on 3/25/24.
//

import SwiftUI

struct ContentView: View {
  
  // MARK: - Properties
  
  @StateObject var deliveryContext = DeliveryContext(initialState: Preparing())
  
  
  // MARK: - Views
  
  var body: some View {
    ZStack {
      VStack(spacing: 12) {
        Image(systemName: deliveryContext.state.imageName)
          .font(.system(size: 40))
          .foregroundStyle(.gray.opacity(0.5))
        
        Text(deliveryContext.state.description)
      }
      
      VStack {
        Spacer()
        
        HStack {
          Button {
            deliveryContext.previous()
          } label: {
            prevButton()
          }
          
          Spacer()
          
          Button {
            deliveryContext.next()
          } label: {
            nextButton()
          }
        }
        .padding()
      }
    }
  }
  
  private func nextButton() -> some View {
    HStack {
      Text("다음 상태로")
      Image(systemName: "arrow.right")
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
    .foregroundStyle(Color.white)
  }
  
  private func prevButton() -> some View {
    HStack {
      Image(systemName: "arrow.left")
      Text("이전 상태로")
    }
    .padding()
    .foregroundStyle(Color.black)
  }
}

#Preview {
  ContentView()
}
