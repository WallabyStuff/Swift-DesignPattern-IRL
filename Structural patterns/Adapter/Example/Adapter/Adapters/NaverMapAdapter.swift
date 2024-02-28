//
//  NaverMapAdapter.swift
//  Adapter
//
//  Created by 이승기 on 2/28/24.
//

import UIKit
import SnapKit

import NMapsMap

final class NaverMapAdapter: MapService {
  
  private let mapView = NMFMapView()
  
  func draw(in viewController: UIViewController) {
    viewController.view.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func moveCamera(lat: Double, lng: Double) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 9)
    cameraUpdate.animation = .easeIn
    mapView.moveCamera(cameraUpdate)
  }
  
  func addMarker(lat: Double, lng: Double) {
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: lat, lng: lng)
    marker.mapView = mapView
  }
}
