//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 박성훈 on 11/9/24.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var numberLabel: UILabel!
  
  static let id: String = "HomeRankingItemCell"
  private var imageTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    resetComponents()
  }
  
  public func setData(_ data: Home.Ranking, rank: Int) {
    numberLabel.text = "\(rank)"
    imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
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
