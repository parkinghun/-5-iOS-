//
//  LoginViewController.swift
//  KTV
//
//  Created by 박성훈 on 7/30/24.
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
    loginButton.layer.cornerRadius = 19
    self.loginButton.layer.borderColor = UIColor.mainBrown.cgColor
    self.loginButton.layer.borderWidth = 1
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    print("login bt Tapped")
    setRootViewControllerToTab()
  }
  
  private func setRootViewControllerToTab() {
    let storyboard = UIStoryboard(name: "Tab", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "MyTabBarController") as? TabBarController else { return }
    
    self.view.window?.rootViewController = vc
  }
  
  
  
}
