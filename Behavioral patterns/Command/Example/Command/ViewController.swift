//
//  ViewController.swift
//  Command
//
//  Created by 이승기 on 3/20/24.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var catImageView: UIImageView!
  @IBOutlet weak var brightnessSlider: UISlider!
  
  var imageEditor: ImageEditor!
  var originalImage = UIImage(named: "cat")
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageEditor = ImageEditor(imageView: catImageView)
    contentView.layer.cornerRadius = 20
    catImageView.layer.shadowColor = UIColor.black.cgColor
    catImageView.layer.shadowOpacity = 0.2
    catImageView.layer.shadowOffset = .zero
    catImageView.layer.shadowRadius = 12
  }
  
  
  // MARK: - Actions
  
  @IBAction func didTapUndoButton(_ sender: Any) {
    imageEditor.undo()
  }
  
  @IBAction func didChangeCornerRadiusValue(_ sender: UISlider) {
    let command = ApplyCornerRadiusCommand(imageView: catImageView, cornerRadius: CGFloat(sender.value))
    imageEditor.execute(command: command)
  }
  
  @IBAction func didChangeBrightnessValue(_ sender: UISlider) {
    let command = AdjustBrightnessCommand(imageView: catImageView, brightness: sender.value)
    imageEditor.execute(command: command)
  }
}

