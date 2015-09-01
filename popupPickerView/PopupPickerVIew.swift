//
//  PopUpPickerView.swift
//  JWXTV1
//
//  Created by 王俊硕 on 15/8/27.
//  Copyright (c) 2015年 王俊硕. All rights reserved.
//

import UIKit


class PopupPickerView: NSObject {
    /** 需要设置PickerView 得delegate dataScource
    用户需要设置的是 dataSource leftLabel rightButton textColor backgroundColor
    所有组件都在一开始属性的初始化构造完毕 外部修改组件属性时 通过属性检测器来应用组件上
    containerView在构造器中设置完成 其它views都在addToView:方法中完成了设置 addToView在外部调用
    
    **/
    
    var dataSource: [String]?
    // MARK: -Componet Initializaiton
    let containerView = UIView()
    
    var pickerView = UIPickerView()
    
    let leftLabel = UILabel()
    let titleBar = UILabel()
    let rightButton = UIButton()
    
    var buttonForPopulate: UIButton?
    var selectedValue: String?
    var selectedRow: Int?
    // MARK: -Attribute Initilization
    let viewHeight = UIWindow().screen.bounds.height / 3
    let viewWidth = UIWindow().screen.bounds.width
    let titleBarHeight = CGFloat(30.0)
    
    
    // MARK: - 在addToView() 之前调用这些函数来设值 
    
    var rightButtonText: String = "完成" {
        didSet {
            self.rightButton.setAttributedTitle(NSAttributedString(string: rightButtonText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15),NSForegroundColorAttributeName: textColor]), forState: UIControlState.Normal)
        }
    }
    var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.leftLabel.textColor = self.textColor
            self.rightButton.setAttributedTitle(NSAttributedString(string: rightButtonText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15),NSForegroundColorAttributeName: textColor]), forState: UIControlState.Normal)
        }
    }
    var leftLabelText = "选择" {
        didSet {
            self.leftLabel.text = leftLabelText
            leftLabel.frame.size = CGSize(width: leftLabel.autoWidth, height: 20)
        }
    }
    var titleBarColor = UIColor.grayColor() { didSet { self.titleBar.backgroundColor = titleBarColor } }
    var containerColor = UIColor.redColor() { didSet { self.containerView.backgroundColor = containerColor } }
    var pickerViewColor = UIColor.whiteColor() { didSet { self.pickerView.backgroundColor = pickerViewColor } }
    //    var backgroundColor = UIColor.whiteColor()
    
    // MARK: - Initial Methods

    required override init() {
        super.init()
        containerViewInit(containerView, backgroundColor: containerColor)
        
        titleBarInit(titleBarColor)
        leftLabelInit(leftLabelText, textColor: textColor)
        rightButtonInit(rightButtonText, textColor: textColor)
        pickerViewInit(pickerViewColor)

    }
    
    func addToView(view: UIView) {
        view.addSubview(containerView)
        
        containerView.addSubview(pickerView)
        containerView.addSubview(titleBar)
        containerView.addSubview(leftLabel)
        containerView.addSubview(rightButton)
    }

    func containerViewInit(containerView:UIView, backgroundColor: UIColor) {
        containerView.frame = CGRectMake(0, 3*viewHeight, viewWidth, viewHeight)
        containerView.backgroundColor = backgroundColor
    }
    func pickerViewInit(backgroundColor: UIColor) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.frame = CGRectMake(0, titleBarHeight, viewWidth, viewHeight-titleBarHeight)
        pickerView.backgroundColor = backgroundColor
    }
    func leftLabelInit(textOnlabel: String, textColor: UIColor ) {
        leftLabel.text = textOnlabel
        leftLabel.font = UIFont.systemFontOfSize(15.0)
        leftLabel.frame = CGRect(x: 10, y: 5, width: leftLabel.autoWidth, height: 20)
        leftLabel.textColor = textColor
    }
    func titleBarInit(titlebarColor: UIColor) {
        titleBar.frame = CGRectMake(0, 0, viewWidth, titleBarHeight)
        titleBar.backgroundColor = titlebarColor
    }
    func rightButtonInit(textOnButton: String, textColor: UIColor) {
        
        rightButton.frame = CGRectMake(viewWidth - 50, 5, 60, 20 )
        rightButton.setAttributedTitle(NSAttributedString(string: textOnButton, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15),NSForegroundColorAttributeName: textColor]), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "rightButtonTapped", forControlEvents: UIControlEvents.AllTouchEvents)
        rightButton.setTitle("nihao", forState: UIControlState.Normal)
    }
    
    // MARK: - 事件响应函数
    
    /// containerView 右上角按钮按下后调用此事件
    func rightButtonTapped() {
        
        UIView.animateWithDuration(0.23, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.containerView.frame.origin  = CGPointMake(0, 3*self.viewHeight)
            
            }, completion: nil)
        
        
    }
    
    /// 每次调用 popup() 前都应该调用这个方法更新数据源
    func refreshDataSource(dataSource: [String], currentRow: Int) {
        
        self.dataSource = dataSource
        pickerView.reloadComponent(0)
        pickerView.selectRow(currentRow, inComponent: 0, animated: true)
        
        
    }
    
    /// 通过此函数来显示 popupView
    func popUp() {
        
        
        UIView.animateWithDuration(0.23, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.containerView.frame.origin = CGPointMake(0, 2*self.viewHeight)
            
            }, completion: nil)
        
    }
    
    
}

extension PopupPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        println(popUpView!.dataSource.count)
        return dataSource!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dataSource![row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = dataSource![row]
        selectedRow = row
        populateToUIBUtton(buttonForPopulate!, withtext: selectedValue!)
        
    }
    
}

extension PopupPickerView {
    func tapResponserPrimary(dataSource: [String], currentRow: Int, buttonForPopulate: UIButton) {
        // -1 代表还没有点过 初始化为第0个
        self.buttonForPopulate = buttonForPopulate
        refreshDataSource(dataSource, currentRow: currentRow == -1 ? 0 : currentRow)
        if currentRow == -1 {
            populateToUIBUtton(self.buttonForPopulate!, withtext: dataSource[0])
        }
        popUp()
        
    }
    
    func tapResponserSecondary(dataSource: [String], buttonForPupulate: UIButton, needRemove: Int ) {
        var secondaryData: [String]?
        self.buttonForPopulate = buttonForPupulate
        
        if needRemove == -1 {
            secondaryData = ["请选择一级排序标识"] // 如果上一级还没有选择 那么下一级一定也是处于未选择的状态
            refreshDataSource(secondaryData!, currentRow: 0)
        } else  {
            secondaryData = dataSource
            secondaryData!.removeAtIndex(needRemove)
            let currentRow = indexOfStringInArray(secondaryData!, querryString: (buttonForPupulate.titleLabel?.text)!)
            if currentRow == -1 {
                populateToUIBUtton(self.buttonForPopulate!, withtext: dataSource[0])
            }
            refreshDataSource(secondaryData!, currentRow: currentRow == -1 ? 0 : currentRow)
        }
        popUp()
    }
    
    func populateToUIBUtton(button: UIButton, withtext text: String) {
        button.setAttributedTitle(NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17),NSForegroundColorAttributeName: UIColor.blackColor()]), forState: UIControlState.Normal)
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
}

extension UILabel {
    var autoWidth: CGFloat {
            if let string = self.text {
                return CGFloat(count(self.text!) * 15 as Int)
            }
            return 0
    }
}