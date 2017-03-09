//
//  AlbumView.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/27.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class AlbumView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AlbumViewDelegate{
    var indexPath: IndexPath!
    var collectionView:UICollectionView!
    let identifier = "Cell"
    var filePath = ""
    
    init(path:String) {
        super.init(frame: CGRect.zero)
        self.filePath = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        initLayout()
    }
    
    func initLayout() {
        if(collectionView != nil){ return }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear//背景色为透明
        collectionView.isPagingEnabled = true//每次滚一页
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AlbumViewCell.self, forCellWithReuseIdentifier: identifier)
        self.addSubview(collectionView)
        
        if(indexPath != nil){
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.frame.size.width, height: self.frame.size.height)
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell: AlbumViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumViewCell
        cell.setData(filePath)
        cell.delegate = self
        return cell
        
    }
    func onAlbumItemClick(){
        //点击cell回调
    }
}
class AlbumViewCell: UICollectionViewCell ,UIScrollViewDelegate{
    var vScrollView: UIScrollView!
    var startContentOffsetX :CGFloat!
    var startContentOffsetY :CGFloat!
    var vImage: UIImageView!
    var delegate: AlbumViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vImage = UIImageView()
        vImage.frame.size = frame.size
        vImage.contentMode = UIViewContentMode.scaleAspectFit
        
        vScrollView = UIScrollView()
        vScrollView.frame.size = frame.size
        vScrollView.addSubview(vImage)
        
        vScrollView.delegate = self
        vScrollView.minimumZoomScale = 0.5
        vScrollView.maximumZoomScale = 2
        vScrollView.showsVerticalScrollIndicator = false
        vScrollView.showsHorizontalScrollIndicator = false
        //添加单击
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AlbumViewCell.scrollViewTapped(_:)))
        vScrollView.addGestureRecognizer(tapRecognizer)
        self.addSubview(vScrollView)
    }
    
    func setData(_ path:String) {
        vScrollView.zoomScale = 1
        vImage.image = UIImage(contentsOfFile:path)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return vImage
    }
    //缩放触发
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()//缩小图片的时候把图片设置到scrollview中间
    }
    func centerScrollViewContents() {
        let boundsSize = vScrollView.bounds.size
        var contentsFrame = vImage.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        vImage.frame = contentsFrame
    }
    func scrollViewTapped(_ recognizer: UITapGestureRecognizer) {
        //单击回调
        if(delegate != nil){
            delegate.onAlbumItemClick()
        }
    }
    
}
protocol AlbumViewDelegate{
    func onAlbumItemClick()
}

