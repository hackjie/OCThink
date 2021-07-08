//
//  SegmentedViewController.swift
//  OCThink
//
//  Created by 李杰 on 2021/7/7.
//  Copyright © 2021 leoli. All rights reserved.
//

import Foundation
import UIKit

@objc(LJSegmentedViewController)
class IndicatorCustomizeViewController: UIViewController, LiveSegmentedViewDelegate {
  let titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
  let segmentedView = LiveSegmentedView()
  var segmentedDataSource: LiveSegmentedTitleDataSource?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    //配置数据源
    segmentedDataSource = LiveSegmentedTitleDataSource()
    segmentedDataSource?.isTitleColorGradientEnabled = true
    segmentedDataSource?.titles = titles
    segmentedView.dataSource = segmentedDataSource
    segmentedView.delegate = self
    //配置指示器
    let indicator = LiveSegmentedIndicatorBackgroundView()
    indicator.indicatorHeight = 30
    segmentedView.indicators = [indicator]
    self.view.addSubview(segmentedView)
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    segmentedView.frame = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 50)
  }
}
