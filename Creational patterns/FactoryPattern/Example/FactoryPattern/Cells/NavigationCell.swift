//
//  NavigationCell.swift
//  FactoryPattern
//
//  Created by 이승기 on 2/26/24.
//

import UIKit
import SnapKit
import Then

final class NavigationCell: UICollectionViewCell {
  
  static let id = String(describing: NavigationCell.self)
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 16)
  }
  
  private let chevronImageView = UIImageView().then {
    $0.image = UIImage(systemName: "chevron.right") // SF Symbols를 사용합니다. 커스텀 이미지로 변경 가능
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .gray // 이미지 색상 조정
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
    contentView.addSubview(chevronImageView)
  }
  
  private func layoutView() {
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
    }
    
    chevronImageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
      make.width.equalTo(20) // Chevron 이미지의 너비 설정
      make.height.equalTo(20) // Chevron 이미지의 높이 설정
    }
  }
}

#Preview {
  let cell = NavigationCell(frame: .init(x: 0, y: 0, width: 220, height: 80))
  cell.configure(title: "Title")
  return cell
}
