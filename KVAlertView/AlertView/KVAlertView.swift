//
//  KVAlertView.swift
//  KVAlertView
//
//  Created by Vikash Kumar on 09/06/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

var viewHeight:CGFloat = 70.0

class KVAlertView: UIView {
    let screen = UIScreen.main.bounds
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMessage: UILabel!
    
    var message: String = "This is notification message! Thank you."
    var hideDelayTime: TimeInterval = 2.0
    var bgColor = UIColor.gray
    
    static var alerts = [KVAlertView]()
    static var alertQueue = AlertQueue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
        self.setMessage()
    }
    
    
    fileprivate func setUI() {
        self.frame = CGRect(x: 0.0, y: 0.0, width: screen.size.width, height: viewHeight + 20)
        self.backgroundColor = bgColor
        popupViewTopConstraint.constant = -viewHeight
        self.backgroundColor = UIColor.clear
        
        popupView.layer.cornerRadius = 10.0
        popupView.clipsToBounds = true
        self.layoutIfNeeded()
        
        self.clipsToBounds = true
        
    }
    
    fileprivate func setMessage() {
        lblMessage.text = message
    }
    
}

//MARK: Class functions
extension KVAlertView {
    class func show(message: String) {
        let alert = loadViewFromNib()
        alert.message = message
        alert.showWithAnimation()
        alerts.append(alert)
        
    }
    
   fileprivate class func loadViewFromNib()-> KVAlertView {
        let views = Bundle.main.loadNibNamed("KVAlertView", owner: nil, options: nil) as! [UIView]
        let alert = views[0] as! KVAlertView
        return alert
    }
    
    fileprivate class func hideAllOtherAlerts() {
        let last = alerts.removeLast() //remove current showing alert
        for alert in KVAlertView.alerts {
            alert.popupView.layer.removeAllAnimations()
            alert.removeFromSuperview()
        }
        alerts.removeAll()
        alerts.append(last) //add current showing alert
    }
    
}

//MARK: Animation functions
extension KVAlertView {
    fileprivate func showWithAnimation() {
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(self)
        
        let anim = CABasicAnimation(keyPath: "position.y")
        anim.duration = 0.4
        anim.fromValue = -((viewHeight/2) + 20)
        anim.toValue = (viewHeight/2) + 20
        
        popupView.layer.add(anim, forKey: "showanimation")
        self.popupViewTopConstraint.constant = 20
        
        hideWithAnimation(delay: DispatchTime.now() + 2.0)
    }
    
    
    fileprivate func hideWithAnimation(delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            if KVAlertView.alerts.count > 1 {
                KVAlertView.hideAllOtherAlerts()
            }
            let anim = CABasicAnimation(keyPath: "position.y")
            anim.fromValue = (viewHeight/2) + 20
            anim.duration = 0.5
            anim.toValue = -((viewHeight/2) + 20)
            self.popupView.layer.add(anim, forKey: "Hideanimation")
            self.popupViewTopConstraint.constant = -(viewHeight + 20)

        }
    }
    
}

class AlertQueue {
    var alerts = [KVAlertView]()
    
    var count: Int {return alerts.count}
    
    func enqueue(alert: KVAlertView) {
        alerts.append(alert)
    }
    
    func dequeue()-> KVAlertView? {
        return alerts.isEmpty ? nil : alerts.removeFirst()
    }
    
    var frontAlert: KVAlertView? {return alerts.isEmpty ? nil : alerts.first}
}
    
}
