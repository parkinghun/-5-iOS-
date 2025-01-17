//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by 박성훈 on 11/8/24.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UICollectionViewCell {
    
  @IBOutlet var containerView: UIView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var foldButton: UIButton!
  
  static let id: String = "HomeRecommendContainerCell"

  static func height(viewModel: HomeRecommendViewModel) -> CGFloat {
    let top: CGFloat = 84 - 6  // 첫번째 cell에서 bottom까지 거리 - cell 상단 여백
    let bottom: CGFloat = 68 - 6  // 마지막 cell 첫번째 bottom까지 거리 - cell 하단 여백
    let footerInset: CGFloat = 51  // container -> footer까지의 여백
    return HomeRecommendItemCell.height * CGFloat(viewModel.itemCount) + top + bottom + footerInset
  }
  
  weak var delegate: HomeRecommendContainerCellDelegate?
  private var recommends: [Home.Recommend]?
  private var viewModel: HomeRecommendViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
    setupTableView()
  }
  
  @IBAction func foldButtonTapped(_ sender: UIButton) {
    self.viewModel?.toggleFoldState()
    self.delegate?.homeRecommendContainerCellFoldChanged(self)
  }
  
  public func setViewModel(_ viewModel: HomeRecommendViewModel) {
    self.viewModel = viewModel
    self.setButtonImage(viewModel.isFolded)
    self.tableView.reloadData()
    
    viewModel.foldChanged = { [weak self] isFolded in
      self?.tableView.reloadData()
      self?.setButtonImage(isFolded)
    }
  }
  
  private func setupUI() {
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 10
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
  }
  
  private func setupTableView() {
    tableView.rowHeight = HomeRecommendItemCell.height
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(
      UINib(nibName: HomeRecommendItemCell.id, bundle: .main),
      forCellReuseIdentifier: HomeRecommendItemCell.id
    )
  }
  
  private func setButtonImage(_ isFolded: Bool) {
    let imageName: String = isFolded ? "unfold" : "fold"
    foldButton.setImage(UIImage(named: imageName), for: .normal)
  }
}

// MARK: - TableView DataSource
extension HomeRecommendContainerCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.itemCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.id, for: indexPath)
    
    if let cell = cell as? HomeRecommendItemCell,
       let data = recommends?[indexPath.row] {
      cell.setData(data, rank: indexPath.row + 1)
    }
    return cell
  }
}

// MARK: - TableView Delegate
extension HomeRecommendContainerCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
  }
}
