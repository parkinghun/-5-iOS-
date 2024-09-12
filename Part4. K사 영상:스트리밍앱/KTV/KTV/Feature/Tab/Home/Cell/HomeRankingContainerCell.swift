//
//  HomeRankingContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

// 선택된 이벤트를 받을 수 있도록 델리겟 처리
protocol HomeRankingContainerCellDelegate: AnyObject {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int)
}

class HomeRankingContainerCell: UITableViewCell {
  @IBOutlet var collectionView: UICollectionView!
  
  static let identifier: String = "HomeRankingContainerCell"
  static let height: CGFloat = 349
  weak var delegate: HomeRankingContainerCellDelegate?
  private var rankings: [Home.Ranking]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupCollectionView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setData(_ data: [Home.Ranking]) {
    self.rankings = data
    self.collectionView.reloadData()
  }
  
  private func setupCollectionView() {
    self.collectionView.register(
      UINib(nibName: HomeRankingItemCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: HomeRankingItemCell.identifier
    )
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
}

// MARK: - CollectionView DataSource
extension HomeRankingContainerCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.rankings?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRankingItemCell.identifier,
      for: indexPath
    ) 
    
    if let cell = cell as? HomeRankingItemCell,
       let data = self.rankings?[indexPath.item] {
      cell.setData(data, rank: indexPath.item + 1)
    }

    return cell
  }
}

// MARK: - CollectionView Delegate
extension HomeRankingContainerCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
