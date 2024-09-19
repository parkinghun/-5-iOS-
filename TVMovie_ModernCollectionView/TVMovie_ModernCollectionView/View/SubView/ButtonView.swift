//
//  ButtonView.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import UIKit
import SnapKit

final class ButtonView: UIView {
  let tvButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("TV", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.layer.masksToBounds = true
    bt.layer.cornerRadius = 8
    bt.configuration = .bordered()
    return bt
  }()
  
  let movieButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("Movie", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.layer.masksToBounds = true
    bt.layer.cornerRadius = 8
    bt.configuration = .bordered()
    return bt
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.backgroundColor = .white
    self.addSubview(tvButton)
    self.addSubview(movieButton)
  }
  
  private func setConstraints() {
    tvButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
    }
    
    movieButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(tvButton.snp.trailing).offset(10)
    }
  }
}
