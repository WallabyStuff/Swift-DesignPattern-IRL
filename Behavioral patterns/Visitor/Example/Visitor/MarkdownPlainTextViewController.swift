//
//  MarkdownPlainTextViewController.swift
//  Visitor
//
//  Created by 이승기 on 3/16/24.
//

import UIKit
import SnapKit
import Then

final class MarkdownPlainTextViewController: UIViewController {
  
  // MARK: - UI
  
  private let textView = UITextView().then {
    $0.textColor = .label
    $0.font = .systemFont(ofSize: 20)
    $0.textAlignment = .left
    $0.isScrollEnabled = true
    $0.isEditable = false // 사용자가 텍스트를 편집하지 못하게 설정
    $0.backgroundColor = .clear // UILabel과 같은 배경색을 사용하려면
  }

  // MARK: - Properties
  
  private let markdownText: String
  
  
  // MARK: - LifeCycle
  
  init(markdownText: String) {
    self.markdownText = markdownText
    super.init(nibName: nil, bundle: nil)
    
    textView.text = markdownText
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupLayout()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    view.addSubview(textView) // textView를 뷰에 추가
  }
  
  private func setupLayout() {
    textView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
      $0.horizontalEdges.equalToSuperview().inset(24)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24) // UITextView의 높이를 설정
    }
  }
}


// MARK: - Preview

#Preview {
  MarkdownPlainTextViewController(markdownText: "sample text")
}
