//
//  KVAlertView.swift
//  KVAlertView
//
//  Created by Vikash Kumar on 09/06/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class KVAlertView: UIView {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popupViewTopConstraint.constant = -popupView.frame.height
    }
    
    var alert: KVAlertView {return KVAlertView()}
    
    class func show(message: String) {
        
    }
}
