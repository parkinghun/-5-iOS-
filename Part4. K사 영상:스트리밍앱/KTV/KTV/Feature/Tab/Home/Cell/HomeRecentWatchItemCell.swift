//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRecentWatchItemCell"
  
  @IBOutlet var thumbnailmageView: UIImageView!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subTitleLabel: UILabel!
  
  private var imageTask: Task<Void, Never>?
  // DateFormatter는 생성비용이 큰 컴포넌트임
  // 인스턴스가 하나만 생성되어서 계속 사용된다면 static으로 생성하여 계속 사용하는 것도 좋은 방법임 -> static이면 데이터 영역에 저장됨
  private static let dataFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYMMDD."
    
    return formatter
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupUI()
  }
  
  private func setupUI() {
    self.thumbnailmageView.layer.cornerRadius = 42
    self.thumbnailmageView.layer.borderWidth = 2
    self.thumbnailmageView.layer.borderColor = UIColor.strokeLight.cgColor
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetComponents()
  }
  
  func setData(_ data: Home.Recent) {
    self.titleLabel.text = data.title
    self.subTitleLabel.text = data.channel
    self.dateLabel.text = Self.dataFormatter.string(from: .init(timeIntervalSince1970: data.timeStamp))
    self.imageTask = self.thumbnailmageView.loadImage(url: data.imageUrl)
  }
  
  private func resetComponents() {
    self.imageTask?.cancel()
    self.imageTask = nil
    
    self.thumbnailmageView.image = nil
    self.titleLabel.text = nil
    self.subTitleLabel.text = nil
    self.dateLabel.text = nil
  }
}
