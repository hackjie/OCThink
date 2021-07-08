//
//  LiveSegmentedRTLLayout.swift
//  LiveSegmentedView
//
//  Created by 李杰 on 2021/7/7.
//  Copyright © 2021 leoli. All rights reserved.
//

import UIKit

public protocol LiveSegmentedViewRTLCompatible: class {
    func segmentedViewShouldRTLLayout() -> Bool
    func segmentedView(horizontalFlipForView view: UIView?)
}

public extension LiveSegmentedViewRTLCompatible {
    
    /// 根据当前系统布局方式返回是否需要RTL布局
    func segmentedViewShouldRTLLayout() -> Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    /// 在RTL布局下水平翻转当前视图
    /// - Parameter view: 需要翻转的视图
    func segmentedView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

class LiveSegmentedRTLCollectionCell: UICollectionViewCell, LiveSegmentedViewRTLCompatible {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: self)
            segmentedView(horizontalFlipForView: contentView)
        }
    }
    
}
