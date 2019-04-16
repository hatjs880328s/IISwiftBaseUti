//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IIImageUtility.swift
//
// Created by    Noah Shan on 2018/7/9
// InspurEmail   shanwzh@inspur.com
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *

import UIKit
import Foundation
import SDWebImage

/// 自定义的网络图片获取内存缓存
var IINSPUR_NET_IMGE_CACHE: [String: UIImage] = [:]

/// 给图片设置rendermodel(可以实现tintcolor效果）
extension UIImageView {
    @objc func setRenderImg() {
        self.image = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
}

class IIImageUtility: NSObject {

    /// 静态属性
    static let defaultPersonImg = UIImage(named: "Personal Large")

    /// 裁剪图片-默认1200 * 1200
    func resizeImage(originImg: UIImage, width: CGFloat? = nil, height: CGFloat? = nil) -> UIImage? {
        let scaleWidth: CGFloat = width == nil ? 1_200 : width!
        let scaleHeight: CGFloat = height == nil ? 1_200 : height!
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        originImg.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
    
    /*
     扩大某个图片
     方式:
     只拉伸图片内部，外部的不变（aks部分不变，用来做不定行的下拉列表图片背景很合适）
     拉伸到什么程度：需要到多大都行
     */
    func enlargeImage(image: UIImage) -> UIImage {
        let aks = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let ak = image.resizableImage(withCapInsets: aks, resizingMode: .stretch)
        return ak
    }

    //获取图片某一点的像素值
    func getRGBColor(from image: UIImage, with point: CGPoint) -> UIColor {
        return IIImageUtilityOC.color(atPixel: point, realimage: image)
    }

    /// 根据rect截取当前屏幕
    func copyScreen(with rect: CGRect, from view: UIView) -> UIView? {
        let result = view.resizableSnapshotView(from: rect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return result
    }

    /// 将图片保存到SD缓存下,返回保存图片的路径
    @discardableResult
    func saveImageToSDDiskPath(img: UIImage, imageName: String) -> String {
        let sortPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = sortPath[0].stringByAppendingPathComponent("default").stringByAppendingPathComponent("com.hackemist.SDWebImageCache.default")
        let fileName = imageName//(IMPUserModel.activeInstance()?.exeofidString() ?? "") + Int(Date().timeIntervalSince1970).description + ".png"
        do {
            try FileManager().createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {}
        let realPath = path.stringByAppendingPathComponent(fileName)
        (img.pngData()! as NSData).write(toFile: realPath, atomically: true)
        return realPath
    }

    /// 根据上面方法保存的图片数据-从disk中获取
    func getImageFromCustomDiskcache(imageName: String) -> Data? {
        let sortPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = sortPath[0].stringByAppendingPathComponent("default").stringByAppendingPathComponent("com.hackemist.SDWebImageCache.default")
        let fileName = imageName
        let realPath = path.stringByAppendingPathComponent(fileName)
        var imgData: Data?
        do {
            imgData = try Data(contentsOf: URL(fileURLWithPath: realPath))
        } catch {}
        if imgData == nil {
            return nil
        }
        return imgData!
    }

    /// 将VIEW转换为IMAGE
    func changeVwToImg(vw: UIView) -> UIImage {
        let size = vw.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        vw.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        return image!
    }

    /// 根据url获取网络图片[有内存缓存]
    @objc func getImageFromUrl(placeImgName: String, url: URL, endAction:@escaping (_ img: UIImage?) -> Void) {
        let realIMGKey = url.absoluteString
        // memory cache
        if IINSPUR_NET_IMGE_CACHE[realIMGKey] != nil {
            endAction(IINSPUR_NET_IMGE_CACHE[realIMGKey])
            return
        }
        var imgData: Data!
        var img: UIImage?
        // disk cache thread 2
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
            //disk cache
            if let diskImg = SDImageCache.shared().diskImageData(forKey: realIMGKey) {
                img = SDWebImageCodersManager.sharedInstance().decodedImage(with: diskImg)
            } else {
                //web image
                do {
                    try imgData = Data(contentsOf: url)
                    img = SDWebImageCodersManager.sharedInstance().decodedImage(with: imgData)
                    IINSPUR_NET_IMGE_CACHE[realIMGKey] = img
                    SDImageCache.shared().store(img, forKey: realIMGKey, completion: nil)
                } catch {
                    img = UIImage(named: placeImgName)
                }
            }
        }) {
            if IINSPUR_NET_IMGE_CACHE[realIMGKey] != nil {
                endAction(IINSPUR_NET_IMGE_CACHE[realIMGKey])
                return
            }
            endAction(img)
        }
    }

    /// 根据URL数组生成一个带有圆角的layer-包含图片
    @objc func getImgGroupFromURLArr(arr: [URL], size: CGSize, resultImg: @escaping (_ img: CALayer) -> Void) {
        let imgLayer = IIImageLayer(imageCount: arr.count, size: size)
        for eachItem in 0 ..< arr.count {
            self.getImageFromUrl(placeImgName: "Personal Large", url: arr[eachItem]) { (img) in
                if img == nil { return }
                imgLayer.imageArr[eachItem] = img!
                if imgLayer.progressShouldDisplay() {
                    imgLayer.setNeedsDisplay()
                }
            }
        }
        GCDUtils.toMianThreadProgressSome {
            resultImg(imgLayer)
        }
    }
}
