//
//  HomeRankingContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 11/8/24.
//

import UIKit

protocol HomeRankingContainerCellDelegate: AnyObject {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int)
}

class HomeRankingContainerCell: UICollectionViewCell {
  
  @IBOutlet var collectionView: UICollectionView!
  
  static let id: String = "HomeRankingContainerCell"
  static let height: CGFloat = 265
  
  weak var delegate: HomeRankingContainerCellDelegate?
  private var rankings: [Home.Ranking]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupCollectionView()
  }
  
  func setData(_ data: [Home.Ranking]) {
    self.rankings = data
    self.collectionView.reloadData()
  }
  
  private func setupCollectionView() {
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    self.collectionView.register(
      UINib(nibName: HomeRankingItemCell.id, bundle: nil),
      forCellWithReuseIdentifier: HomeRankingItemCell.id
    )
  }
  
}

// MARK: - TableView DataSource
extension HomeRankingContainerCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return rankings?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRankingItemCell.id, for: indexPath)
     
    if let cell = cell as? HomeRankingItemCell,
       let data = self.rankings?[indexPath.item] {
      cell.setData(data, rank: indexPath.item + 1)
    }
    return cell
  }
}

// MARK: - TableView Delegate
extension HomeRankingContainerCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
