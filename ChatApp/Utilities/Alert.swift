//
//  Alert.swift
//  ChatApp
//
//  Created by duytran on 10/28/21.
//

import UIKit

class Alert {
    static var shared = Alert()
    private init() {}
    func showMessage(title:String, message:String, vc:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionAlert = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(actionAlert)
        vc.present(alert, animated: true, completion: nil)
    }
}
