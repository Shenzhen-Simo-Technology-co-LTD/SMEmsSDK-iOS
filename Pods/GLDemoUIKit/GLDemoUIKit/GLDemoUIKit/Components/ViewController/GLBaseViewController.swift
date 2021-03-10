//
//  GLBaseViewController.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/3/30.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

public typealias GLViewControllerWillPopHandler = (_ controller: GLBaseViewController) -> ()

open class GLBaseViewController: UIViewController {
    public var willPopHandler: GLViewControllerWillPopHandler?
    public var leftNavigationBtn: UIButton?
    public var rightNavigationBtn: UIButton?
    
    public var enableGradientBackground = false {
        didSet {
            if oldValue == false && enableGradientBackground == true {
                setupGradientBGColor()
            }
        }
    }
    private var _gradientColorLayer: CAGradientLayer?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        initSetting()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetting()
    }
    
    func initSetting() {
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        enableRightSwipeToPop = true
    }
    
    // MARK: - Lift Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.all
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = DEFAULT_BG_COLOR.color
        
//        self.setupViews()
//        self.setupLayout()
    }
    // MARK: - Setup
    open func setupViews() {
        
    }
    
    open func setupLayout() {
        
    }
    
    // MARK: - Override
    
    // MARK: - Public
    open func setupGradientBGColor() {
        if !enableGradientBackground {
            return
        }
        if _gradientColorLayer != nil {
            _gradientColorLayer?.removeFromSuperlayer()
        }
        _gradientColorLayer = CAGradientLayer.init()
        _gradientColorLayer!.frame = self.view.bounds
        _gradientColorLayer!.colors = [BG_COLOR_TOP.cgColor, BG_COLOR_BOTTOM.cgColor]
        _gradientColorLayer!.locations = [NSNumber(0.0), NSNumber(1.0)]
        _gradientColorLayer!.startPoint = CGPoint.init(x: 0.5, y: 0.0)
        _gradientColorLayer!.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(_gradientColorLayer!, at: 0)
        //        self.view.layer.addSublayer(gradientColorLayer)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupGradientBGColor()
        self.view.backgroundColor = DEFAULT_BG_COLOR.color
    }
    
    // MARK: - Private
    
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    
    // MARK: - Setter
    // 是否使用右滑返回
    public var enableRightSwipeToPop: Bool = false {
        didSet {
            if self.navigationController?.isKind(of: GLBaseNavigationController.self) ?? false {
                let nvc = self.navigationController as! GLBaseNavigationController
                nvc.enableRightSwipeToPop = self.enableRightSwipeToPop
            }
        }
    }
    // MARK: - Getter
}

public extension UIViewController {
    func showSystemAlert(_ inController: UIViewController, _ title: String?, _ message: String?,_ cancelTitle: String?, cancelHandler: GLVoidCompletion?, okTitle: String?, okHandler : GLVoidCompletion?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction.init(title: cancelTitle ?? "取消", style: UIAlertAction.Style.cancel, handler: { (_) in
            if let cancel = cancelHandler {
                cancel()
            }
        }))
        if let ok = okHandler {
            alertVC.addAction(UIAlertAction.init(title: okTitle ?? "确定", style: UIAlertAction.Style.default, handler: { (_) in
                ok()
            }))
        }
        
        inController.present(alertVC, animated: true, completion: nil)
    }
}

//let kGLTransitionDelegate = "kGLTransitionDelegate"
//public extension UIViewController {
//    public func glTransitionDelegate() -> GLTransitionDelegate {
//        return objc_getAssociatedObject(self, "kGLTransitionDelegate") as kGLTransitionDelegate
//    }
//}

