//
//  LiveSegmentedAnimator.swift
//  LiveSegmentedView
//
//  Created by 李杰 on 2021/7/7.
//  Copyright © 2021 leoli. All rights reserved.
//

import Foundation
import UIKit

open class LiveSegmentedAnimator {
    open var duration: TimeInterval = 0.25
    open var progressClosure: ((CGFloat)->())?
    open var completedClosure: (()->())?
    private var displayLink: CADisplayLink!
    private var firstTimestamp: CFTimeInterval?

    public init() {
        displayLink = CADisplayLink(target: self, selector: #selector(processDisplayLink(sender:)))
    }

    open func start() {
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    open func stop() {
        progressClosure?(1)
        displayLink.invalidate()
        completedClosure?()
    }

    @objc private func processDisplayLink(sender: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = sender.timestamp
        }
        let percent = (sender.timestamp - firstTimestamp!)/duration
        if percent >= 1 {
            progressClosure?(1)
            displayLink.invalidate()
            completedClosure?()
        }else {
            progressClosure?(CGFloat(percent))
        }
    }
}
