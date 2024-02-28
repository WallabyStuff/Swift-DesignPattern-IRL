//
//  AppleMapAdapter.swift
//  Adapter
//
//  Created by 이승기 on 2/28/24.
//

import UIKit
import SnapKit

import MapKit

final class AppleMapAdapter: MapService {
  
  private let mapView = MKMapView()
  
  func draw(in viewController: UIViewController) {
    viewController.view.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func moveCamera(lat: Double, lng: Double) {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                    latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(region, animated: true)
  }

  func addMarker(lat: Double, lng: Double) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    annotation.title = "부산"
    annotation.subtitle = "떠나자 부산으로!"

    mapView.addAnnotation(annotation)
  }
}
