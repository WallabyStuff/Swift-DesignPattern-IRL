//
//  MapService.swift
//  Adapter
//
//  Created by 이승기 on 2/28/24.
//

import UIKit

protocol MapService {
  func draw(in viewController: UIViewController)
  func moveCamera(lat: Double, lng: Double)
  func addMarker(lat: Double, lng: Double)
}
