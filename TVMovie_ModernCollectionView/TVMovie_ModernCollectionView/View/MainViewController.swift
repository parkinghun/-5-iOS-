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

// TODO: - "헤더 뷰 공부하기"

// TODO: - 구현할 사항
/*
 1. 상세뷰 보여주기(네비게이션 컨트롤러 사용하기)
 2. TV - Searching
 3. Pagenation - infiniteScroll (throttle)
 4. 에러처리 -> 알럿 띄우기
 */

// 레이아웃 기준
fileprivate enum Section: Hashable {
  case tvTopRated
  case movieNowPlaying
  case moviePopular(header: String = "Popular Movies")
  case movieUpcoming(header: String = "Upcoming Movies")
}

// 셀 기준
fileprivate enum Item: Hashable {
  case commonItem(CommonItem)
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
    self.view.addSubview(buttonView)
    self.view.addSubview(collectionView)
  }
  
  private func setConstraints() {
    let safeArea = self.view.safeAreaLayoutGuide
    buttonView.snp.makeConstraints { make in
      make.height.equalTo(80)
      make.leading.top.trailing.equalTo(safeArea)
    }
    
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(buttonView.snp.bottom)
    }
  }
  
  private func bindView() {
    buttonView.tvButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.tvTrigger.onNext(1)
      buttonView.setButtonBackgroundColor(isTvButtonTapped: true)
    }.disposed(by: disposeBag)
    
    buttonView.movieButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.movieTrigger.onNext(Void())
      buttonView.setButtonBackgroundColor(isTvButtonTapped: false)
    }.disposed(by: disposeBag)
  }
  
  private func bindViewModel() {
    let input = MainViewModel.Input(
      tvTrigger: tvTrigger.asObservable(),
      movieTrigger: movieTrigger.asObservable()
    )
    let output = viewModel.transform(input: input)
    
    output.tvList.bind { [weak self] result in
      switch result {
      case .success(let tvList):
        print(tvList)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let section = Section.tvTopRated
        let items = tvList.map { Item.commonItem(CommonItem(with: $0)) }
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        self?.datasource?.apply(snapshot)
        
      case .failure(let error):
        // TODO: - Alert 띄우기
        print(error)
      }
    }.disposed(by: disposeBag)
    
    output.movieResults.bind { [weak self] result in
      switch result {
      case .success(let movieResults):
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let nowPlayingSection = Section.movieNowPlaying
        let popularSection = Section.moviePopular(header: "Popular Movies")
        let upcomingSection = Section.movieUpcoming(header: "Upcoming Movies")
        
        let bannerItem = movieResults.nowPlaying.results
          .map { Item.bannerItem($0) }
        let commonItem = movieResults.popular.results
          .map { Item.commonItem(CommonItem(with: $0)) }
        let verticalItem = movieResults.upcoming.results
          .map { Item.verticalItem($0) }
        
        snapshot.appendSections([nowPlayingSection, popularSection, upcomingSection])
        snapshot.appendItems(bannerItem, toSection: nowPlayingSection)
        snapshot.appendItems(commonItem, toSection: popularSection)
        snapshot.appendItems(verticalItem, toSection: upcomingSection)
        
        self?.datasource?.apply(snapshot)
      case .failure(let error):
        print(error)
        // TODO: - Alert 띄우기
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
    
    // TODO: - 공부하기
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

