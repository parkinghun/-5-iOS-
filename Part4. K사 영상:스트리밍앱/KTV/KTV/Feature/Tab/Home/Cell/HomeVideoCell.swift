//
//  HomeVideoCell.swift
//  KTV
//
//  Created by 박성훈 on 7/30/24.
//

import UIKit

class HomeVideoCell: UITableViewCell {
  
  static let identifier: String = "HomeVideoCell"
  static let height: CGFloat = 321
  
  @IBOutlet var containerView: UIView!
  @IBOutlet var thumbnailImageView: UIImageView!
  
  @IBOutlet var hotImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subTitleLabel: UILabel!
  
  @IBOutlet var channelImageView: UIImageView!
  @IBOutlet var channelTitleLabel: UILabel!
  @IBOutlet var channelSubTitleLabel: UILabel!
  
  private var thumbnailTask: Task<Void, Never>?
  private var channelThumnailTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetComponents()
  }
  
  private func resetComponents() {
    self.thumbnailTask?.cancel()
    self.thumbnailTask = nil
    self.channelThumnailTask?.cancel()
    self.channelThumnailTask = nil
    
    self.thumbnailImageView.image = nil
    self.titleLabel.text = nil
    self.subTitleLabel.text = nil
    self.channelTitleLabel.text = nil
    self.channelImageView.image = nil
    self.channelSubTitleLabel.text = nil
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func setData(_ data: Home.Video) {
    self.titleLabel.text = data.title
    self.subTitleLabel.text = data.subtitle
    self.channelTitleLabel.text = data.channel
    self.channelSubTitleLabel.text = data.channelDescription
    self.hotImageView.isHidden = !data.isHot
    self.thumbnailTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
    self.channelThumnailTask = self.channelImageView.loadImage(url: data.channelThumbnailURL)
  }
  
  private func setupUI() {
    self.containerView.layer.cornerRadius = 10
    self.containerView.layer.borderColor = UIColor.strokeLight.cgColor
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.masksToBounds = true  // 레이어에 대한 configuration을 적용했는데 제대로 작동하지 않으면 ㄱㄱ
  }
  
}
