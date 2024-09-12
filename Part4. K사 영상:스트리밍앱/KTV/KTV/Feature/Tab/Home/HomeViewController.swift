//
//  HomeViewController.swift
//  KTV
//
//  Created by 박성훈 on 7/30/24.
//

import UIKit

class HomeViewController: UIViewController {
    
  @IBOutlet var tableView: UITableView!
  private let homeViewModel: HomeViewModel = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTableView()
  }
  
  private func setupTableView() {
    self.registerXibToTableView()
    self.setTableViewDelegate()
  }
  
  private func registerXibToTableView() {
    // HomeHeaderCell
    self.tableView.register(
      UINib(nibName: HomeHeaderCell.identifier, bundle: .main),
      forCellReuseIdentifier: HomeHeaderCell.identifier
    )
    // HomeVideoCell
    self.tableView.register(
      UINib(nibName: HomeVideoCell.identifier, bundle: .main),
      forCellReuseIdentifier: HomeVideoCell.identifier
    )
    // HomeRankingContainerCell
    self.tableView.register(
      UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeRankingContainerCell.identifier
    )
    // HomeRecentWatchContainerCell
    self.tableView.register(
      UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier
    )
    // HomeRecommendContainerCell
    self.tableView.register(
      UINib(nibName: HomeRecommendContainerCell.identifier, bundle: .main),
      forCellReuseIdentifier: HomeRecommendContainerCell.identifier
    )
    // HomeFooterCell
    self.tableView.register(
      UINib(nibName: HomeFooterCell.identifier, bundle: .main),
      forCellReuseIdentifier: HomeFooterCell.identifier
    )
    // ??
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "empty")
  }
  
  private func setTableViewDelegate() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  private func bindViewModel() {
    // 콜백을 받아서 reload 해주기
    self.homeViewModel.dataChanged = { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return HomeSection.allCases.count
  }
  
  // 각 section에 몇개의 row를 포함할 것인지
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header: 
      return 1
    case .video:
      return homeViewModel.home?.videos.count ?? 0
    case .ranking:
      return 1
    case .recentWatch: 
      return 1
    case .recommend:
      return 1
    case .footer: 
      return 1
    }
  }
  
  // 본격적으로 cell을 생성하는 메서드
  // indexPath에는 현재 생성하려는 cell이 몇번째 section의 몇번째 row인지에 대한 정보가 담겨있음
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
    }
    
    switch section {
    case .header:
      return tableView.dequeueReusableCell(
        withIdentifier: HomeHeaderCell.identifier,
        for: indexPath
      )
    case .video:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeVideoCell.identifier,
        for: indexPath
      )
      if let  cell = cell as? HomeVideoCell,
         let data = self.homeViewModel.home?.videos[indexPath.row] {
        cell.setData(data)
      }
      
      return cell
    case .ranking:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRankingContainerCell.identifier,
        for: indexPath
      )
      if let cell = cell as? HomeRankingContainerCell,
         let data = self.homeViewModel.home?.rankings {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .recentWatch:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRecentWatchContainerCell.identifier,
        for: indexPath
      )
      if let cell = cell as? HomeRecentWatchContainerCell,
         let data = self.homeViewModel.home?.recents {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .recommend:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRecommendContainerCell.identifier,
        for: indexPath
      )
      if let cell = cell as? HomeRecommendContainerCell,
         let data = self.homeViewModel.home?.recommends {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .footer:
      return tableView.dequeueReusableCell(
        withIdentifier: HomeFooterCell.identifier,
        for: indexPath
      )
    }
  }
}

// extension시 주의사항 - 프로토콜로 나눠놓은 함수가 다른 상속한 클래스에서 사용해야하는 경우 클래스 선언부에 함수가 있어야 상속 가능 -> extension에 있는 것은 상속 불가
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
    
    switch section {
    case .header:
      return HomeHeaderCell.height
    case .video:
      return HomeVideoCell.height
    case .ranking:
      return HomeRankingContainerCell.height
    case .recentWatch:
      return HomeRecentWatchContainerCell.height
    case .recommend:
      return HomeRecommendContainerCell.height
    case .footer:
      return HomeFooterCell.height
    }
  }
  
}

// MARK: - HomeRecommendContainerCellDelegate
extension HomeViewController: HomeRecommendContainerCellDelegate {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
    print("home recommend cell did select item at \(index)")
  }
}

// MARK: - HomeRankingContainerCellDelegate
extension HomeViewController: HomeRankingContainerCellDelegate {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
    print("home ranking cell did Select Item at \(index)")
  }
}

// MARK: - HomeRecentWatchContainerCellDelegate
extension HomeViewController: HomeRecentWatchContainerCellDelegate {
  func homeRecentWathContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
    print("home recent watch cell did select item at \(index)")
  }
}
