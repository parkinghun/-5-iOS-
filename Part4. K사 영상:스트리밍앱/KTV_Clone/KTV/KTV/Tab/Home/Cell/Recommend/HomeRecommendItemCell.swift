//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 박성훈 on 11/9/24.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
  
  @IBOutlet var thumbnailContainerView: UIView!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var rankLabel: UILabel!
  @IBOutlet var playTimeBGView: UIView!
  @IBOutlet var playTimeLabel: UILabel!
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  
  static let id: String = "HomeRecommendItemCell"
  static let height: CGFloat = 71
  
  private var imageTask: Task<Void, Never>?
  private static let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter
  }()
    
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    resetComponents()
  }
  
  public func setData(_ data: Home.Recommend, rank: Int?) {
    rankLabel.isHidden = rank == nil
    
    if let rank {
      rankLabel.text = "\(rank)"
    }
    
    titleLabel.text = data.title
    descriptionLabel.text = data.channel
    playTimeLabel.text = Self.timeFormatter.string(from: data.playtime)
    imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
  }
  
  private func setupUI () {
    thumbnailImageView.layer.cornerRadius = 5
    rankLabel.clipsToBounds = true
    rankLabel.layer.cornerRadius = 5
    playTimeBGView.layer.cornerRadius = 3
  }
  
  private func resetComponents() {
    imageTask?.cancel()
    imageTask = nil
    
    titleLabel.text = nil
    descriptionLabel.text = nil
    thumbnailImageView.image = nil
    playTimeLabel.text = nil
    rankLabel.text = nil
  }
}
