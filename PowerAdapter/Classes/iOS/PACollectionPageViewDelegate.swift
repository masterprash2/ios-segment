//
//  PACollectionPageViewDelegate.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 08/04/20.
//

import Foundation

public protocol PACollectionViewPageDelegate : AnyObject {
    func onPageChanged(_ collectionView : UICollectionView, pagePath: IndexPath)
}

open class PACollectionPageViewDelegate: PACollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var currentPage : IndexPath = IndexPath.init(row: 0, section: 0)
    
    public weak var pageChangeDelegate : PACollectionViewPageDelegate?
    
    override open func bind(_ collectionView: UICollectionView) {
        collectionView.isPagingEnabled = true
        super.bind(collectionView)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(self.currentPage == indexPath) {
            super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        }
    }
    
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateCurrentPage()
    }
    
    
    private func updateCurrentPage() {
        if let collectionView = self.collectionView {
            let center = CGPoint(x: collectionView.contentOffset.x + (collectionView.frame.width / 2), y: collectionView.contentOffset.y + (collectionView.frame.height / 2))
            if let ip = collectionView.indexPathForItem(at: center) {
                if(self.currentPage != ip) {
                    setCurrentPage(collectionView, ip)
                }
            }
        }
        
    }
    
    private func setCurrentPage(_ collectionView : UICollectionView, _ ip : IndexPath) {
        let oldCell = collectionView.cellForItem(at: self.currentPage)
        (oldCell as? PACollectionViewCell)?.willEndDisplay()
        self.currentPage = ip
        let newCell = collectionView.cellForItem(at: self.currentPage)
        (newCell as? PACollectionViewCell)?.willDisplay()
        self.pageChangeDelegate?.onPageChanged(collectionView, pagePath: ip)
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
