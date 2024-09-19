//
//  VerticalItemCell.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class VerticalItemCell: UICollectionViewCell {
  static let id = "VerticalItemCell"
  
  let thumbnailImage: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  lazy var stackView: UIStackView = {
    let subViews: [UIView] = [titleLabel, releaseDateLabel, emptyView]
    let sv = UIStackView(arrangedSubviews: subViews)
    sv.axis = .vertical
    sv.distribution = .fill
    sv.alignment = .fill
    sv.spacing = 4
    return sv
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
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

extension VerticalItemCell {
  public func configure(with movieData: Movie) {
    let imageURL = URL(string: movieData.posterURL)
    self.thumbnailImage.kf.setImage(with: imageURL)
    self.titleLabel.text = movieData.title
    self.releaseDateLabel.text = movieData.releaseDate 
  }
  
  private func setUI() {
    self.addSubview(thumbnailImage)
    self.addSubview(stackView)
  }
  
  private func setConstraints() {
    thumbnailImage.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.3)
      make.leading.top.bottom.equalToSuperview()
    }
    
    stackView.snp.makeConstraints { make in
      make.top.bottom.trailing.equalToSuperview()
      make.leading.equalTo(thumbnailImage.snp.trailing).offset(8)
    }
  }
}
