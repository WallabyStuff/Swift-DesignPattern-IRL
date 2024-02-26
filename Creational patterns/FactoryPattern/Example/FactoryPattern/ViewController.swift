//
//  ViewController.swift
//  FactoryPattern
//
//  Created by 이승기 on 2/26/24.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
  
  let settingItems: [SettingItem] = [
    ToggleItem(title: "Night Mode"),
    ToggleItem(title: "Sound & Haptics"),
    ToggleItem(title: "Privacy"),
    ToggleItem(title: "Bluetooth"),
    NavigationItem(title: "Notifications"),
    NavigationItem(title: "Display & Brightness"),
    NavigationItem(title: "General"),
    NavigationItem(title: "Battery"),
    NavigationItem(title: "WIFI"),
    ToggleItem(title: "Accessibility")
  ]
  
  
  let cellFactory = CellFactory()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  // MARK: - Methods
  
  private func setup() {
    setupView()
    setupLayout()
  }
  
  private func setupView() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ToggleCell.self, forCellWithReuseIdentifier: ToggleCell.id)
    collectionView.register(NavigationCell.self, forCellWithReuseIdentifier: NavigationCell.id)
  }
  
  private func setupLayout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(60)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(60)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
}


// MARK: - CollectionView Delegates

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settingItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = settingItems[indexPath.row]
    return cellFactory.createCell(for: item, collectionView: collectionView, indexPath: indexPath)
  }
}
