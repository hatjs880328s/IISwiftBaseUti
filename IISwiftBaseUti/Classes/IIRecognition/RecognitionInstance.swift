//
//  RecognitionInstance.swift
//  SalveNumber
//
//  Created by Noah_Shan on 2018/7/18.
//  Copyright © 2018 Inspur. All rights reserved.
//

import Foundation

/// 规则类别
@objc enum RecognitionInsType: Int {
    case phoneNumber
    case date
    case week
    case today
    case email
    case sessionTicket
    case pwdCheck
    case bankPwdNumCheck
    case bankPwdSmallCharCheck
    case bankPwdBigCharCheck
    case bankPwdSpecCharCheck
}

/// 识别出来的结构体信息
@objc class RecognitionInstance: NSObject {
    
    @objc var range: NSRange = NSRange(location: 0, length: 0)
    @objc var type: RecognitionInsType = .week
    @objc var rangeInfo: String = ""
    // 后期处理此date信息
    @objc var realDateInfo: Date = Date()
    
    init(range: NSRange, type: RecognitionInsType, rangeInfo: String) {
        self.range = range
        self.type = type
        self.rangeInfo = rangeInfo
    }
    
    func progressDate(dateInfo: Date) {
        self.realDateInfo = dateInfo
    }
}
