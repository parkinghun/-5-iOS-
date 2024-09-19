//
//  ButtonView.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import UIKit
import SnapKit
import RxSwift

final class ButtonView: UIView {
  private let viewModel = MainViewModel()
  private var disposeBag = DisposeBag()
  
  var tvTrigger = BehaviorSubject<Int>(value: 1)
  var movieTrigger = PublishSubject<Void>()
  
  let tvButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("TV", for: .normal)
    bt.setTitleColor(.white, for: .normal)
    bt.backgroundColor = .systemGreen
    bt.layer.masksToBounds = true
    bt.layer.cornerRadius = 8
    bt.configuration = .bordered()
    return bt
  }()
  
  let movieButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("Movie", for: .normal)
    bt.setTitleColor(.label, for: .normal)
    bt.backgroundColor = .systemGray
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
  
  public func setButtonBackgroundColor(isTvButtonTapped: Bool) {
    self.tvButton.backgroundColor = isTvButtonTapped ? .systemGreen : .systemGray
    self.tvButton.setTitleColor(isTvButtonTapped ? .white : .label , for: .normal)
    
    self.movieButton.backgroundColor = isTvButtonTapped ? .systemGray : .systemGreen
    self.movieButton.setTitleColor(isTvButtonTapped ? .label : .white, for: .normal)
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
