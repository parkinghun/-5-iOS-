//
//  ContentDetailView.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/20/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

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
  
  let reviewButton: UIButton = {
    let bt = UIButton()
    bt.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    bt.setTitleColor(.black, for: .normal)
    bt.setTitleColor(.blue, for: .highlighted)
    return bt
  }()
  
  var disposeBag = DisposeBag()
  var reviewTrigger: Observable<Void>?
  let id: Int
  let contentType: ContentType
  
  override func viewDidLoad() {
    setUI()
    setConstraints()
    bindViewModel()
  }
  
  init(id: Int, contentType: ContentType) {
    self.id = id
    self.contentType = contentType
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Methods
extension ContentDetailViewController {
  public func configure(with commonData: MediaContent) {
    self.thumbnailImageView.kf.setImage(with: URL(string: commonData.posterURL))
    self.titleLabel.text = commonData.title
    self.releaseDateLabel.text = "개봉일: \(commonData.releaseDate)"
    self.reviewButton.setTitle("⭐️ \(commonData.vote)", for: .normal)
    self.overviewLabel.text = commonData.overview
  }
  
  public func configure(with movieData: Movie) {
    self.thumbnailImageView.kf.setImage(with: URL(string: movieData.posterURL))
    self.titleLabel.text = movieData.title
    self.releaseDateLabel.text = "개봉일: \(movieData.releaseDate)"
    self.reviewButton.setTitle("⭐️ \(movieData.vote)", for: .normal)
    self.overviewLabel.text = movieData.overview
  }
  
  private func bindViewModel() {
    reviewButton.rx.tap.bind { [weak self] _ in
      guard let self = self else { return }
      print("ReviewButton Tapped")
      
      let reviewVC = ReviewViewController(id: self.id, contentType: self.contentType)
      self.present(reviewVC, animated: true)
      
    }.disposed(by: disposeBag)
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(thumbnailImageView)
    self.view.addSubview(titleLabel)
    self.view.addSubview(releaseDateLabel)
    self.view.addSubview(reviewButton)
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
    
    reviewButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(12)
      make.top.equalTo(releaseDateLabel.snp.top)
    }
    
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.leading.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().inset(12)
      make.top.equalTo(releaseDateLabel.snp.bottom).offset(20)
    }
    
    overviewLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.trailing.equalToSuperview().inset(12)
      make.top.equalTo(separatorView.snp.bottom).offset(20)
    }
  }
}
