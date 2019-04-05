//
//  *******************************************
//  
//  HeapSort.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2019/2/21.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//

import UIKit

/*
 HeapSort-堆排序
 思路：
 1.如果最终结果需要是升序，则需要使用大顶堆（根最大），反之使用小顶堆（根最小）]

 2.实现思路：下面以升序为例
 a.将无需数组构造为一个堆结构[还是在数组中表示]
 b.然后将根节点和最末尾的节点交换位置
 c.交过位置过后，再次生成一个堆结构（排除最末尾最大的那个节点）
 d.再次将根（最大值）和堆中最末尾交换  重复cd两步

 HeapSort是不稳定排序<排序前俩相同的元素AB,排序后，他俩顺序不变则表示稳定>
 */

public enum HeapSortType: Int {
    case asc
    case desc
}

/// 私有拓展
private extension Int {

    var parent: Int {
        return (self - 1) / 2
    }

    var leftChild: Int {
        return (self * 2) + 1
    }

    var rightChild: Int {
        return (self * 2) + 2
    }
}

public extension Array where Element: Comparable {
    public mutating func heapSort() {
        buildHeap()
        shrinkHeap()
    }

    private mutating func buildHeap() {
        for index in 1..<self.count {
            var child = index
            var parent = child.parent
            while child > 0 && self[child] > self[parent] {
                swapAt(child, parent)
                child = parent
                parent = child.parent
            }
        }
    }

    private mutating func shrinkHeap() {
        for index in stride(from: self.count - 1, to: 0, by: -1) {
            swapAt(0, index)
            var parent = 0
            var leftChild = parent.leftChild
            var rightChild = parent.rightChild
            while parent < index {
                var maxChild = -1
                if leftChild < index {
                    maxChild = leftChild
                } else {
                    break
                }
                if rightChild < index && self[rightChild] > self[maxChild] {
                    maxChild = rightChild
                }
                guard self[maxChild] > self[parent] else { break }

                swapAt(parent, maxChild)
                parent = maxChild
                leftChild = parent.leftChild
                rightChild = parent.rightChild
            }
        }
    }
}
