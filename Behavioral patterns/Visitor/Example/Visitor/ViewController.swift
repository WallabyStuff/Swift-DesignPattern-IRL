//
//  ViewController.swift
//  Visitor
//
//  Created by 이승기 on 3/16/24.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
  
  // MARK: - UI
  
  let elementStackView = UIStackView().then {
    $0.alignment = .leading
    $0.spacing = 4
    $0.distribution = .fillProportionally
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .fill
  }
  
  let buttonStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.axis = .horizontal
    $0.layer.cornerRadius = 10
    $0.backgroundColor = .systemGray6
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.systemGray4.cgColor
  }
  
  let headerElementButton = UIButton().then {
    $0.setImage(UIImage(systemName: "h.square.on.square"), for: .normal)
    $0.tintColor = UIColor.label
  }
  
  let boldTextElementButton = UIButton().then {
    $0.setImage(UIImage(systemName: "bold"), for: .normal)
    $0.tintColor = UIColor.label
  }
  
  let textElementButton = UIButton().then {
    $0.setImage(UIImage(systemName: "textformat"), for: .normal)
    $0.tintColor = UIColor.label
  }
  
  let markdownButton = UIButton().then {
    $0.setImage(UIImage(systemName: "doc.text"), for: .normal)
    $0.backgroundColor = .label
    $0.tintColor = .systemBackground
    $0.layer.cornerRadius = 10
  }
  
  let xmlButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left.forwardslash.chevron.right"), for: .normal)
    $0.backgroundColor = .label
    $0.tintColor = .systemBackground
    $0.layer.cornerRadius = 10
  }
  
  
  // MARK: - Properties
  
  private var markdownElements = [TextEditorElement]()
  private var lastMarkdownElementType: TextEditorElement.Type?
  private weak var activeTextField: UITextField?
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupActions()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(elementStackView)
    view.addSubview(buttonStackView)
    view.addSubview(markdownButton)
    view.addSubview(xmlButton)
    
    buttonStackView.addArrangedSubview(headerElementButton)
    buttonStackView.addArrangedSubview(boldTextElementButton)
    buttonStackView.addArrangedSubview(textElementButton)
  }
  
  private func setupLayout() {
    elementStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
      $0.horizontalEdges.equalToSuperview().inset(24)
    }
    
    headerElementButton.snp.makeConstraints {
      $0.width.equalTo(48)
    }
    
    boldTextElementButton.snp.makeConstraints {
      $0.width.equalTo(32)
    }
    
    textElementButton.snp.makeConstraints {
      $0.width.equalTo(48)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(-80)
      $0.bottom.equalToSuperview().inset(48)
      $0.height.equalTo(48)
    }
    
    markdownButton.snp.makeConstraints {
      $0.centerY.equalTo(buttonStackView)
      $0.leading.equalTo(buttonStackView.snp.trailing).inset(-20)
      $0.height.equalTo(48)
      $0.width.equalTo(64)
    }
    
    xmlButton.snp.makeConstraints {
      $0.centerY.equalTo(buttonStackView)
      $0.leading.equalTo(markdownButton.snp.trailing).inset(-8)
      $0.height.equalTo(48)
      $0.width.equalTo(64)
    }
  }
  
  private func setupActions() {
    headerElementButton.addAction(.init(handler: { [weak self] _ in
      self?.add(element: HeaderElement())
    }), for: .touchUpInside)
    
    boldTextElementButton.addAction(.init(handler: { [weak self] _ in
      self?.add(element: BoldTextElement())
    }), for: .touchUpInside)
    
    textElementButton.addAction(.init(handler: { [weak self] _ in
      self?.add(element: TextElement())
    }), for: .touchUpInside)
    
    markdownButton.addAction(.init(handler: { [weak self] _ in
      let markdownExporter = MarkdownExporter()
      self?.markdownElements.forEach { element in
        element.accept(visitor: markdownExporter)
      }
      
      let markdownPlainText = markdownExporter.markdown
      let vc = MarkdownPlainTextViewController(markdownText: markdownPlainText)
      self?.present(vc, animated: true)
    }), for: .touchUpInside)
    
    xmlButton.addAction(.init(handler: { [weak self] _ in
      let xmlExporter = XMLExporter()
      self?.markdownElements.forEach { element in
        element.accept(visitor: xmlExporter)
      }
      
      let markdownPlainText = xmlExporter.xml
      let vc = MarkdownPlainTextViewController(markdownText: markdownPlainText)
      self?.present(vc, animated: true)
    }), for: .touchUpInside)
    
  }
  
  func configureToolbarOnKeyboard(_ textField: UITextField) {
    let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    toolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonAction))
    let delete = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteButtonAction))
    delete.tintColor = .red
    
    var items = [UIBarButtonItem]()
    items.append(contentsOf: [flexSpace, delete, done])
    
    toolbar.items = items
    toolbar.sizeToFit()
    
    textField.inputAccessoryView = toolbar
  }
  
  @objc func doneButtonAction() {
    view.endEditing(true)
  }
  
  @objc func deleteButtonAction() {
    if let activeTextField {
      removeElement(activeTextField)
    }
  }
  
  // MARK: - Methods
  
  private func add(element: TextEditorElement) {
    markdownElements.append(element)
    
    let elementView = element.render()
    elementStackView.addArrangedSubview(elementView)
    
    element.textField.delegate = self
    configureToolbarOnKeyboard(element.textField)
    elementView.becomeFirstResponder()
  }
  
  private func removeElement(_ elementView: UIView?) {
    guard let viewToRemove = elementView else { return }
    markdownElements.removeAll(where: { $0.render() === viewToRemove })
    viewToRemove.removeFromSuperview()
  }
}

extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    add(element: TextElement())
    activeTextField = nil
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
    textField.placeholder = "내용을 입력해 주세요"
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text?.isEmpty ?? true {
      textField.placeholder = ""
    }
  }
}


// MARK: - Preview

#Preview {
  ViewController()
}
