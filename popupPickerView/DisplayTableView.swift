//
//  DisplayTableView.swift
//  popupPickerView
//
//  Created by 王俊硕 on 15/8/29.
//  Copyright (c) 2015年 王俊硕. All rights reserved.
//

import UIKit

class DisplayTableView: UITableViewController {

    var popupPickerView: PopupPickerView?
    
    @IBOutlet var buttonA: UIButton?
    @IBOutlet var primarySelection: UIButton?
    @IBOutlet var secondarySelection: UIButton?
    
    let dataSourceForA: [String] = ["It's My First shot", "I mean on Github"]
    let dataSourceForB: [String] = ["选项1", "选项2", "选项3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = false
        
        
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor() // 改变按钮颜色
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = UIColorFrom(hex: 0x5c6bc0)
        
        popupPickerView = PopupPickerView()

        
        popupPickerView!.leftLabelText = "请选择分类条件"
        popupPickerView!.rightButtonText = "完成"
        popupPickerView?.textColor = UIColor.whiteColor()
        popupPickerView?.dataSource = dataSourceForA
        popupPickerView?.containerColor = UIColorFrom(hex: 0xe8eaf6)
        popupPickerView?.titleBarColor = UIColorFrom(hex: 0x5c6bc0)
        
        popupPickerView?.addToView((self.tabBarController?.view)!) //这里初始化所有组件

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1 // 最小是1
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let labelTitle = ["示例1","示例2","示例3"]
        let label = UILabelPlus(frame: CGRectMake(0, 0, UIWindow().screen.bounds.width, 30), title: labelTitle[section], backgroundColor: UIColorFrom(hex: 0xe8eaf6))
        
        return label
    }
    
    func indexOfStringInArray(array: [String], querryString: String) -> Int {
        var index = 0
        var isExited = false
        for item in array {
            if item == querryString {
                isExited = true
                break
            }
            else { index++ }
        }
        return isExited ? index : -1 // －1 作为存在的标志给 二级排序的时候去除数据使用
    }
    
    
    @IBAction func buttonATapped(sender: AnyObject) {
        popupPickerView?.buttonForPopulate = buttonA

        let currentRow = indexOfStringInArray(dataSourceForA, querryString: (buttonA!.titleLabel?.text)!)

        if currentRow == -1 {
            popupPickerView?.populateToUIBUtton((popupPickerView?.buttonForPopulate)!, withtext: dataSourceForA[0])
        }
        
        
        let textLength: Int = count((buttonA!.titleLabel?.text)!)
        buttonA?.frame.size =
            CGSize(width: CGFloat(textLength * 16), height: CGFloat((buttonA?.frame.size.height)!))
        println(buttonA?.frame.size.width)
        popupPickerView?.refreshDataSource(dataSourceForA, currentRow: currentRow == -1 ? 0 : currentRow)
        
        popupPickerView?.popUp()
        
        
        
    }
   
    
    @IBAction func primarySelectionTapped(sender: AnyObject) {
        popupPickerView?.buttonForPopulate = primarySelection
        let currentRow = indexOfStringInArray(dataSourceForB, querryString: (primarySelection!.titleLabel?.text)!)
        popupPickerView?.refreshDataSource(dataSourceForB, currentRow: currentRow == -1 ? 0 : currentRow)
        
        popupPickerView?.popUp()
    }
    @IBAction func secondarySelectionTapped(sender: AnyObject) {
        
        popupPickerView?.buttonForPopulate = secondarySelection
        
        var secondaryData: [String] = dataSourceForB
        let needRemove = indexOfStringInArray(dataSourceForB, querryString: (primarySelection!.titleLabel?.text)!)
        if needRemove == -1 {
            secondaryData = ["请选择一级排序标识"] // 如果上一级还没有选择 那么下一级一定也是处于未选择的状态
            popupPickerView?.refreshDataSource(secondaryData, currentRow: 0)

        } else  {
            secondaryData.removeAtIndex(needRemove)
            let currentRow = indexOfStringInArray(secondaryData, querryString: (secondarySelection!.titleLabel?.text)!)
            popupPickerView?.refreshDataSource(secondaryData, currentRow: currentRow == -1 ? 0 : currentRow)
            
        }
        popupPickerView?.popUp()
        
    }
    
    func UIColorFrom(#hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }

}
