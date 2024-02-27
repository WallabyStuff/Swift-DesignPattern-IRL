//
//  ViewController.swift
//  Builder
//
//  Created by 이승기 on 2/27/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func didTapShowAlertButton(_ sender: Any) {
    let builder = CustomAlertBuilder()
    let alert = builder
      .setTitle("스위프트 디자인 패턴")
      .setMessage("스위프트 디자인패턴을 배워봅시다")
      .addAction(title: "취소", style: .cancel, handler: nil)
      .addAction(title: "설정으로 이동", style: .default) { _ in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      }
      .build()
    
    present(alert, animated: true)
  }
}

