//
//  MyPageViewController.swift
//  KTV
//
//  Created by 박성훈 on 11/6/24.
//

import UIKit

class MyPageViewController: UIViewController {
  
  @IBOutlet var profileImageView: UIImageView!
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    self.profileImageView.layer.cornerRadius = 5
  }
  
  // 버튼에서 바로 연결함
  @IBAction func bookmarkDidTap(_ sender: Any) {
//    self.performSegue(withIdentifier: "bookmark", sender: nil)
  }
  
  @IBAction func favoriteDidTap(_ sender: Any) {
    self.performSegue(withIdentifier: "favorite", sender: nil)
  }
  
}
