//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRankingItemCell"
  
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var numberLabel: UILabel!
  private var imageTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetComponents()
  }
  
  func setData(_ data: Home.Ranking, rank: Int) {
    self.numberLabel.text = "\(rank)"
    self.imageTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
  }
  
  private func setupUI() {
    self.layer.cornerRadius = 10
  }
  
  private func resetComponents() {
    self.imageTask?.cancel()
    self.imageTask = nil
    self.numberLabel.text = nil
    self.thumbnailImageView.image = nil
  }
}
