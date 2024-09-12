//
//  HomeRecentWatchContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

protocol HomeRecentWatchContainerCellDelegate: AnyObject {
  func homeRecentWathContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UITableViewCell {
  
  static let identifier: String = "HomeRecentWatchContainerCell"
  static let height: CGFloat = 209
  
  @IBOutlet var collectionView: UICollectionView!
  weak var delegate: HomeRecentWatchContainerCellDelegate?
  private var recents: [Home.Recent]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupCollectionView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setData(_ data: [Home.Recent]) {
    self.recents = data
    self.collectionView.reloadData()
  }
  
  private func setupCollectionView() {
    // layer
    self.collectionView.layer.cornerRadius = 10
    self.collectionView.layer.borderWidth = 1
    self.collectionView.layer.borderColor = UIColor.strokeLight.cgColor
    
    // register
    self.collectionView.register(
      UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
    )
    
    // delegate
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
}

// MARK: - UICollectionView DataSource
extension HomeRecentWatchContainerCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recents?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRecentWatchItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRecentWatchItemCell,
       let data = self.recents?[indexPath.item] {
      cell.setData(data)
    }
    
    return cell
  }
}

// MARK: - UICollectionView Delegate
extension HomeRecentWatchContainerCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRecentWathContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
