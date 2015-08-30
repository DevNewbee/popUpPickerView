//
//  UILabelPlus.swift
//  JWXTV1
//
//  Created by 王俊硕 on 15/8/29.
//  Copyright (c) 2015年 王俊硕. All rights reserved.
//

import UIKit

class UILabelPlus: UILabel {
    
    init(frame: CGRect, title: String, backgroundColor: UIColor) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.54)
        text = title
        font = UIFont.systemFontOfSize(14)
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        rect.origin = CGPointMake(20, 10)
        
        return rect
    }
    override func drawTextInRect(rect: CGRect) {
        let aRect = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawTextInRect(aRect)
        
    }
}
