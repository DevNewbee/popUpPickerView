//
//  mainView.   wift
//  popupPickerView
//
//  Created by 王俊硕 on 15/8/31.
//  Copyright (c) 2015年 王俊硕. All rights reserved.
//

import UIKit

class MainView: UITableViewController {
    
    var selectedValue: [String: String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor() // 改变按钮颜色
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = UIColorFrom(hex: 0x5c6bc0)
        
    }
    
    func UIColorFrom(#hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
    
    @IBAction func backSegue(segue: UIStoryboardSegue) {
        if let buttonAValue = selectedValue?["buttonA"] {
            println(buttonAValue)
        }
        if let primaryValue = selectedValue?["primaryButton"] {
            println(primaryValue)
        }
        if let secondaryValue = selectedValue?["secondaryButton"] {
            println(secondaryValue)
        }
    }
   
}
