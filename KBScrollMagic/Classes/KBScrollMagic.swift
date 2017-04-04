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

extension UIScrollView: KBScrollMagicCompatible {
    
    func panGestureHandel(_ press: UIPanGestureRecognizer) {
        
        if let superScrollView = kbs.superScrollView {
            let currentPoint = press.translation(in: superScrollView)
            
            if press.state == .began {
                kbs.setLastDragPoint(currentPoint)
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

            
            if let lastPoint = kbs.lastDragPoint {
                let distanceY = currentPoint.y - lastPoint.y
                if superPositionY < kbs.insetY && distanceY < 0 {
                    self.contentOffset = zeroPoint
                    let willOffsetY = superOffsetY - distanceY
                    let willPositionY = superPositionY - distanceY
                    if willPositionY > kbs.insetY {
                        superScrollView.contentOffset = CGPoint(x: superScrollView.contentOffset.x, y: kbs.insetY - superScrollView.contentInset.top)
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
                kbs.delegate?.scrollMagicDidEndDrag(when: superScrollView, offSetY: superPositionY)
                kbs.setLastDragPoint(nil)
            } else {
                kbs.setLastDragPoint(currentPoint)
            }
            
        }
    }
}

private var lastDragPointKey: Void?
private var superScrollViewKey: Void?
private var insetYKey: Void?
private var delegateKey: Void?

extension KBScrollMagic where Base: UIScrollView {
    
    public func set(superScrollView: UIScrollView, insetY: CGFloat = 0, delegate: KBScrollMagicDelegate? = nil) {
        setSuperScrollView(superScrollView)
        setinsetY(insetY)
        setDelegate(delegate)
    }
    
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

public final class KBScrollMagic<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol KBScrollMagicCompatible {
    associatedtype CompatibleType
    var kbs: CompatibleType { get }
}

public extension KBScrollMagicCompatible {
    public var kbs: KBScrollMagic<Self> {
        get { return KBScrollMagic(self) }
    }
}

