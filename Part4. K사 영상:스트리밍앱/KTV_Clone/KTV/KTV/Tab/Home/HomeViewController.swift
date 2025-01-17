//
//  HomeViewController.swift
//  KTV
//
//  Created by 박성훈 on 11/6/24.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  private let homeViewModel: HomeViewModel = .init()
  
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupCollectionView()
    self.bindViewModel()
    self.homeViewModel.requestData()
  }
  
  private func bindViewModel() {
    self.homeViewModel.dataChanged = { [weak self] in
      self?.collectionView.isHidden = false
      self?.collectionView.reloadData()
    }
  }
  
  private func setupCollectionView() {
    collectionView.isHidden = true
    registerXibToCollectionView()
    setCollectionViewDelegate()
  }
  
  private func setCollectionViewDelegate() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func registerXibToCollectionView() {
    collectionView.register(
      UINib(nibName: HomeHeaderView.id, bundle: nil),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderView.id
    )
    collectionView.register(
      UINib(nibName: HomeRankingHeaderView.id, bundle: nil),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeRankingHeaderView.id
    )
    collectionView.register(
      UINib(nibName: HomeFooterView.id, bundle: nil),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: HomeFooterView.id
    )
    collectionView.register(
      UINib(nibName: HomeVideoCell.id, bundle: nil),
      forCellWithReuseIdentifier: HomeVideoCell.id
    )
    collectionView.register(
      UINib(nibName: HomeRankingContainerCell.id, bundle: nil),
      forCellWithReuseIdentifier: HomeRankingContainerCell.id
    )
    collectionView.register(
      UINib(nibName: HomeRecentWatchContainerCell.id, bundle: nil),
      forCellWithReuseIdentifier: HomeRecentWatchContainerCell.id
    )
    collectionView.register(
      UINib(nibName: HomeRecommendContainerCell.id, bundle: nil),
      forCellWithReuseIdentifier: HomeRecommendContainerCell.id
    )
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
  }
}

// MARK: - CollectionView Delegate FlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  // header inset
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let section = HomeSection(rawValue: section) else { return .zero }
    
    switch section {
    case .header:
      return CGSize(width: collectionView.frame.width, height: HomeHeaderView.height)
    case .ranking:
      return CGSize(width: collectionView.frame.width, height: HomeRankingHeaderView.height)
    default:
      return .zero
    }
  }
  // footer inset
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard let section = HomeSection(rawValue: section) else { return .zero }

    switch section {
    case .footer:
      return CGSize(width: collectionView.frame.width, height: HomeFooterView.height)
    default:
      return .zero
    }
  }
  // 컨텐츠 inset
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    guard let section = HomeSection(rawValue: section) else { return .zero }

    return self.setInsetForSection(section)
  }
  // 라인간의 간격
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header, .footer:
      return .zero
    default:
      return 21
    }
  }
  // 사이즈
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let section = HomeSection(rawValue: indexPath.section) else { return .zero }
    
    let inset = self.setInsetForSection(section)
    let width = collectionView.frame.width - inset.left - inset.right
    
    switch section {
    case .header, .footer:
      return .zero
    case .video:
      return .init(width: width, height: HomeVideoCell.height)
    case .ranking:
      return .init(width: width, height: HomeRankingContainerCell.height)
    case.recentWatch:
      return .init(width: width, height: HomeRecentWatchContainerCell.height)
    case .recommend:
      return .init(width: width, height: HomeRecommendContainerCell.height(viewModel: homeViewModel.recommendViewModel))
    }
  }
  
  private func setInsetForSection(_ section: HomeSection) -> UIEdgeInsets {
    switch section {
    case .header, .footer:
      return .zero
    default:
      return .init(top: 0, left: 21, bottom: 21, right: 21)
    }
  }
}

// MARK: - Collection DataSource
extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return HomeSection.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = HomeSection(rawValue: section) else {
      return 0
    }
    
    switch section {
    case .header:
      return 0
    case .video:
      return homeViewModel.home?.videos.count ?? 0
    case .ranking:
      return 1
    case .recentWatch:
      return 1
    case .recommend:
      return 1
    case .footer:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return .init()
    }
    
    switch section {
    case .header:
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderView.id, for: indexPath)
    case .ranking:
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeRankingHeaderView.id, for: indexPath)
    case .footer:
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeFooterView.id, for: indexPath)
    case .video, .recentWatch, .recommend:
      return .init()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
    }
    
    switch section {
    case .header, .footer:
      return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
    case .video:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCell.id, for: indexPath)
      if let cell = cell as? HomeVideoCell,
         let data = homeViewModel.home?.videos[indexPath.row] {
        cell.setData(data)
      }
      return cell
    case .ranking:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRankingContainerCell.id, for: indexPath)
      if let cell = cell as? HomeRankingContainerCell,
         let data = homeViewModel.home?.rankings {
        cell.delegate = self
        cell.setData(data)
      }
      return cell
    case .recentWatch:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentWatchContainerCell.id, for: indexPath)
      if let cell = cell as? HomeRecentWatchContainerCell,
         let data = homeViewModel.home?.recents {
        cell.delegate = self
        cell.setData(data)
      }
      return cell
    case .recommend:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecommendContainerCell.id, for: indexPath)
      if let cell = cell as? HomeRecommendContainerCell {
        cell.delegate = self
        cell.setViewModel(homeViewModel.recommendViewModel)
      }
      return cell
    }
  }
}


// MARK: - Delegate
extension HomeViewController: HomeRankingContainerCellDelegate {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
    print("home ranking cell did select item at \(index)")
  }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
  func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
    print("home recent watch cell did select item at \(index)")
  }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
    print("home recommend cell did select item at \(index)")
  }
  
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
    // reloadData -> 셀의 사이즈도 새로 정하고 모든 뷰를 remove 했다가 add함
    // invalidateLayout -> 각 셀의 사이즈만 새로 계산해서 레이아웃을 새로 하여 cellForItem이 불리지 않는다.
    self.collectionView.collectionViewLayout.invalidateLayout()
  }
}



