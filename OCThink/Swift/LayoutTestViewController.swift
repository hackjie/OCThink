//
//  LayoutTestViewController.swift
//  OCThink
//
//  Created by 李杰 on 2021/7/8.
//  Copyright © 2021 leoli. All rights reserved.
//

import UIKit

class LayoutTestViewController: UIViewController {
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    var topSafeOffset:CGFloat = 0.0;
    var bottomSafeOffset:CGFloat = 0.0;
    if #available(iOS 11.0, *) {
      topSafeOffset = view.safeAreaInsets.top
      bottomSafeOffset = view.safeAreaInsets.bottom
    } else {
      topSafeOffset = self.topLayoutGuide.length
      bottomSafeOffset = self.topLayoutGuide.length
    }
  }
}
