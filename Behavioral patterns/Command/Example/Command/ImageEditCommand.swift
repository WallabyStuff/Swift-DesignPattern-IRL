//
//  ImageEditCommand.swift
//  Command
//
//  Created by 이승기 on 3/20/24.
//

import UIKit
import CoreImage

protocol ImageEditCommand {
    func execute(with originalImage: UIImage?)
    func undo()
}


// MARK: - 이미지에 corner radius 조절하는 콘크리트 커맨드

class ApplyCornerRadiusCommand: ImageEditCommand {
  private weak var imageView: UIImageView?
  private let cornerRadius: CGFloat
  private var previousCornerRadius: CGFloat = 0
  
  init(imageView: UIImageView, cornerRadius: CGFloat) {
    self.imageView = imageView
    self.cornerRadius = cornerRadius
    self.previousCornerRadius = imageView.layer.cornerRadius // 이전 상태 저장
  }
  
  func execute(with originalImage: UIImage?) {
    guard let imageView = imageView else { return }
    previousCornerRadius = imageView.layer.cornerRadius // 실행 전 상태 저장
    DispatchQueue.main.async {
      imageView.layer.cornerRadius = self.cornerRadius
      imageView.clipsToBounds = true
    }
  }
  
  func undo() {
    guard let imageView = imageView else { return }
    DispatchQueue.main.async {
      imageView.layer.cornerRadius = self.previousCornerRadius
      imageView.clipsToBounds = self.previousCornerRadius > 0
    }
  }
}


// MARK: - 이미지 밝기 조절하는 콘크리트 커맨드

class AdjustBrightnessCommand: ImageEditCommand {
  private let imageView: UIImageView
  private let brightness: Float // -1.0에서 1.0 사이의 범위
  private var previousImage: UIImage?
  
  init(imageView: UIImageView, brightness: Float) {
    self.imageView = imageView
    self.brightness = brightness
  }
  
  func execute(with originalImage: UIImage?) {
    self.previousImage = imageView.image // 실행 전 이미지 상태를 저장합니다.
    guard let originalImage = originalImage, let cgimg = originalImage.cgImage else { return }
    let ciImage = CIImage(cgImage: cgimg)
    let filter = CIFilter(name: "CIColorControls")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)
    filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
    
    let context = CIContext(options: nil)
    if let output = filter?.outputImage, let cgimgresult = context.createCGImage(output, from: output.extent) {
      let processedImage = UIImage(cgImage: cgimgresult)
      DispatchQueue.main.async {
        self.imageView.image = processedImage // 처리된 이미지를 화면에 표시합니다.
      }
    }
  }
  
  func undo() {
    DispatchQueue.main.async {
      self.imageView.image = self.previousImage // 이전 이미지 상태로 되돌립니다.
    }
  }
}
