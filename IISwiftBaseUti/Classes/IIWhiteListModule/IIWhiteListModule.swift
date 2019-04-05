//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IIWhiteListModule.swift
//
// Created by    Noah Shan on 2018/9/27
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *

import Foundation

@objc enum IIWhiteListEnum: Int {
    case AOPNBPWhiteModule
    case ScreenShotClassWhiteModule
}

@objc class IIWhiteListModule: NSObject {
    
    var whiteListModules: [IIWhiteListEnum: IIWhiteModuleFather] = [:]
    
    override init() {
        super.init()
        addNewListModule()
    }
    
    /// 添加一个新的白名单区域
    private func addNewListModule() {
        self.whiteListModules[IIWhiteListEnum.AOPNBPWhiteModule] = AOPNBPWhiteModule()
        self.whiteListModules[IIWhiteListEnum.ScreenShotClassWhiteModule] = ScreenShotClassWhiteModule()
    }
    
    /// 在某个白名单区域下获取是否存在这个key
    @discardableResult
    @objc public func getRule(with key: String?, in table: IIWhiteListEnum) -> Bool {
        if key == nil { return false }
        if let keys = self.whiteListModules[table]?.list {
            for i in keys {
                if key == i {
                    return true
                }
            }
        }
        return false
    }
    
}

/// 白名单区域父类
class IIWhiteModuleFather: NSObject {
    var list: [String] = []
    
    override init() {
        super.init()
        addItems()
    }
    
    func addItems() {}
}

/// 为aop-nbp库设置的白名单
class AOPNBPWhiteModule: IIWhiteModuleFather {
    
    override func addItems() {
        super.list.append("15339967446")
        super.list.append("15194181120")
        super.list.append("18615692886")
        super.list.append("18954541787")
    }
}

/// 防止截屏设置的白名单
class ScreenShotClassWhiteModule: IIWhiteModuleFather {
    override func addItems() {
        super.list.append("OpenWebviewViewController")
        super.list.append("NewsDetailComViewController")
        super.list.append("NewsComViewController")
    }
}
