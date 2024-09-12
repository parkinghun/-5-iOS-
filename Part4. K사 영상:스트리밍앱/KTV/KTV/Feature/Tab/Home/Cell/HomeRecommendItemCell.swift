//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
  
  static let height: CGFloat = 71
  static let identifier: String = "HomeRecommendItemCell"
  
  @IBOutlet var thumbnailContainerView: UIView!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var rankLabel: UILabel!
  @IBOutlet var playTimeBGView: UIView!
  @IBOutlet var playTimeLabel: UILabel!
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  
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
    self.setupUI()
  }
  
//  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
  
  private func setupUI() {
    self.thumbnailContainerView.layer.cornerRadius = 5
    self.rankLabel.layer.cornerRadius = 5
    self.rankLabel.clipsToBounds = true  // 레이블의 경우 layer 설정할 때 clipsToBounds를 해줘야 함
    self.playTimeBGView.layer.cornerRadius = 3
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetComponents()
  }
  
  func setData(_ data: Home.Recommend, rank: Int?) {
    self.rankLabel.isHidden = rank == nil
    
    if let rank {
      self.rankLabel.text = "\(rank)"
    }
    
    self.titleLabel.text = data.title
    self.descriptionLabel.text = data.channel
    self.playTimeLabel.text = Self.timeFormatter.string(from: data.playtime)
    self.imageTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
  }
  
  private func resetComponents() {
    self.imageTask?.cancel()
    self.imageTask = nil
    
    self.titleLabel.text = nil
    self.descriptionLabel.text = nil
    self.thumbnailImageView.image = nil
    self.playTimeLabel.text = nil
    self.rankLabel.text = nil
  }
}
