//
//  PAFlipper.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 07/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

public protocol PAFlipperViewDataSource : AnyObject {
    func numberOfPagesinFlipper(_ flipperView : PAFlipperView) -> Int;
}

public protocol PAFlipperViewPageDelegate : AnyObject {
    
    func flipperView(_ flipperView : PAFlipperView, viewForPageAt index: Int) -> UIView

    func flipperView(_ flipperView : PAFlipperView, willDisplay page: UIView, forRowAt index: Int)
    
    func flipperView(_ flipperView : PAFlipperView, didEndDisplaying page: UIView, forRowAt index: Int)
    
    func flipperView(_ flipperView : PAFlipperView, destroy page: UIView, forRowAt index: Int)
    
    func onPageChanged(_ flipperView : PAFlipperView, pageIndex: Int, page : UIView)
}

public class PAFlipperView : UIView {
    
    //enum forflip direction
    enum PAFlipDirection : Int {
        case FlipDirectionTop
        case FlipDirectionBottom
    }
    
    private var pannedHasFailed = false
    private var pannedInitialized = false
    private var pannedLastPage = 0
    
    private var currentPageIndex = 0
    private var nextPageIndex = 0
    private var numberOfPages = 0
    private var backgroundLayer: CALayer?
    private var flipLayer: CALayer?
    private var flipDirection: PAFlipDirection?
    private var startFlipAngle: Float = 0.0
    private var endFlipAngle: Float = 0.0
    private var currentAngle: Float = 0.0
    private var setNextViewOnCompletion = false
    private var animating = false
    private var tapRecognizer: UITapGestureRecognizer?
    private var panRecognizer: UIPanGestureRecognizer?
    
    private var lastPageNotificationIndex = 1
    
    private let previous = Page()
    private let current = Page()
    private let nextPage = Page()
    
    private var currentView : UIView?
    private var nextView : UIView?
    
    weak var dataSource : PAFlipperViewDataSource?
    weak var delegate : PAFlipperViewPageDelegate?
    
    //#pragma init method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        addGestureRecognizer(panRecognizer!)
        addGestureRecognizer(tapRecognizer!)
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func initFlip() {
        
        //create image from UIView
        let currentImage = image(byRenderingView: currentView)
        let newImage = image(byRenderingView: nextView)
        
        currentView?.alpha = 0
        nextView?.alpha = 0
        
        backgroundLayer = CALayer()
        backgroundLayer?.frame = bounds
        backgroundLayer?.zPosition = -300000
        
        //create top & bottom layer
        var rect = bounds
        rect.size.height /= 2
        
        let topLayer = CALayer()
        topLayer.frame = rect
        topLayer.masksToBounds = true
        topLayer.contentsGravity = .bottom
        
        backgroundLayer?.addSublayer(topLayer)
        
        rect.origin.y = rect.size.height
        
        let bottomLayer = CALayer()
        bottomLayer.frame = rect
        bottomLayer.masksToBounds = true
        bottomLayer.contentsGravity = .top
        
        backgroundLayer?.addSublayer(bottomLayer)
        
        if flipDirection == .FlipDirectionBottom {
            // flip from top to bottom
            topLayer.contents = newImage?.cgImage
            bottomLayer.contents = currentImage?.cgImage
        } else {
            //flip from bottom to top
            topLayer.contents = currentImage?.cgImage
            bottomLayer.contents = newImage?.cgImage
        }
        
        if let backgroundLayer = backgroundLayer {
            layer.addSublayer(backgroundLayer)
        }
        
        rect.origin.y = 0
        
        flipLayer = CATransformLayer()
        flipLayer?.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        flipLayer?.frame = rect
        
        if let flipLayer = flipLayer {
            layer.addSublayer(flipLayer)
        }
        
        let backLayer = CALayer()
        backLayer.frame = flipLayer?.bounds ?? CGRect.zero
        backLayer.isDoubleSided = false
        backLayer.masksToBounds = true
        
        flipLayer?.addSublayer(backLayer)
        
        let frontLayer = CALayer()
        frontLayer.frame = flipLayer?.bounds ?? CGRect.zero
        frontLayer.isDoubleSided = false
        frontLayer.masksToBounds = true
        frontLayer.transform = CATransform3DMakeRotation(.pi, 1.0, 0.0, 0)
        
        flipLayer?.addSublayer(frontLayer)
        
        if flipDirection == .FlipDirectionBottom {
            backLayer.contents = currentImage?.cgImage
            backLayer.contentsGravity = .bottom
            
            frontLayer.contents = newImage?.cgImage
            frontLayer.contentsGravity = .top
            
            var transform = CATransform3DMakeRotation(0.0, 1.0, 0.0, 0.0)
            transform.m34 = -1.0 / 500.0
            
            flipLayer?.transform = transform
            
            startFlipAngle = 0
            currentAngle = startFlipAngle
            endFlipAngle = .pi
        } else {
            backLayer.contentsGravity = .bottom
            backLayer.contents = newImage?.cgImage
            
            frontLayer.contents = currentImage?.cgImage
            frontLayer.contentsGravity = .top
            
            var transform = CATransform3DMakeRotation(.pi, 1.0, 0.0, 0.0)
            transform.m34 = 1.0 / 500.0
            
            flipLayer?.transform = transform
            
            startFlipAngle = .pi
            currentAngle = startFlipAngle
            endFlipAngle = 0
        }
    }
    
    //#pragma flip
    @objc func flipPage() {
        setFlipProgress(1.0, setDelegate: true, animate: true)
    }
    
    func setFlipProgress(_ progress: Float, setDelegate: Bool, animate: Bool) {
        if animate {
            animating = true
        }
        
        let angle = startFlipAngle + progress * (endFlipAngle - startFlipAngle)
        
        let duration = animate ? 0.5 * abs((angle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0
        
        currentAngle = angle
        
        var finalTransform = CATransform3DIdentity
        finalTransform.m34 = 1.0 / 1500.0
        finalTransform = CATransform3DRotate(finalTransform, CGFloat(angle), 1.0, 0.0, 0.0)
        
        flipLayer?.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
        
        flipLayer?.transform = finalTransform
        
        CATransaction.commit()
        
        if setDelegate {
            perform(#selector(cleanupFlip), with: nil, afterDelay: TimeInterval(duration))
        }
    }
    
    //clear flip & background layer
    @objc func cleanupFlip() {
        
        backgroundLayer?.removeFromSuperlayer()
        flipLayer?.removeFromSuperlayer()
        
        backgroundLayer = nil
        flipLayer = nil
        
        animating = false
        
        
        if setNextViewOnCompletion {
            let oldPageIndex = currentPageIndex
            currentView?.removeFromSuperview()
            currentPageIndex = nextPageIndex
            if(currentView != nil) {
                delegate!.flipperView(self, didEndDisplaying: currentView!, forRowAt: (oldPageIndex - 1))
                delegate!.flipperView(self, destroy: currentView!, forRowAt: (oldPageIndex - 1))
            }
            currentView = nextView
            if(currentView != nil) {
                delegate!.flipperView(self, willDisplay: currentView!, forRowAt: (currentPageIndex - 1))
            }
            nextView = nil
        } else {
            nextView?.removeFromSuperview()
            if(nextView != nil) {
                delegate!.flipperView(self, destroy: nextView!, forRowAt: (nextPageIndex - 1))
            }
            nextView = nil
        }
        postPageChangeNotification()
        currentView?.alpha = 1
    }
    
    
    private func postPageChangeNotification() {
        if(currentView == nil) {
            return
        }
        if(lastPageNotificationIndex != currentPageIndex) {
            lastPageNotificationIndex = currentPageIndex
            let index = currentPageIndex
            let view = currentView!
            DispatchQueue.main.async {
                self.delegate?.onPageChanged(self, pageIndex: index, page: view)
            }
        }
    }
    
    //#pragma selector
    @objc func animationDidStop(_ animationID: String?, finished: NSNumber?, context: UnsafeMutableRawPointer?) {
        cleanupFlip()
    }
    
    //#pragma setter
    func setCurrentPage(_ page: Int) {
        
        if !canSetCurrentPage(page) {
            return
        }
        
        setNextViewOnCompletion = true
        animating = true
        
        nextView?.alpha = 0
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(animationDidStop(_:finished:context:)))
        
        nextView?.alpha = 1
        
        UIView.commitAnimations()
    }
    
    public func setCurrentPage(_ page: Int, animated: Bool) {
        if !canSetCurrentPage(page) {
            return
        }
        
        setNextViewOnCompletion = true
        animating = true
        
        if animated {
            initFlip()
            perform(#selector(flipPage), with: nil, afterDelay: 0.001)
        } else {
            animationDidStop(nil, finished: NSNumber(value: false), context: nil)
        }
        
    }
    
    public func setDataSource(_ dataSource: PAFlipperViewDataSource) {
        self.dataSource = dataSource
        numberOfPages = self.dataSource!.numberOfPagesinFlipper(self)
        currentPageIndex = 0
        lastPageNotificationIndex = 1
        //pagecontrol current page
        perform(#selector(setFirstPage), with: nil, afterDelay: 0.001)
    }
    
    @objc func setFirstPage() {
        setCurrentPage(1, animated: false)
    }
    
    func canSetCurrentPage(_ page: Int) -> Bool {
        
        if page == currentPageIndex {
            return false
        }
        
        flipDirection = page < currentPageIndex ? .FlipDirectionBottom : .FlipDirectionTop
        nextPageIndex = page
        nextView = delegate!.flipperView(self, viewForPageAt: nextPageIndex - 1 )
        addSubview(nextView!)
        
        return true
    }
    
    //#pragma Gesture recognizer handler
    @objc func tapped(_ recognizer: UITapGestureRecognizer?) {
        
        if !animating {
            if recognizer?.state == .recognized {
                var newPage: Int
                
                if (recognizer?.location(in: self).y ?? 0.0) < (bounds.size.height - bounds.origin.y) / 2 {
                    newPage = max(1, currentPageIndex - 1)
                } else {
                    newPage = min(currentPageIndex + 1, numberOfPages)
                }
                
                setCurrentPage(newPage, animated: true)
            }
        }
    }
    
    
    
    @objc func panned(_ recognizer: UIPanGestureRecognizer?) {
        
        if !animating {
            
            let translation = CGFloat(recognizer?.translation(in: self).y ?? 0.0)
            
            var progress = translation / bounds.size.height
            
            if flipDirection == .FlipDirectionTop {
                progress = min(progress, 0)
            } else {
                progress = max(progress, 0)
            }
            
            switch recognizer?.state {
            case .began:
                self.pannedHasFailed = false
                self.pannedInitialized = false
                animating = false
                setNextViewOnCompletion = false
            case .changed:
                if !self.pannedHasFailed {
                    if !self.pannedInitialized {
                        
                        self.pannedLastPage = currentPageIndex
                        if translation > 0 {
                            if currentPageIndex > 1 {
                                _ = canSetCurrentPage(currentPageIndex - 1)
                            } else {
                                self.pannedHasFailed = true
                                return
                            }
                        } else {
                            if currentPageIndex < numberOfPages {
                                _ = canSetCurrentPage(currentPageIndex + 1)
                            } else {
                                self.pannedHasFailed = true
                                return
                            }
                        }
                        self.pannedHasFailed = false
                        self.pannedInitialized = true
                        setNextViewOnCompletion = false
                        
                        initFlip()
                    }
                    setFlipProgress(Float(abs(progress)), setDelegate: false, animate: false)
                }
            case .failed:
                setFlipProgress(0.0, setDelegate: true, animate: true)
                currentPageIndex = self.pannedLastPage
            case .recognized:
                if self.pannedHasFailed {
                    setFlipProgress(0.0, setDelegate: true, animate: true)
                    currentPageIndex = self.pannedLastPage
                    return
                }
                if abs(Float((CGFloat(translation) + (recognizer?.velocity(in: self).y ?? 0.0) / 4) / bounds.size.height)) > 0.5 {
                    setNextViewOnCompletion = true
                    setFlipProgress(1.0, setDelegate: true, animate: true)
                } else {
                    setFlipProgress(0.0, setDelegate: true, animate: true)
                    currentPageIndex = self.pannedLastPage
                }
            default:
                break
            }
        }
    }
    
    //return UIView as UIImage by rendering view
    func image(byRenderingView view: UIView?) -> UIImage? {
        
        let viewAlpha = view?.alpha ?? 0.0
        view?.alpha = 1
        
        UIGraphicsBeginImageContext(view?.bounds.size ?? CGSize.zero)
        if let context = UIGraphicsGetCurrentContext() {
            view?.layer.render(in: context)
        }
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view?.alpha = viewAlpha
        return resultingImage
    }
}


class Page {
    weak var view : UIView?
    var indexPath : IndexPath!
    var isValid = false
}
