//
//  MapViewController.swift
//  Adapter
//
//  Created by 이승기 on 2/28/24.
//

import UIKit
import SnapKit
import Then

class MapViewController: UIViewController {
  
  private let moveButton = UIButton().then {
    $0.setTitle("🚢 부산으로 이동", for: .normal)
    $0.backgroundColor = .white
    $0.setTitleColor(.black, for: .normal)
    $0.layer.cornerRadius = 10
  }
  
  private let addMarkerButton = UIButton().then {
    $0.setTitle("📍 마커 추가", for: .normal)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 10
  }
  
  private let mapService: MapService // 다른 MapService를 주입 받으면 별다른 작업 없이 그걸 그대로 사용 가능
  
  init(mapService: MapService) {
    self.mapService = mapService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapService.draw(in: self)
    setupView()
    setupAction()
  }
  
  private func setupView() {
    view.addSubview(moveButton)
    moveButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(40)
      $0.left.right.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
    view.addSubview(addMarkerButton)
    addMarkerButton.snp.makeConstraints {
      $0.bottom.equalTo(moveButton.snp.top).offset(-12)
      $0.left.right.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
  }
  
  private func setupAction() {
    let lat: Double = 35.166668
    let lng: Double = 129.066666
    
    // Move button Action
    moveButton.addAction(.init(handler: { [weak self] _ in
      self?.mapService.moveCamera(lat: lat, lng: lng)
    }), for: .touchUpInside)
    
    // Add marker button action
    addMarkerButton.addAction(.init(handler: { [weak self] _ in
      self?.mapService.addMarker(lat: lat, lng: lng)
    }), for: .touchUpInside)
  }
}

#Preview {
  MapViewController(mapService: AppleMapAdapter()) // 이걸 AppleMapAdapter로 변경해서도 프리뷰 빌드해 보세요!
}
