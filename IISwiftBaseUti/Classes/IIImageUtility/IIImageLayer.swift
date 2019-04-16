//
//  IIImageLayer.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2018/9/7.
//  Copyright © 2018 Elliot. All rights reserved.
//

import Foundation
import UIKit

/*
 FEATHRE:
 
 1.个人、群组默认头像使用contents设置
 2.头像生成完毕之后才发起一次重绘
 3.头像的layer在业务层缓存
 4.头像的单个图片使用MEM DISK缓存
 5.2张图片时-使用2个smalllayer拼凑
 6.3个图片时-左侧的大图使用smalllayer拼凑
 7.拼凑的原因是：单个layer中的gravity属性不适用于多数据拼凑
 8.切记-此处不应该使用mask-calayer等，绝对不可造成离屏渲染等问题，否则性能很差
 
 */
class IIImageLayer: CALayer {
    // 图片个数
    var imageCount = 0
    
    /// CGRECT数组-无需重复计算
    var imageCGRect: [CGRect] = []
    
    var imageArr: [Int: UIImage] = [:]
    
    // 当前frame-size-height 的一半
    var sizeHeight: CGFloat = 0.0
    
    /// 分割线宽度的一半
    var splitWeight: CGFloat = 0.5
    
    var leftLayer: Small2Layer?
    
    var rightLayer: Small2Layer?
    
    var thirdLeftLayer: Small2Layer?
    
    init(imageCount: Int, size: CGSize) {
        super.init()
        self.imageCount = imageCount
        self.frame.size = size
        self.sizeHeight = size.height / 2
        self.cornerRadius = sizeHeight
        self.masksToBounds = true
        self.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.white.cgColor
        progressCGRect()
        progressDefaultLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 判定image是否满加载
    func progressShouldDisplay() -> Bool {
        if self.imageArr.count == imageCount {
            return true
        }
        return false
    }
    
    func progressDefaultLayer() {
        switch self.imageCount {
        case 1:
            self.contents = UIImage(named: "Personal Large")?.cgImage
        default:
            self.contents = UIImage(named: "Group Large")?.cgImage
        }
    }
    
    override func draw(in ctx: CGContext) {
        //防止图片倒转
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -sizeHeight * 2)
        switch self.imageCount {
        case let a where a == 1 || a == 4:
            for eachItem in 0 ..< imageArr.count {
                if let img = imageArr[eachItem]?.cgImage {
                    ctx.draw(img, in: self.imageCGRect[eachItem], byTiling: false)
                }
            }
        case 2:
            if let leftImage = imageArr[0] {
                leftLayer?.setImage(image: leftImage)
                self.addSublayer(leftLayer!)
            }
            if let rightImage = imageArr[1] {
                rightLayer?.setImage(image: rightImage)
                self.addSublayer(rightLayer!)
            }
        case 3:
            for eachItem in 0 ..< imageArr.count {
                if eachItem == 0 {
                    if let thirdIMG = imageArr[0] {
                        thirdLeftLayer?.setImage(image: thirdIMG)
                        self.addSublayer(thirdLeftLayer!)
                    }
                } else {
                    if let img = imageArr[eachItem]?.cgImage {
                        ctx.draw(img, in: self.imageCGRect[eachItem], byTiling: false)
                    }
                }
            }
        default:
            break
        }
        //绘制完毕时，将img数组清空
        self.imageArr.removeAll()
    }
    
    /// 静态计算frameA
    func progressCGRect() {
        switch self.imageCount {
        case 1:
            self.imageCGRect.append(CGRect(x: 0, y: 0, width: sizeHeight * 2, height: sizeHeight * 2))
        case 2:
            leftLayer = Small2Layer(frame: CGRect(x: 0, y: 0, width: sizeHeight - splitWeight, height: sizeHeight * 2))
            rightLayer = Small2Layer(frame: CGRect(x: sizeHeight + splitWeight, y: 0, width: sizeHeight - splitWeight, height: sizeHeight * 2))
        case 3:
            for eachItem in 0 ..< imageCount {
                if eachItem == 0 {
                    var frame = CGRect()
                    frame.origin = CGPoint(x: 0, y: 0)
                    frame.size = CGSize(width: sizeHeight - splitWeight, height: sizeHeight * 2)
                    self.imageCGRect.append(frame)
                    self.thirdLeftLayer = Small2Layer(frame: frame)
                } else if eachItem == 1 {
                    self.imageCGRect.append(CGRect(x: sizeHeight + splitWeight, y: 0, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                } else {
                    self.imageCGRect.append(CGRect(x: sizeHeight + splitWeight, y: sizeHeight + splitWeight, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                }
            }
        case 4:
            for eachItem in 0 ..< imageCount {
                if eachItem == 0 {
                    self.imageCGRect.append(CGRect(x: 0, y: 0, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                } else if eachItem == 1 {
                    self.imageCGRect.append(CGRect(x: sizeHeight + splitWeight, y: 0, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                } else if eachItem == 2 {
                    self.imageCGRect.append(CGRect(x: 0, y: sizeHeight + splitWeight, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                } else {
                    self.imageCGRect.append(CGRect(x: sizeHeight + splitWeight, y: sizeHeight + splitWeight, width: sizeHeight - splitWeight, height: sizeHeight - splitWeight))
                }
            }
        default:
            break
        }
    }
}

/// small layer
class Small2Layer: CALayer {
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.white.cgColor
        self.contentsGravity = CALayerContentsGravity.resizeAspectFill
        self.masksToBounds = true
    }
    
    func setImage(image: UIImage) {
        self.contents = image.cgImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
