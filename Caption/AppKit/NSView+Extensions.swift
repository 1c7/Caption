//
//  NSView+Extensions.swift
//  Quick Caption
//
//  Created by Blue on 3/17/19.
//  Copyright © 2019 Bright. All rights reserved.
//

import Cocoa

extension NSView {
    public func bringToFront() {
        let superlayer = self.layer?.superlayer
        self.layer?.removeFromSuperlayer()
        superlayer?.addSublayer(self.layer!)
    }
}

extension NSScrollView {
    func scroll(to point: NSPoint, animationDuration: Double) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = animationDuration
        contentView.animator().setBoundsOrigin(point)
        reflectScrolledClipView(contentView)
        NSAnimationContext.endGrouping()
    }
}
