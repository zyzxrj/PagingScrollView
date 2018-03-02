//
//  PagingScrollView.swift
//  PagingScrollView
//
//  Created by mac on 29/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class PagingScrollView: UIScrollView {
    
    /// The width, in points, of each page. Set to a non-positive number to use the view's width. Default is 0. 不设置或者负数默认分页大小为bound.width
    public var pageWidth: CGFloat {
        get{
            return _pageWidth
        }
        set {
            if newValue == _pageWidth {
                return
            }
            _pageWidth = newValue
        }

    }

    
    /// The height, in points, of each page. Set to a non-positive number to use the view's height. Default is 0. 不设置或者负数默认分页大小为bound.height
    public var pageHeight: CGFloat {
        get{
            return _pageHeight
        }
        set {
            if newValue == _pageHeight {
                return
            }
            _pageHeight = newValue
        }
        
    }
    
    // MARK: - private
    
    private var _delegateRespondsToWillBeginDragging: Bool = false
    private var _delegateRespondsToWillEndDragging: Bool = false
    private var _delegateRespondsToDidEndDragging: Bool = false
    private var _delegateRespondsToDidEndDecelerating: Bool = false
    private var _delegateRespondsToDidEndScrollingAnimation: Bool = false
    private var _delegateRespondsToDidEndZooming: Bool = false

    private var _snapping: Bool = false
    
    /// 记录上次偏移量
    private var _lastOffset: CGPoint = .zero
    
    private var _pagingEnabled: Bool = false
    private var _actualDelegate: UIScrollViewDelegate?
    
    private var _pageWidth: CGFloat = 0 {
        didSet{
            if _pagingEnabled {
                snapToPage()
            }
        }
    }
    private var _pageHeight: CGFloat = 0 {
        didSet{
            if _pagingEnabled {
                snapToPage()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        performInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        performInit()
    }
    
    private func performInit() {
        super.delegate = self
        
        if super.isPagingEnabled {
            super.isPagingEnabled = false
            _pagingEnabled = true
        }
    }
    
    override var delegate: UIScrollViewDelegate? {
        set{
            if newValue == nil {
                return
            }
            
//            if newValue!.isKind(of: PagingScrollView.self) == false {
//                _actualDelegate = newValue
//            }
            _actualDelegate = newValue
            _delegateRespondsToWillBeginDragging = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))
            _delegateRespondsToWillEndDragging = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
            _delegateRespondsToDidEndDragging = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
            _delegateRespondsToDidEndDecelerating = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
            
            _delegateRespondsToDidEndScrollingAnimation = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:)))
            _delegateRespondsToDidEndZooming = _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:)))
        }
        get{
            return _actualDelegate
        }
    }
    
    /// 自定义分页，不可同时开启系统
    public var customPagingEnabled: Bool {
        set{
            if newValue == _pagingEnabled {
                return
            }
            _pagingEnabled = newValue
            
            if _pagingEnabled {
                snapToPage()
            }
        }
        get {
            return _pagingEnabled
        }
        
    }
    
    
    fileprivate func snapToPage() {
        var pageOffset: CGPoint = .zero
        pageOffset.x = pageOffsetForComponent(isX: true)
        pageOffset.y = pageOffsetForComponent(isX: false)
        
        let currentOffset = self.contentOffset
        
        if !pageOffset.equalTo(currentOffset) {
            _snapping = true
//            print("setpageOffset: \(pageOffset)")
            setContentOffset(pageOffset, animated: true)
        }
        _lastOffset = .zero
    }
    
    
    fileprivate func pageOffsetForComponent(isX: Bool) -> CGFloat {
        //如果 滚动所在的方向frame = .zero,或者contentSize = .zero 就不执行下面的操作
        if ((isX ? self.bounds.width : self.bounds.height) == 0) || ((isX ? self.contentSize.width : self.contentSize.height) == 0){
            return 0
        }
        var pageLength = isX ? _pageWidth : _pageHeight;
        if pageLength <= 0 {
            pageLength = isX ? self.bounds.width : self.bounds.height
        }
        pageLength *= self.zoomScale
        
        let totalLength = isX ? self.contentSize.width : self.contentSize.height
        let visibleLength = (isX ? self.bounds.width : self.bounds.height) * self.zoomScale
        
        let currentOffset = isX ? self.contentOffset.x : self.contentOffset.y
        
        let dragDisplacement = isX ? currentOffset - _lastOffset.x : currentOffset - _lastOffset.y
        
        var newOffset: CGFloat = 0
        var index = currentOffset / pageLength
        let lowerIndex = floor(index)
        let upperIndex = ceil(index)
        
        if dragDisplacement >= 0 {
            index = upperIndex
        }else {
            index = lowerIndex
        }
        
        newOffset = pageLength * index
        if newOffset > totalLength - visibleLength {
            newOffset = totalLength - visibleLength
        }
        if newOffset < 0 {
            newOffset = 0
        }
        return newOffset
    }
    
}

extension PagingScrollView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lastOffset = scrollView.contentOffset

        if _delegateRespondsToWillBeginDragging {
            _actualDelegate?.scrollViewWillBeginDragging!(scrollView)
        }

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if _pagingEnabled {
            let contentOffset = targetContentOffset //这边不设置就会走scrollViewDidEndDecelerating 一直等停了才会慢慢滚动到相应位置
            contentOffset.pointee = scrollView.contentOffset

        }

        if _delegateRespondsToWillEndDragging {
            _actualDelegate?.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate && _pagingEnabled {
            snapToPage()
        }

        if _delegateRespondsToDidEndDragging {
            _actualDelegate?.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if _pagingEnabled {
            snapToPage()
        }

        if _delegateRespondsToDidEndDecelerating {
            _actualDelegate?.scrollViewDidEndDecelerating!(scrollView)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if !_snapping && _pagingEnabled {
            snapToPage()
        }else {
            _snapping = false
        }

        if _delegateRespondsToDidEndScrollingAnimation {
            _actualDelegate?.scrollViewDidEndScrollingAnimation!(scrollView)
        }
    }

    //视图放大或者缩小结束时
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

        if _pagingEnabled {
            snapToPage()
        }

        if _delegateRespondsToDidEndZooming {
            _actualDelegate?.scrollViewDidEndZooming!(scrollView, with: view, atScale: scale)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))) {
            _actualDelegate?.scrollViewDidScroll!(scrollView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidZoom(_:))) {
            _actualDelegate!.scrollViewDidZoom!(scrollView)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:))) {
            _actualDelegate!.scrollViewWillBeginDecelerating!(scrollView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.viewForZooming(in:))) {
            return _actualDelegate!.viewForZooming!(in:scrollView)
        }
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginZooming(_:with:))) {
            _actualDelegate!.scrollViewWillBeginZooming!(scrollView, with: view)
        }
    }
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewShouldScrollToTop(_:))) {
            return _actualDelegate!.scrollViewShouldScrollToTop!(scrollView)
        }
        return false
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))) {
            return _actualDelegate!.scrollViewDidScrollToTop!(scrollView)
        }
    }
    
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if _actualDelegate != nil && _actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidChangeAdjustedContentInset(_:))) {
            return _actualDelegate!.scrollViewDidChangeAdjustedContentInset!(scrollView)
        }
    }
}
