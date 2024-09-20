//
//  ContentDetailView.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/20/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ContentDetailViewController: UIViewController {
  let thumbnailImageView = UIImageView()
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.numberOfLines = 2
    return label
  }()
  
  let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  let overviewLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.numberOfLines = 0
    return label
  }()
  
  let voteLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  let reviewButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("리뷰: ", for: .normal)
    bt.setTitleColor(.black, for: .normal)
    bt.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    return bt
  }()
  
  override func viewDidLoad() {
    setUI()
    setConstraints()
  }
}

// MARK: - Methods
extension ContentDetailViewController {
  public func configure(with commonData: CommonItem) {
    self.thumbnailImageView.kf.setImage(with: URL(string: commonData.thumbnailURL))
    self.titleLabel.text = commonData.title
    self.releaseDateLabel.text = "개봉일:  \(commonData.releaseDate)"
    self.voteLabel.text = "⭐️ \(commonData.vote)"
    self.overviewLabel.text = commonData.overview
  }
  
  public func configure(with movieData: Movie) {
    self.thumbnailImageView.kf.setImage(with: URL(string: movieData.posterURL))
    self.titleLabel.text = movieData.title
    self.releaseDateLabel.text = "개봉일:  \(movieData.releaseDate)"
    self.voteLabel.text = "⭐️ \(movieData.vote)"
    self.overviewLabel.text = movieData.overview
  }
  
  private func setUI() {
    self.view.backgroundColor = .white

    self.view.addSubview(thumbnailImageView)
    self.view.addSubview(titleLabel)
    self.view.addSubview(releaseDateLabel)
    self.view.addSubview(voteLabel)
    self.view.addSubview(overviewLabel)
    self.view.addSubview(separatorView)
  }
  
  private func setConstraints() {
    thumbnailImageView.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(300)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
    }
    
    releaseDateLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
    }
    
    voteLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(12)
      make.top.equalTo(releaseDateLabel.snp.top)
    }
    
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(releaseDateLabel.snp.bottom).offset(20)
    }
    
    overviewLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().inset(12)
      make.top.equalTo(separatorView.snp.bottom).offset(20)
    }
  }
}
