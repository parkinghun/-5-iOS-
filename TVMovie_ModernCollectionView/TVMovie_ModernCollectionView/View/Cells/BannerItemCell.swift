//
//  BannerItemCell.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class BannerItemCell: UICollectionViewCell {
  static let id = "BannerItemCell"
  
  let thumbnailImage = UIImageView()
  lazy var stackView: UIStackView = {
    let subViews: [UIView] = [thumbnailImage, titleLabel, voteLabel, overviewLabel, emptyView]
    let sv = UIStackView(arrangedSubviews: subViews)
    sv.axis = .vertical
    sv.distribution = .fill
    sv.alignment = .fill
    sv.spacing = 8
    return sv
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.numberOfLines = 2
    return label
  }()
  
  let voteLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    return label
  }()
  
  let overviewLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.numberOfLines = 3
    return label
  }()
  
  let emptyView: UIView = {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .vertical)
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BannerItemCell {
  public func configure(with movieData: Movie) {
    let imageURL = URL(string: movieData.posterURL)
    thumbnailImage.kf.setImage(with: imageURL)
    titleLabel.text = movieData.title
    voteLabel.text = movieData.vote
    overviewLabel.text = movieData.overview
  }
  
  private func setUI() {
    self.addSubview(stackView)
  }
  
  private func setConstraints() {
    thumbnailImage.snp.makeConstraints { $0.height.equalTo(500) }
    stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}
