//
//  ReviewHeaderCell.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ReviewHeaderCell: UICollectionViewCell {
  static let id = "ReviewHeaderCell"
  
  let userImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.clipsToBounds = true
    imgView.layer.cornerRadius = 8
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .regular)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(name: String, imageURL: String) {
    userImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(systemName: "person.fill"))
    nameLabel.text = name
  }
  
  private func setUI() {
    self.addSubview(userImageView)
    self.addSubview(nameLabel)
  }
    
  private func setConstraints() {
    self.snp.makeConstraints { $0.height.equalTo(44) }
    
    userImageView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.3)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(userImageView.snp.trailing).offset(8)
      make.centerY.equalToSuperview()
    }
  }
}
