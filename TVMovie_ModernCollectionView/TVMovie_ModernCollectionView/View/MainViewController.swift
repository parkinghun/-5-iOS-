//
//  ViewController.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 레이아웃 기준
fileprivate enum Section: Hashable {
  case tvTopRated
  case movieNowPlaying
  case moviePopular(header: String = "Popular Movies")
  case movieUpcoming(header: String = "Upcoming Movies")
}

fileprivate enum Item: Hashable {
  case commonItem(MediaContent)
  case bannerItem(Movie)
  case verticalItem(Movie)
}

// TODO: - Modern CollectionView 구현하기
/*
 ✅ 1. 섹션, 아이템 정의
 ✅ 2. 컬렉션뷰 / Cell UI / Cell 등록
 ✅ 3. Layout 구현
 ✅ 4. datasource -> Cell provider
 ✅ 5. snapshot -> dataSource.apply(snapshot)
 */

class MainViewController: UIViewController {
  let viewModel = MainViewModel()
  let buttonView = ButtonView()
  var disposeBag = DisposeBag()
  private var datasource: UICollectionViewDiffableDataSource<Section, Item>?
  
  var tvTrigger = BehaviorSubject<Int>(value: 1)
  var movieTrigger = PublishSubject<Void>()
  
  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    cv.register(CommonItemCell.self, forCellWithReuseIdentifier: CommonItemCell.id)
    cv.register(BannerItemCell.self, forCellWithReuseIdentifier: BannerItemCell.id)
    cv.register(VerticalItemCell.self, forCellWithReuseIdentifier: VerticalItemCell.id)
    cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    return cv
  }()
  
  private lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [contentSearchtextField, buttonView])
    sv.axis = .vertical
    sv.alignment = .fill
    sv.distribution = .fill
    sv.spacing = 8
    return sv
  }()
  
  private let contentSearchtextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.gray.cgColor
    textField.layer.cornerRadius = 8
    
    let leftView = UIView(frame: CGRectMake(0, 0, 40, 20))
    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    imageView.tintColor = .black
    imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
    
    leftView.addSubview(imageView)
    textField.leftView = leftView
    textField.leftViewMode = .always
    textField.placeholder = "컨텐츠를 검색하세요"
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setConstraints()
    bindViewModel()
    bindView()
    setDatasource()
    setTVTopRatedFirst()
  }
  
  private func setTVTopRatedFirst() {
    self.tvTrigger.onNext(1)
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(stackView)
    self.view.addSubview(collectionView)
  }
  
  private func setConstraints() {
    let safeArea = self.view.safeAreaLayoutGuide
    stackView.snp.makeConstraints { $0.top.leading.trailing.equalTo(safeArea).inset(14) }
    contentSearchtextField.snp.makeConstraints { $0.height.equalTo(44) }
    buttonView.snp.makeConstraints { $0.height.equalTo(80) }
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(buttonView.snp.bottom)
    }
  }
  
  private func bindView() {
    buttonView.tvButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.tvTrigger.onNext(1)
      self.contentSearchtextField.isHidden = false
      buttonView.setButtonBackgroundColor(isTvButtonTapped: true)
    }.disposed(by: disposeBag)
    
    buttonView.movieButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.movieTrigger.onNext(Void())
      buttonView.setButtonBackgroundColor(isTvButtonTapped: false)
      self.contentSearchtextField.isHidden = true
    }.disposed(by: disposeBag)
    
    collectionView.rx.itemSelected.bind { [weak self] indexPath in
      guard let self = self else { return }
      let item = self.datasource?.itemIdentifier(for: indexPath)
      
      switch item {
      case .commonItem(let mediaContent):
        let vc = ContentDetailViewController(id: mediaContent.id, contentType: mediaContent.contentType)
        vc.configure(with: mediaContent)
        self.navigationController?.present(vc, animated: true)
      case .bannerItem(let movieData),
          .verticalItem(let movieData):
        let vc = ContentDetailViewController(id: movieData.id, contentType: movieData.contentType)
        vc.configure(with: movieData)
        self.navigationController?.present(vc, animated: true)
      default: break
      }
    }.disposed(by: disposeBag)
    
    // 새로운 아이템을 로드하기 전에 미리 데이터를 불러오는 역할을 한다.
    collectionView.rx.prefetchItems
      .filter { [weak self] _ in
        guard let self = self,
              self.viewModel.currentContentType == .tv else { return false }
        return true
      }
      .bind { [weak self] indexPath in
        guard let self = self else { return }
        
        let snapshot = self.datasource?.snapshot()
        
        guard let lastIndexPath = indexPath.last,
              let section = self.datasource?.sectionIdentifier(for: lastIndexPath.section),
              let numberOfItems = snapshot?.numberOfItems(inSection: section),
              let currentPage = try? self.tvTrigger.value() else { return }
        
        if lastIndexPath.row > numberOfItems - 2 {
          print("Fetch@")
          self.tvTrigger.onNext(currentPage + 1)
        }
      }.disposed(by: disposeBag)
  }
  
  // TODO: - 텍스트필드에 검색 시 네트워킹 작업을 통해 뷰에 보여주기
  private func bindViewModel() {
    let input = MainViewModel.Input(
      tvTrigger: tvTrigger.asObservable(),
      movieTrigger: movieTrigger.asObservable(),
      searchTrigger: contentSearchtextField.rx.text.orEmpty.distinctUntilChanged()
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .map({ [weak self] in
          guard let self = self else { return "" }
          self.tvTrigger.onNext(1)
          return $0
        })
    )
    
    let output = viewModel.transform(input: input)
    
    output.tvList
      .observe(on: MainScheduler.instance)
      .bind { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let tvList):
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let section = Section.tvTopRated
        let items = tvList.map { Item.commonItem( MediaContent(from: $0)) }
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        self.datasource?.apply(snapshot)
        
      case .failure(let error):
        let alert = UIAlertController(title: "에러 발생", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
      }
    }.disposed(by: disposeBag)
    
    output.movieResults
      .observe(on: MainScheduler.instance)
      .bind { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let movieResults):
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let nowPlayingSection = Section.movieNowPlaying
        let popularSection = Section.moviePopular(header: "Popular Movies")
        let upcomingSection = Section.movieUpcoming(header: "Upcoming Movies")
        
        let bannerItem = movieResults.nowPlaying.results
          .map { Item.bannerItem($0) }
        let commonItem = movieResults.popular.results
          .map { Item.commonItem(MediaContent(from: $0)) }
        let verticalItem = movieResults.upcoming.results
          .map { Item.verticalItem($0) }
        
        snapshot.appendSections([nowPlayingSection, popularSection, upcomingSection])
        snapshot.appendItems(bannerItem, toSection: nowPlayingSection)
        snapshot.appendItems(commonItem, toSection: popularSection)
        snapshot.appendItems(verticalItem, toSection: upcomingSection)
        
        self.datasource?.apply(snapshot)
      case .failure(let error):
        let alert = UIAlertController(title: "에러 발생", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
      }
    }.disposed(by: disposeBag)
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 14
    
    return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
      let section = self?.datasource?.sectionIdentifier(for: sectionIndex)
      switch section {
      case .tvTopRated:
        return self?.createTVTopRatedSection()
      case .movieNowPlaying:
        return self?.createMovieNowPlayingSection()
      case .moviePopular:
        return self?.createMoviePopularSection()
      case .movieUpcoming:
        return self?.createMovieUpcomingSection()
      default:
        return self?.createTVTopRatedSection()
        
      }
      
    }, configuration: config)
  }
  
  private func createTVTopRatedSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .absolute(300)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  private func createMovieNowPlayingSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(640)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    return section
  }
  
  private func createMoviePopularSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.4),
      heightDimension: .absolute(300)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  private func createMovieUpcomingSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(0.3)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 8, trailing: 10)
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  private func setDatasource() {
    self.datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
      switch item {
      case .commonItem(let commonData):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonItemCell.id, for: indexPath) as? CommonItemCell
        cell?.configure(commonItem: commonData)
        return cell
      case .bannerItem(let movieData):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerItemCell.id, for: indexPath) as? BannerItemCell
        cell?.configure(with: movieData)
        return cell
      case .verticalItem(let movieData):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalItemCell.id, for: indexPath) as? VerticalItemCell
        cell?.configure(with: movieData)
        return cell
      }
    })
    
    datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
      
      let section = self?.datasource?.sectionIdentifier(for: indexPath.section)
      switch section {
      case .moviePopular(header: let title),
          .movieUpcoming(header: let title):
        (header as? HeaderView)?.configure(title: title)
      default:
        print("Default - Non Header")
      }
      
      return header
    }
  }
  
}

