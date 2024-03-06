//
//  ContentView.swift
//  ProtectionProxy
//
//  Created by 이승기 on 3/7/24.
//

import SwiftUI

struct ContentView: View {
  
  @State private var userRole: UserRole = .guest
  
  var body: some View {
    NavigationView {
      HStack {
        Picker("유저 모드", selection: $userRole) {
          ForEach(UserRole.allCases, id: \.self) { role in
            Text(role.displayName)
          }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 200)
        
        NavigationLink {
          // 이렇게 직접 myDocument를 보여주는게 아니라 프록시를 통해서 보여주는 거임
          let myDocument = MyDocument()
          let documentProxy = DocumentProxy(userRole: userRole, document: myDocument)
          documentProxy.display()
        } label: {
          HStack {
            Text("도큐먼트 접속")
            Image(systemName: "arrow.right")
          }
          .foregroundStyle(Color.black)
          .padding()
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
