//
//  EnxToastView.swift
//  NTUC
//
//  Created by Jay Kumar on 12/02/18.
//  Copyright © 2018 Jay Kumar. All rights reserved.
//

import UIKit

class EnxToastView: UIView {

    static let toastHeight:CGFloat = 50.0
    static let toastGap:CGFloat = 10;
    lazy var textLabel: UILabel = UILabel(frame: CGRect(x: 5.0, y: 5.0, width: self.frame.size.width - 10.0, height: self.frame.size.height - 10.0))
    
    //CGRectMake(5.0, 5.0, self.frame.size.width - 10.0, self.frame.size.height - 10.0)
    
    static func showInParent(parentView: UIView!, withText text: String, forDuration duration: double_t) {
        
        //Count toast views are already showing on parent. Made to show several toasts one above another
        var toastsAlreadyInParent  = 0;
        
        for view in parentView.subviews {
            if (view.isKind(of: EnxToastView.self)) {
                toastsAlreadyInParent += 1
            }
        }
        
        let parentFrame = parentView.frame;
        
        let yOrigin = parentFrame.size.height - getDouble(toastsAlreadyInParent: toastsAlreadyInParent)
        
        let selfFrame = CGRect(x: parentFrame.origin.x + 20.0, y: yOrigin, width: parentFrame.size.width - 40.0, height: toastHeight)
        let toast = EnxToastView(frame: selfFrame)
        
        toast.textLabel.backgroundColor = UIColor.clear
        toast.textLabel.textAlignment = NSTextAlignment.center
        toast.textLabel.textColor = UIColor.white
        toast.textLabel.numberOfLines = 2
        toast.textLabel.font = UIFont.systemFont(ofSize: 13.0)
        toast.addSubview(toast.textLabel)
        
        toast.backgroundColor = UIColor.darkGray
        toast.alpha = 0.0;
        toast.layer.cornerRadius = 4.0;
        toast.textLabel.text = text;
        
        parentView.addSubview(toast)
        UIView.animate(withDuration: 0.4, animations: {
            toast.alpha = 0.9
            toast.textLabel.alpha = 0.9
        })
        
        toast.perform(#selector(hideSelf), with: nil, afterDelay: duration)
        
        //toast.perform(Selector(("hideSelf")), with: nil, afterDelay: duration)
        
    }
    
    static private func getDouble(toastsAlreadyInParent : Int) -> CGFloat {
        return (70.0 + toastHeight * CGFloat(toastsAlreadyInParent) + toastGap * CGFloat(toastsAlreadyInParent));
    }
    
    @objc func hideSelf() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0.0
            self.textLabel.alpha = 0.0
        }, completion: { t in self.removeFromSuperview() })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
