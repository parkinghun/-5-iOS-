//
//  RevieContentCell.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/23/24.
//

import UIKit
import SnapKit

final class ReviewContentCell: UICollectionViewCell {
  static let id = "ReviewContentCell"
  
  let contentLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.numberOfLines = 0
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
  
  public func configure(content: String) {
    self.contentLabel.text = content
  }
  
  private func setUI() {
    self.addSubview(contentLabel)
  }
  
  private func setConstraints() {
    contentLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(20)
      make.leading.trailing.equalToSuperview().inset(14)
    }
  }
}
