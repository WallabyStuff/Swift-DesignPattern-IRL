//
//  CellFactory.swift
//  FactoryPattern
//
//  Created by 이승기 on 2/26/24.
//

import UIKit

final class CellFactory {
  func createCell(for item: SettingItem, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    if type(of: item) == ToggleItem.self {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.id, for: indexPath) as! ToggleCell
      cell.configure(title: item.title)
      return cell
      
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCell.id, for: indexPath) as! NavigationCell
      cell.configure(title: item.title)
      return cell
    }
  }
}
