//
//  HomeVideoCell.swift
//  KTV
//
//  Created by 박성훈 on 11/6/24.
//

import UIKit

class HomeVideoCell: UICollectionViewCell {
  
  @IBOutlet var containerView: UIView!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var hotImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subTitleLabel: UILabel!

  @IBOutlet var channelImageView: UIImageView!
  @IBOutlet var channelTitleLabel: UILabel!
  @IBOutlet var channelSubTitleLabel: UILabel!
  
  static let id: String = "HomeVideoCell"
  static let height: CGFloat = 321
  
  private var thumbnailTask: Task<Void, Never>?
  private var channelThumbnailTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    resetComponents()
  }
  
  public func setData(_ data: Home.Video) {
    titleLabel.text = data.title
    subTitleLabel.text = data.subtitle
    channelTitleLabel.text = data.channel
    channelSubTitleLabel.text = data.channelDescription
    hotImageView.isHidden = !data.isHot
    thumbnailTask = thumbnailImageView.loadImage(url: data.imageUrl)
    channelThumbnailTask = channelImageView.loadImage(url: data.channelThumbnailURL)
  }
  
  private func setupUI() {
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 8
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    channelImageView.layer.cornerRadius = 10
  }
  
  private func resetComponents() {
    thumbnailTask?.cancel()
    thumbnailTask = nil
    channelThumbnailTask?.cancel()
    channelThumbnailTask = nil
    
    thumbnailImageView.image = nil
    titleLabel.text = nil
    subTitleLabel.text = nil
    channelTitleLabel.text = nil
    channelImageView.image = nil
    channelSubTitleLabel.text = nil
  }  
}
