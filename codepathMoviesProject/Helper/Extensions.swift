//
//  Extensions.swift
//  codepathMoviesProject
//
//  Created by Dong Yoon Han on 5/10/19.
//  Copyright © 2019 Oliver Thurn. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgbColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }

    static var placeholderGray: UIColor {
        return UIColor.rgbColor(199, 199, 205)
    }
}

extension UIStackView {
    func addArrangedSubViews(_ views:[UIView]) {
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
    }
}

extension UIView {
    func addSubviews(_ views:[UIView]) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
