//
//  HomeRecentWatchContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 11/8/24.
//

import UIKit

protocol HomeRecentWatchContainerCellDelegate: AnyObject {
  func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UICollectionViewCell {
  @IBOutlet var collectionView: UICollectionView!
  
  static let id: String = "HomeRecentWatchContainerCell"
  static let height: CGFloat = 209
  private var recents: [Home.Recent]?
  weak var delegate: HomeRecentWatchContainerCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupCollectionView()
  }
    
  public func setData(_ data: [Home.Recent]) {
    self.recents = data
    self.collectionView.reloadData()
  }
 
  private func setupCollectionView() {
    self.collectionView.clipsToBounds = true
    self.collectionView.layer.cornerRadius = 10
    self.collectionView.layer.borderWidth = 1
    self.collectionView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    self.collectionView.register(
      UINib(nibName: HomeRecentWatchItemCell.id, bundle: .main),
      forCellWithReuseIdentifier: HomeRecentWatchItemCell.id
    )
  }
}

// MARK: - CollectionView DataSource
extension HomeRecentWatchContainerCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recents?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentWatchItemCell.id, for: indexPath)
    
    if let cell = cell as? HomeRecentWatchItemCell,
       let data = recents?[indexPath.item] {
      cell.setData(data)
    }
    
    return cell
  }
}

// MARK: - CollectionView Delegate
extension HomeRecentWatchContainerCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
