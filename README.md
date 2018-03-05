# PagingScrollView
Custom ScrollView's page size,not associated the bounds

![horizontal paging](http://img.blog.csdn.net/20180305110303863?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvenl6eHJq/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![vertical paging](http://img.blog.csdn.net/20180305110358560?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvenl6eHJq/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

Usage
==============

```
        //horizontal 
        let count = 5
        let size = self.view.frame.size
        scrollView = PagingScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        scrollView.delegate = self
        scrollView.customPagingEnabled = true
        
        //水平分页 - horizontal
        scrollView.pageWidth = pageWidth
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(count), height: size.height)
        self.view.addSubview(scrollView)
```

```
        //vertical
                let count = 5
        let size = self.view.frame.size
        scrollView = PagingScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        scrollView.delegate = self
        scrollView.customPagingEnabled = true
        
        //垂直分页
        scrollView.pageHeight = pageHeight
        scrollView.contentSize = CGSize(width: size.width, height: pageHeight * CGFloat(count))
        self.view.addSubview(scrollView)
```
