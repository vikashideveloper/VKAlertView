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
    
    var message: String = "This is notification message! Thank you." {
        didSet {
         setMessage()
        }
    }
    var hideDelayTime: TimeInterval = 2.0
    var bgColor = UIColor.gray
    
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
        alert.message = "\(alertQueue.count + 1) " + message
        
        alertQueue.enqueue(alert: alert)
        alertQueue.showAlert()
    }
    
   fileprivate class func loadViewFromNib()-> KVAlertView {
        let views = Bundle.main.loadNibNamed("KVAlertView", owner: nil, options: nil) as! [UIView]
        let alert = views[0] as! KVAlertView
        return alert
    }
    
    
}

extension KVAlertView : CAAnimationDelegate {
    
}

//MARK: Animation functions


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
    

extension AlertQueue {
    
    func showAlert() {
        if count > 1 {
            
        } else {
            showNextAlertAfter(delay: DispatchTime.now())
        }
    }
    
    fileprivate func showNextAlertAfter(delay: DispatchTime) {
        self.showWithAnimation(delay: delay)
    }

    fileprivate func showWithAnimation(delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let window = UIApplication.shared.delegate?.window!
            window?.addSubview(self.frontAlert!)
            
            let anim = CABasicAnimation(keyPath: "position.y")
            anim.duration = 0.4
            anim.fromValue = -((viewHeight/2) + 20)
            anim.toValue = (viewHeight/2) + 20
            //anim.delegate = self
            self.frontAlert?.popupView.layer.add(anim, forKey: "showanimation")
            self.frontAlert?.popupViewTopConstraint.constant = 20
            self.hideWithAnimation(delay: DispatchTime.now() + 2.0)
            
        }
    }
    
    
    fileprivate func hideWithAnimation(delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let front = self.dequeue()
            if KVAlertView.alertQueue.count > 0 {
                self.showNextAlertAfter(delay: DispatchTime.now())
                self.removeFromSuperview(delay: DispatchTime.now() + 0.5, alert: front!)
                
            } else {
                let anim = CABasicAnimation(keyPath: "position.y")
                anim.fromValue = (viewHeight/2) + 20
                anim.duration = 0.5
                anim.toValue = -((viewHeight/2) + 20)
                front?.popupView.layer.add(anim, forKey: "Hideanimation")
                front?.popupViewTopConstraint.constant = -(viewHeight + 20)
                
            }
        }
    }
    
    
    fileprivate func removeFromSuperview(delay: DispatchTime, alert: KVAlertView) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            alert.removeFromSuperview()
        }
    }
    
}
