//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 7/31/24.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
}

class HomeRecommendContainerCell: UITableViewCell {
  
  static let identifier: String = "HomeRecommendContainerCell"
  
  static var height: CGFloat {
    let top: CGFloat = 84 - 6  // 첫번째 cell에서 bottom까지 거리 - cell 상단 여백
    let bottom: CGFloat = 68 - 6  // 마지막 cell 첫번째 bottom까지 거리 - cell 하단 여백
    let footerInset: CGFloat = 51  // container -> footer까지의 여백
    return HomeRecommendItemCell.height * 5 + top + bottom + footerInset
  }
  
  // MARK: - UI Components
  @IBOutlet var ContainerView: UIView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var foldButton: UIButton!
  
  weak var delegate: HomeRecommendContainerCellDelegate?
  private var recommends: [Home.Recommend]?
  
  // MARK: - awakeFromNib
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupUI()
    self.setupTableView()
  }
  
  private func setupUI() {
    self.ContainerView.layer.cornerRadius = 10
    self.ContainerView.layer.borderWidth = 1
    self.ContainerView.layer.borderColor = UIColor.strokeLight.cgColor
  }
  
  private func setupTableView() {
    self.tableView.rowHeight = HomeRecommendItemCell.height
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(
      UINib(
        nibName: HomeRecommendItemCell.identifier, bundle: .main),
      forCellReuseIdentifier: HomeRecommendItemCell.identifier
    )
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  @IBAction func foldButtonTapped(_ sender: Any) {
  }
  
  func setData(_ data: [Home.Recommend]) {
    self.recommends = data
    self.tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension HomeRecommendContainerCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
    
    if let cell = cell as? HomeRecommendItemCell,
       let data = self.recommends?[indexPath.row] {
      cell.setData(data, rank: indexPath.row + 1)
    }
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension HomeRecommendContainerCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)

  }
}
