//
//  ViewController.swift
//  KTV
//
//  Created by hyeonggyu.kim on 2023/09/06.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var loginButton: UIButton!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  private func setupUI() {
    self.loginButton.layer.cornerRadius = 19
    self.loginButton.layer.borderColor = UIColor(named: "main-brown")?.cgColor
    self.loginButton.layer.borderWidth = 1
  }
  
  @IBAction func buttonDidTap(_ sender: Any) {
    setRoootViewControllerTab()
  }
  
  private func setRoootViewControllerTab() {
    let storyboard = UIStoryboard(name: "Tab", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else { return }
    
    self.view.window?.rootViewController = vc
  }
  
}

