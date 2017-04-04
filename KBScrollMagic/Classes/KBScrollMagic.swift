//
//  KBScrollMagic.swift
//  KBScrollMagic
//
//  Created by liyang on 2017/4/2.
//  Copyright © 2017年 Wolf Street. All rights reserved.
//

import Foundation

public protocol KBScrollMagicDelegate {
    
    func scrollMagicDidEndDrag(when superScrollView: UIScrollView, offSetY: CGFloat) -> Void
    
}

extension UIScrollView: KiritoBeaterCompatible {
    
    func panGestureHandel(_ press: UIPanGestureRecognizer) {
        
        if let superScrollView = kb.superScrollView {
            let currentPoint = press.translation(in: superScrollView)
            
            if press.state == .began {
                kb.setLastDragPoint(currentPoint)
            }
            
            /// Super实际偏移量的Y值
            let superOffsetY = superScrollView.contentOffset.y
            /// Super相对于滚动起点的偏移量的Y值
            let superPositionY = superOffsetY + superScrollView.contentInset.top
            /// Super实际0点的偏移量
            let superZeroPoint = CGPoint(x: superScrollView.contentOffset.x, y: -superScrollView.contentInset.top)
            
            /// 实际偏移量的Y值
            let offsetY = self.contentOffset.y
            /// 相对于滚动起点的偏移量的Y值
            let positionY = offsetY + self.contentInset.top
            /// 实际0点的偏移量
            let zeroPoint = CGPoint(x: self.contentOffset.x, y: -self.contentInset.top)

            
            if let lastPoint = kb.lastDragPoint {
                let distanceY = currentPoint.y - lastPoint.y
                if superPositionY < kb.insetY && distanceY < 0 {
                    self.contentOffset = zeroPoint
                    let willOffsetY = superOffsetY - distanceY
                    let willPositionY = superPositionY - distanceY
                    if willPositionY > kb.insetY {
                        superScrollView.contentOffset = CGPoint(x: superScrollView.contentOffset.x, y: kb.insetY - superScrollView.contentInset.top)
                    } else {
                        superScrollView.contentOffset = CGPoint(x: superScrollView.contentOffset.x, y: willOffsetY)
                    }
                }
                
                if positionY <= 0 && distanceY > 0 {
                    
                    if self.bounces {
                        if superPositionY >= 0 {
                            self.contentOffset = zeroPoint
                            superScrollView.contentOffset = CGPoint(x: superScrollView.contentOffset.x, y: superOffsetY - distanceY)
                        }
                    } else {
                        if !superScrollView.bounces && superPositionY <= 0 {
                            self.contentOffset = zeroPoint
                            superScrollView.contentOffset = superZeroPoint
                        } else {
                            self.contentOffset = zeroPoint
                            superScrollView.contentOffset = CGPoint(x: superScrollView.contentOffset.x, y: superOffsetY - distanceY)
                        }
                    }
                }
            }
            
            if press.state == .ended && superPositionY < 0 {
                superScrollView.setContentOffset(superZeroPoint, animated: true)
            }
            
            if press.state == .ended {
                kb.delegate?.scrollMagicDidEndDrag(when: superScrollView, offSetY: superPositionY)
                kb.setLastDragPoint(nil)
            } else {
                kb.setLastDragPoint(currentPoint)
            }
            
        }
    }
}

private var lastDragPointKey: Void?
private var superScrollViewKey: Void?
private var insetYKey: Void?
private var delegateKey: Void?

extension KiritoBeater where Base: UIScrollView {
    
    public func setSuperScrollView(_ superSV: UIScrollView ) {
        
        if let _ = superScrollView {
            base.panGestureRecognizer.removeTarget(base, action: #selector(base.panGestureHandel(_:)))
        }
        
        objc_setAssociatedObject(base, &superScrollViewKey, superSV, .OBJC_ASSOCIATION_ASSIGN)
        base.panGestureRecognizer.addTarget(base, action: #selector(base.panGestureHandel(_:)))
    }
    
    
    /// 当需要实现SuperScrollViwe 下拉刷新时可设置此代理
    ///
    /// - Parameter delegate: 当需要实现SuperScrollViwe 下拉刷新时可设置此代理
    public func setDelegate(_ delegate: KBScrollMagicDelegate?) {
        objc_setAssociatedObject(base, &delegateKey, delegate, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    public func setinsetY(_ y: CGFloat ) {
        objc_setAssociatedObject(base, &insetYKey, y, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    
    
    fileprivate var superScrollView: UIScrollView? {
        return objc_getAssociatedObject(base, &superScrollViewKey) as? UIScrollView
    }
    
    fileprivate func setLastDragPoint(_ lastPoint: CGPoint?) {
        objc_setAssociatedObject(base, &lastDragPointKey, lastPoint, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    fileprivate var lastDragPoint: CGPoint? {
        return objc_getAssociatedObject(base, &lastDragPointKey) as? CGPoint
    }
    
    fileprivate var delegate: KBScrollMagicDelegate? {
        return objc_getAssociatedObject(base, &delegateKey) as? KBScrollMagicDelegate
    }

    fileprivate var insetY: CGFloat {
        if let y = objc_getAssociatedObject(base, &insetYKey) as? CGFloat {
            return y
        } else {
            return CGFloat(0)
        }
    }
}

public final class KiritoBeater<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol KiritoBeaterCompatible {
    associatedtype CompatibleType
    var kb: CompatibleType { get }
}

public extension KiritoBeaterCompatible {
    public var kb: KiritoBeater<Self> {
        get { return KiritoBeater(self) }
    }
}

