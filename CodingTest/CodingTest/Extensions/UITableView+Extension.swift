//
//  UITableViewCell+Extension.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(cell reusable: T.Type) {
        self.register(reusable.self, forCellReuseIdentifier: reusable.identifier)
    }
    
    func register<T: UITableViewCell>(nib reusable: T.Type) {
        let nib = UINib(nibName: reusable.identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: reusable.identifier)
    }
    
    func dequeue<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Dequeue error")
        }
        return cell
    }
}
