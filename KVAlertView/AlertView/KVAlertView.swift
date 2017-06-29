//
//  KVAlertView.swift
//  KVAlertView
//
//  Created by Vikash Kumar on 09/06/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import AudioToolbox

var viewHeight:CGFloat = 70.0
private var hideDelayTime: TimeInterval = 1.5
private var singleMessageHideTime: TimeInterval = 2.0

public class KVAlertView: UIView {
    let screen = UIScreen.main.bounds
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var roundCornerView: UIView!
    @IBOutlet weak var popupViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMessage: UILabel!
    
    var message: String = "This is notification message! Thank you." {
        didSet {
         setMessage()
        }
    }
    
    //Public variables
    public var bgColor = UIColor.clear
    public var textColor: UIColor = UIColor.black
    public var isAllowVibration  = false
    
    //class variables
    static var alertQueue = AlertQueue()
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
        self.setMessage()
    }
    
    
    fileprivate func setUI() {
        self.frame = CGRect(x: 0.0, y: 0.0, width: screen.size.width, height: viewHeight + 20)
        popupViewTopConstraint.constant = -viewHeight
        self.layoutIfNeeded()

        self.backgroundColor = UIColor.clear
        self.roundCornerView.backgroundColor = bgColor
        self.lblMessage.textColor = textColor
        
        
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.7
        popupView.layer.shadowOffset = CGSize.zero
        popupView.layer.shadowRadius = 3
        popupView.layer.zPosition = 15
        popupView.backgroundColor = .clear
    }
    
    fileprivate func setMessage() {
        lblMessage.text = message
    }
    
}



//MARK: Class functions
extension KVAlertView {
   public class func show(message: String) {
        let alert = loadViewFromNib()
        alert.message =  message
        
        alertQueue.enqueue(alert: alert)
        alertQueue.showAlert()
    }
    
    fileprivate class func loadViewFromNib()-> KVAlertView {
        let bundle = Bundle(for: KVAlertView.self)
        let views = bundle.loadNibNamed("KVAlertView", owner: nil, options: nil) as! [UIView]
        let alert = views[0] as! KVAlertView
        return alert
    }
    
}

//MARK: AlertQueue
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
    
//action for showing alertview.
extension AlertQueue {
    
    func showAlert() {
        if count == 1 {
            showNextAlertAfter(delay: DispatchTime.now())
        }
    }
    
    
    fileprivate func showNextAlertAfter(delay: DispatchTime) {
        self.showWithAnimation(delay: delay)
    }

    
    fileprivate func showWithAnimation(delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            if let frontAlert = self.frontAlert {
                let window = UIApplication.shared.delegate?.window!
                window?.addSubview(self.frontAlert!)
                
                let anim = CABasicAnimation(keyPath: "position.y")
                anim.duration = 0.4
                anim.fromValue = -((viewHeight/2) + 20)
                anim.toValue = (viewHeight/2) + 20
                //anim.delegate = self
                frontAlert.popupView.layer.add(anim, forKey: "showanimation")
                frontAlert.popupViewTopConstraint.constant = 20
                self.hideWithAnimation()
                
                if frontAlert.isAllowVibration {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
            }
        }
    }
    
    
    fileprivate func hideWithAnimation() {
        let delay = DispatchTime.now() + (KVAlertView.alertQueue.count > 1 ? hideDelayTime : singleMessageHideTime)
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


//Userd for set blur effect in a view.
class AlertBlurView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubview(toBack: blurEffectView)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}

