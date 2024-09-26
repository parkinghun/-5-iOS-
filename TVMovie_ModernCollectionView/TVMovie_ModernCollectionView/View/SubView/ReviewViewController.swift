//
//  ReviewViewController.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

fileprivate enum Section {
  case list
}

fileprivate enum Item: Hashable {
  case header(ReviewHeader)
  case content(String)
}

fileprivate struct ReviewHeader: Hashable {
  let id: String
  let name: String
  let url: String
}

final class ReviewViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let viewModel: ReviewViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  lazy var headerLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.text = "\(viewModel.contentType == .tv ? "TV" : "Movie") 리뷰"
    return label
  }()
  
  let collectionView: UICollectionView = {
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: config)
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(ReviewHeaderCell.self, forCellWithReuseIdentifier: ReviewHeaderCell.id)
    cv.register(ReviewContentCell.self, forCellWithReuseIdentifier: ReviewContentCell.id)
    return cv
  }()
  
  let emptyReivewNoticLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20)
    label.text = "해당 콘텐츠에 대한 리뷰가 없습니다."
    label.textColor = .black
    label.isHidden = true
    return label
  }()
  
  init(id: Int, contentType: ContentType) {
    self.viewModel = ReviewViewModel(id: id, contentType: contentType)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setConstraints()
    setDataSource()
    bindView()
    bindViewModel()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(headerLabel)
    self.view.addSubview(collectionView)
    self.view.addSubview(emptyReivewNoticLabel)
  }
  
  private func setConstraints() {
    headerLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(12)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(headerLabel.snp.bottom).offset(12)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    emptyReivewNoticLabel.snp.makeConstraints { $0.center.equalToSuperview() }
  }
  
  private func bindView() {
    collectionView.rx.itemSelected.bind { [weak self] indexPath in
      guard let self = self,
            let item = self.dataSource.itemIdentifier(for: indexPath),
            var sectionSnapshot = self.dataSource?.snapshot(for: .list) else { return }
      
      if case .header(let reviewHeader) = item {
        if sectionSnapshot.isExpanded(item) {
          sectionSnapshot.collapse([item])
        } else {
          sectionSnapshot.expand([item])
        }
        dataSource.apply(sectionSnapshot, to: .list)
      }
    }.disposed(by: disposeBag)
  }

  private func bindViewModel() {
    let output = viewModel.transform(input: ReviewViewModel.Input())
    output.reviewResult.map { [unowned self] result -> [Review] in
      switch result {
      case .success(let reviewList):
        return reviewList
      case .failure(let error):
        print(#fileID, #function, #line, "- Error 발생", error)
        self.emptyReivewNoticLabel.isHidden = true
        return []
      }
    }.bind { [weak self] reviewList in
      guard let self = self else { return }
      guard !reviewList.isEmpty else {
        emptyReivewNoticLabel.isHidden = false
        return
      }
      
      var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
      reviewList.forEach { review in
        let header = ReviewHeader(
          id: review.id,
          name: review.author.name.isEmpty ? review.author.username : review.author.name,
          url: review.author.avatarURL
        )
        
        let headerItem = Item.header(header)
        let contentItem = Item.content(review.content)
        sectionSnapshot.append([headerItem])
        sectionSnapshot.append([contentItem], to: headerItem)
      }
      self.dataSource.apply(sectionSnapshot, to: .list)
    }.disposed(by: disposeBag)
  }
  
  private func setDataSource() {
    self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
      switch item {
      case .header(let reviewHeader):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHeaderCell.id, for: indexPath) as? ReviewHeaderCell
        cell?.configure(name: reviewHeader.name, imageURL: reviewHeader.url)
        return cell
      case .content(let content):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewContentCell.id, for: indexPath) as? ReviewContentCell
        cell?.configure(content: content)
        return cell
      }
    })
    
    var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    dataSourceSnapshot.appendSections([.list])
    dataSource.apply(dataSourceSnapshot)
  }
}
