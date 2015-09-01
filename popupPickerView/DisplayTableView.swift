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
    var removeViewGesture: UITapGestureRecognizer?
    
    
    
    @IBOutlet var buttonA: UIButton?
    @IBOutlet var primarySelection: UIButton?
    @IBOutlet var secondarySelection: UIButton?
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    let dataSourceForA: [String] = ["It's My First shot", "I mean on Github"]
    let dataSourceForB: [String] = ["选项1", "选项2", "选项3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = false
        
//        println(backButton)
        
        popupPickerView = PopupPickerView()

        let tapG = UITapGestureRecognizer(target: self, action: "removePopupPickerView")
        tableView.addGestureRecognizer(tapG)
        
        popupPickerView!.leftLabelText = "请选择分类条件"
        popupPickerView!.rightButtonText = "完成"
        popupPickerView?.textColor = UIColor.whiteColor()
        popupPickerView?.dataSource = dataSourceForA
        popupPickerView?.containerColor = UIColorFrom(hex: 0xe8eaf6)
        popupPickerView?.titleBarColor = UIColorFrom(hex: 0x5c6bc0)
        
        popupPickerView?.addToView((self.tabBarController?.view)!) //这里初始化所有组件
        
        
    }
    func removePopupPickerView() {
        // 只是将 view 拖到了视线外并没有removeFromSuperview
        popupPickerView?.rightButtonTapped()
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
    
    func initialGesture() {
        var doubleTapRecognizer2 = UITapGestureRecognizer(target: self, action: "removePopupPickerView")
        doubleTapRecognizer2.numberOfTapsRequired = 1 //需要匹配的点击次数 默认1
        doubleTapRecognizer2.numberOfTouchesRequired = 1 //需要匹配的点击手指数 默认1
        tableView.addGestureRecognizer(doubleTapRecognizer2)//添加这个手势
        
    }
    @IBAction func buttonATapped(sender: AnyObject) {
        
        let currentRow = indexOfStringInArray(dataSourceForA, querryString: (buttonA!.titleLabel?.text)!)
        popupPickerView!.tapResponserPrimary(dataSourceForA, currentRow: currentRow, buttonForPopulate: buttonA!)
    }
   
    // pButton 选1 sButton 选2 pButton 再 选2  需要检测
    @IBAction func primarySelectionTapped(sender: AnyObject) {
        
        let currentRow = indexOfStringInArray(dataSourceForB, querryString: (primarySelection!.titleLabel?.text)!)
        popupPickerView!.tapResponserPrimary(dataSourceForB, currentRow: currentRow, buttonForPopulate: primarySelection!)
    }
    @IBAction func secondarySelectionTapped(sender: AnyObject) {
        let needRemove = indexOfStringInArray(dataSourceForB, querryString: (primarySelection!.titleLabel?.text)!)
        popupPickerView!.tapResponserSecondary(dataSourceForB, buttonForPupulate: secondarySelection!, needRemove: needRemove)
    }
//    @IBAction func backButton(sender: AnyObject) {
//        popupPickerView?.rightButtonTapped()
//        println(5)
//        isSameValue(primarySelection!, secondaryButton: secondarySelection!)
//        
//    }
    
    func UIColorFrom(#hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        println(1)
//        tableView.resignFirstResponder()
//    }
    
    func isSameValue(primaryButton: UIButton, secondaryButton: UIButton) -> Bool {
        // 绑定这个方法到返回按钮 上
        // 如果第二个按钮上的文字不在数据源里面那么肯定是没有选择完成的 允许直接抛弃前面的选择数据 不进行检测
        if indexOfStringInArray(dataSourceForB, querryString: (secondaryButton.titleLabel?.text)!) != -1 {
            if primaryButton.titleLabel?.text == secondaryButton.titleLabel?.text {
                secondaryButton.titleLabel?.textColor = UIColor.redColor()
                return true
            } else {
                return false
                }
        } else {
            return false
        }

        
    }
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        popupPickerView?.rightButtonTapped()

        if isSameValue(primarySelection!, secondaryButton: secondarySelection!) {
            return true
        } else {
            return false
        }
        
    }
    @IBAction func backSegue(segue: UIStoryboardSegue) {
       
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToMainView" {
            let buttonAValue: String = (buttonA?.titleLabel?.text)!
            let primaryValue: String = (primarySelection?.titleLabel?.text)!
            let secondaryValue: String = (secondarySelection?.titleLabel?.text)!
            if segue.destinationViewController is MainView {
                var destinationVC = segue.destinationViewController as! MainView
                destinationVC.selectedValue = [
                    "buttonA": buttonAValue,
                    "primaryButton": primaryValue,
                    "secondaryButton": secondaryValue
                ]
            } else {
                
            }
            
        }
        
    }
   
}


