//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by 박성훈 on 11/9/24.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
  
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subTitleLabel: UILabel!
  
  static let id: String = "HomeRecentWatchItemCell"
  private var imageTask: Task<Void, Never>?
  
  private static let dataFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYMMDD."
    return formatter
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    resetComponents()
  }
  
  public func setData(_ data: Home.Recent) {
    titleLabel.text = data.title
    subTitleLabel.text = data.channel
    dateLabel.text = Self.dataFormatter.string(from: .init(timeIntervalSince1970: data.timeStamp))
    imageTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
  }
  
  private func setupUI() {
    thumbnailImageView.layer.cornerRadius = 42
    thumbnailImageView.layer.borderWidth = 2
    thumbnailImageView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
  }
  
  private func resetComponents() {
    imageTask?.cancel()
    imageTask = nil
    thumbnailImageView.image = nil
    titleLabel.text = nil
    subTitleLabel.text = nil
    dateLabel.text = nil
  }
  
}
