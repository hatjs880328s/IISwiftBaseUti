//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IICacheStorage.swift
//
// Created by    Noah Shan on 2018/6/15
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *

import Foundation

/// 用来存储库名字，key名字
class IICacheStorage: NSObject {
    
    /// 缓存库名称
    @objc lazy var iiCacheStorageName = "impCloud+CacheStorage"
    
    /// 个人中心-tablist数据源缓存key
    @objc lazy var cloudMinePersonCenterTabList = "cloudMinePersonCenterTabList"
    
    /// 发现-卡包信息
    @objc lazy var discoveryCardsList = "discoveryCardsList"
    
    /// ios11以上是否请求过相册权限
    @objc lazy var iiauthPhotoRequestiOS11Plus = "iiauthPhotoRequestiOS11Plus"
    
    /// webex第一次访问列表，提示创建信息
    @objc lazy var iiwebexFirstCreateMeet = "iiwebexFirstCreateMeet"

    /// 字节码插桩服务是否开启
    @objc lazy var iipitchService = "IIPitchService"

    /// aopnbp服务是否开启
    @objc lazy var iiaopnbpService = "IIAOPNBPService"

    /// exchange邮箱-证书信息
    @objc lazy var iiexcCERFileInfos = "iiexcCERFileInfos"

    /// exchange邮箱-全局配置-是否加签 + userid
    @objc lazy var iiexcIsSign = "iiexcIsSign"

    /// exchange邮箱-全局配置-是否加密 + userid
    @objc lazy var iiexcIsSecu = "iiexcIsSecu"

    /// 个人中心-用户信息栏-底部list数据
    @objc lazy var personcenterUserBotListData = "personcenterUserBotListData"

    /// 工作页面 日试图 | 列表试图的切换
    @objc lazy var workbenchtoggleVw = "workbenchtoggleVw"
    
    override init() {
        super.init()
    }
}
