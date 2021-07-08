//
//  LiveSegmentedTitleView.swift
//  LiveSegmentedView
//
//  Created by 李杰 on 2021/7/7.
//  Copyright © 2021 leoli. All rights reserved.
//

import UIKit

open class LiveSegmentedTitleDataSource: LiveSegmentedBaseDataSource{
    /// title数组
    open var titles = [String]()
    /// 如果将LiveSegmentedView嵌套进UITableView的cell，每次重用的时候，LiveSegmentedView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该闭包方法返回给LiveSegmentedView。
    open var widthForTitleClosure: ((String)->(CGFloat))?
    /// label的numberOfLines
    open var titleNumberOfLines: Int = 1
    /// title普通状态的textColor
    open var titleNormalColor: UIColor = .black
    /// title选中状态的textColor
    open var titleSelectedColor: UIColor = .red
    /// title普通状态时的字体
    open var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// title选中时的字体。如果不赋值，就默认与titleNormalFont一样
    open var titleSelectedFont: UIFont?
    /// title的颜色是否渐变过渡
    open var isTitleColorGradientEnabled: Bool = false
    /// title是否缩放。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
    open var isTitleZoomEnabled: Bool = false
    /// isTitleZoomEnabled为true才生效。是对字号的缩放，比如titleNormalFont的pointSize为10，放大之后字号就是10*1.2=12。
    open var titleSelectedZoomScale: CGFloat = 1.2
    /// title的线宽是否允许粗细。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
    open var isTitleStrokeWidthEnabled: Bool = false
    /// 用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现），负数越小字体越粗。
    open var titleSelectedStrokeWidth: CGFloat = -2
    /// title是否使用遮罩过渡
    open var isTitleMaskEnabled: Bool = false


    open override func preferredItemCount() -> Int {
        return titles.count
    }

    open override func preferredItemModelInstance() -> LiveSegmentedBaseItemModel {
        return LiveSegmentedTitleItemModel()
    }

    open override func preferredRefreshItemModel( _ itemModel: LiveSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? LiveSegmentedTitleItemModel else {
            return
        }

        myItemModel.title = titles[index]
        myItemModel.textWidth = widthForTitle(myItemModel.title ?? "")
        myItemModel.titleNumberOfLines = titleNumberOfLines
        myItemModel.isSelectedAnimable = isSelectedAnimable
        myItemModel.titleNormalColor = titleNormalColor
        myItemModel.titleSelectedColor = titleSelectedColor
        myItemModel.titleNormalFont = titleNormalFont
        myItemModel.titleSelectedFont = titleSelectedFont != nil ? titleSelectedFont! : titleNormalFont
        myItemModel.isTitleZoomEnabled = isTitleZoomEnabled
        myItemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
        myItemModel.isTitleMaskEnabled = isTitleMaskEnabled
        myItemModel.titleNormalZoomScale = 1
        myItemModel.titleSelectedZoomScale = titleSelectedZoomScale
        myItemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
        myItemModel.titleNormalStrokeWidth = 0
        if index == selectedIndex {
            myItemModel.titleCurrentColor = titleSelectedColor
            myItemModel.titleCurrentZoomScale = titleSelectedZoomScale
            myItemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
        }else {
            myItemModel.titleCurrentColor = titleNormalColor
            myItemModel.titleCurrentZoomScale = 1
            myItemModel.titleCurrentStrokeWidth = 0
        }
    }

    open func widthForTitle(_ title: String) -> CGFloat {
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(title)
        }else {
            let textWidth = NSString(string: title).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : titleNormalFont], context: nil).size.width
            return CGFloat(ceilf(Float(textWidth)))
        }
    }

    /// 因为该方法会被频繁调用，所以应该在`preferredRefreshItemModel( _ itemModel: LiveSegmentedBaseItemModel, at index: Int, selectedIndex: Int)`方法里面，根据数据源计算好文字宽度，然后缓存起来。该方法直接使用已经计算好的文字宽度即可。
    open override func preferredSegmentedView(_ segmentedView: LiveSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var width = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemWidth == LiveSegmentedViewAutomaticDimension {
            width += (dataSource[index] as! LiveSegmentedTitleItemModel).textWidth
        }else {
            width += itemWidth
        }
        return width
    }

    //MARK: - LiveSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: LiveSegmentedView) {
        segmentedView.collectionView.register(LiveSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: LiveSegmentedView, cellForItemAt index: Int) -> LiveSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    public override func segmentedView(_ segmentedView: LiveSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        let model = dataSource[index] as! LiveSegmentedTitleItemModel
        if isTitleZoomEnabled {
            return model.textWidth*model.titleCurrentZoomScale
        }else {
            return model.textWidth
        }
    }

    open override func refreshItemModel(_ segmentedView: LiveSegmentedView, leftItemModel: LiveSegmentedBaseItemModel, rightItemModel: LiveSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)
        
        guard let leftModel = leftItemModel as? LiveSegmentedTitleItemModel, let rightModel = rightItemModel as? LiveSegmentedTitleItemModel else {
            return
        }

        if isTitleZoomEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentZoomScale = LiveSegmentedViewTool.interpolate(from: leftModel.titleSelectedZoomScale, to: leftModel.titleNormalZoomScale, percent: CGFloat(percent))
            rightModel.titleCurrentZoomScale = LiveSegmentedViewTool.interpolate(from: rightModel.titleNormalZoomScale, to: rightModel.titleSelectedZoomScale, percent: CGFloat(percent))
        }

        if isTitleStrokeWidthEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentStrokeWidth = LiveSegmentedViewTool.interpolate(from: leftModel.titleSelectedStrokeWidth, to: leftModel.titleNormalStrokeWidth, percent: CGFloat(percent))
            rightModel.titleCurrentStrokeWidth = LiveSegmentedViewTool.interpolate(from: rightModel.titleNormalStrokeWidth, to: rightModel.titleSelectedStrokeWidth, percent: CGFloat(percent))
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentColor = LiveSegmentedViewTool.interpolateColor(from: leftModel.titleSelectedColor, to: leftModel.titleNormalColor, percent: percent)
            rightModel.titleCurrentColor = LiveSegmentedViewTool.interpolateColor(from:rightModel.titleNormalColor , to:rightModel.titleSelectedColor, percent: percent)
        }
    }

    open override func refreshItemModel(_ segmentedView: LiveSegmentedView, currentSelectedItemModel: LiveSegmentedBaseItemModel, willSelectedItemModel: LiveSegmentedBaseItemModel, selectedType: LiveSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? LiveSegmentedTitleItemModel, let myWillSelectedItemModel = willSelectedItemModel as? LiveSegmentedTitleItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentColor = myCurrentSelectedItemModel.titleNormalColor
        myCurrentSelectedItemModel.titleCurrentZoomScale = myCurrentSelectedItemModel.titleNormalZoomScale
        myCurrentSelectedItemModel.titleCurrentStrokeWidth = myCurrentSelectedItemModel.titleNormalStrokeWidth
        myCurrentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

        myWillSelectedItemModel.titleCurrentColor = myWillSelectedItemModel.titleSelectedColor
        myWillSelectedItemModel.titleCurrentZoomScale = myWillSelectedItemModel.titleSelectedZoomScale
        myWillSelectedItemModel.titleCurrentStrokeWidth = myWillSelectedItemModel.titleSelectedStrokeWidth
    }
}
