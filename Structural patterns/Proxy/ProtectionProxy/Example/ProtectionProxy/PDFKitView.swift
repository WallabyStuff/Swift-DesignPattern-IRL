//
//  PDFKitView.swift
//  ProtectionProxy
//
//  Created by 이승기 on 3/8/24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
  
  let url: URL
  
  func makeUIView(context: Context) -> some UIView {
    let pdfView = PDFView()
    pdfView.document = PDFDocument(url: url)
    return pdfView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) { }
}
