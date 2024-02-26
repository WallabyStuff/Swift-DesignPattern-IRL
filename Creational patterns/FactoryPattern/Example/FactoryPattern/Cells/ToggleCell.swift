//
//  ToggleCell.swift
//  FactoryPattern
//
//  Created by 이승기 on 2/26/24.
//

import UIKit
import SnapKit
import Then

final class ToggleCell: UICollectionViewCell {
  
  static let id = String(describing: ToggleCell.self)
  
  // MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 16)
  }
  
  private let toggleButton = UISwitch().then {
    $0.isOn = false
  }
  
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Public
  
  public func configure(title: String) {
    titleLabel.text = title
  }
  
  
  // MARK: - Private
  
  private func setup() {
    setupView()
    layoutView()
  }
  
  private func setupView() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(toggleButton)
  }
  
  private func layoutView() {
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
    }
    
    toggleButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
    }
  }
}

#Preview {
  let cell = ToggleCell(frame: .init(x: 0, y: 0, width: 240, height: 80))
  cell.configure(title: "Title")
  return cell
}
