//
//  TabBarController.swift
//  KTV
//
//  Created by 박성훈 on 11/6/24.
//

import UIKit

class TabBarController: UITabBarController {

  // 테이블뷰가 회전되지 않도록 설정 tableView가 tabBarController의 subview이기 때문에 여기서 설정하기
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }  // 회전 안되도록

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
