//
//  ReusableProtocol.swift
//  Movie
//
//  Created by 홍정민 on 6/5/24.
//

import UIKit

protocol ReusableProtocol {
    static var identifier : String { get }
}

extension UIViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
