//
//  UIViewController+Extensions.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
