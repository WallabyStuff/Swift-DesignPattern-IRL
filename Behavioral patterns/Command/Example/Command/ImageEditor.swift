//
//  ImageEditor.swift
//  Command
//
//  Created by 이승기 on 3/20/24.
//

import UIKit
import CoreImage


// MARK: - Invoker

class ImageEditor {
  private var imageView: UIImageView
  var originalImage: UIImage?
  private var commandHistory: [ImageEditCommand] = []
  private var previousImage: UIImage?
  
  init(imageView: UIImageView) {
    self.imageView = imageView
    self.originalImage = imageView.image
  }
  
  func execute(command: ImageEditCommand) {
    previousImage = imageView.image
    command.execute(with: originalImage)
    commandHistory.append(command)
  }
  
  func undo() {
    guard !commandHistory.isEmpty else { return }
    let lastCommand = commandHistory.removeLast()
    lastCommand.undo()
    if let previous = previousImage {
      imageView.image = previous
    }
  }
}
