//
//  Document.swift
//  ProtectionProxy
//
//  Created by 이승기 on 3/8/24.
//

import SwiftUI

protocol Document {
  func display() -> AnyView
}

struct MyDocument: Document {
  func display() -> AnyView {
    let url = Bundle.main.url(forResource: "sample", withExtension: "pdf")!
    return AnyView(PDFKitView(url: url))
  }
}

struct DocumentProxy: Document { // 👈 이거 프록시 종특
  
  private let userRole: UserRole
  private let document: any Document
  
  init(userRole: UserRole, document: any Document) {
    self.userRole = userRole
    self.document = document
  }
  
  func display() -> AnyView {
    switch userRole {
    case .guest:
      return AnyView(
        VStack {
          Text("🤚")
            .font(.system(size: 60))
          
          Text("접근 권한이 없습니다")
            .foregroundStyle(Color.black)
            .opacity(0.5)
        }
      )
      
    case .admin:
      return document.display() // 👈 이거 프록시 종특 DocumentProxy가 document와 같은 protocol을 채택함으로 display를 대리해서 호출해주는 모습
    }
  }
}
