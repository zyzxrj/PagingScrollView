//
//  ViewController.swift
//  PagingScrollView
//
//  Created by mac on 29/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let pageWidth: CGFloat = 300
    let pageHeight: CGFloat = 400
    

    var scrollView: PagingScrollView!
//    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        setHorizontalPageSubView()
        setVerticalPageSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setHorizontalPageSubView() {
        let count = 5
        let size = self.view.frame.size
        scrollView = PagingScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        scrollView.delegate = self
        scrollView.customPagingEnabled = true
        
        //水平分页 - horizontal
        scrollView.pageWidth = pageWidth
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(count), height: size.height)
        

        self.view.addSubview(scrollView)
        
        for i in 0..<count {
            
            let view = UIView(frame: CGRect(x: pageWidth * CGFloat(i), y: 0, width: pageHeight, height: size.height))//水平分页 - horizontal
            let label = createLabel()
            label.text = "This is page \(i) "
            label.center = CGPoint.init(x: pageWidth/2, y: view.center.y) //水平分页 - horizontal
            view.addSubview(label)
            view.backgroundColor = UIColor.init(white: CGFloat(i)/5.0, alpha: 1)
            scrollView.addSubview(view)
        }
        
    }
    
    private func setVerticalPageSubView() {
        let count = 5
        let size = self.view.frame.size
        scrollView = PagingScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        scrollView.delegate = self
        scrollView.customPagingEnabled = true
        
        //垂直分页
        scrollView.pageHeight = pageHeight
        scrollView.contentSize = CGSize(width: size.width, height: pageHeight * CGFloat(count))
        self.view.addSubview(scrollView)
        
        for i in 0..<count {
            let view = UIView(frame: CGRect(x: 0, y: pageHeight * CGFloat(i), width: size.width, height: pageHeight))//垂直分页
            let label = createLabel()
            label.text = "This is page \(i) "
            label.center = CGPoint.init(x: view.center.x, y:  pageHeight/2)
            view.addSubview(label)
            view.backgroundColor = UIColor.init(white: CGFloat(i)/5.0, alpha: 1)
            scrollView.addSubview(view)
        }
        
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: pageWidth/2, height: 20))
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }

}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("out - scrollViewDidScroll")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("out - scrollViewWillBeginDragging")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("out - scrollViewWillEndDragging")
    }
    
    
}


