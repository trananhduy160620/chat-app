//
//  UINavigationBar.swift
//  ChatApp
//
//  Created by duytran on 10/26/21.
//

import UIKit
extension UINavigationBar {
    func roundCorner(corners: UIRectCorner, radius:CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
