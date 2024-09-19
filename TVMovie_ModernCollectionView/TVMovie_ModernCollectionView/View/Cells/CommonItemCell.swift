//
//  commonItemCell.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CommonItemCell: UICollectionViewCell {
  static let id: String = "CommonItemCell"
  
  let thumbnailImage: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  let stackView: UIStackView = {
    let sv = UIStackView()
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
    label.numberOfLines = 2
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
    setupConstraints()
  }
  
  func configure(commonItem: CommonItem) {
    let imageURL = URL(string: commonItem.thumbnailURL)
    self.thumbnailImage.kf.setImage(with: imageURL)
    self.titleLabel.text = commonItem.title
    self.voteLabel.text = commonItem.vote
    self.overviewLabel.text = commonItem.overview
  }
  
  private func setUI() {
    self.addSubview(stackView)
    stackView.addArrangedSubview(thumbnailImage)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(voteLabel)
    stackView.addArrangedSubview(overviewLabel)
    stackView.addArrangedSubview(emptyView)
  }
  
  private func setupConstraints() {
    thumbnailImage.snp.makeConstraints { make in
      make.height.equalTo(140)
    }
    
    stackView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
