//
//  HeaderView.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/19/24.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
  static let id = "HeaderView"
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 30, weight: .bold)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HeaderView {
  public func configure(title: String) {
    self.titleLabel.text = title
  }
  
  private func setUI() {
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}
