//
//  Extension.swift
//  GithubSearch
//
//  Created by SIMA on 07/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}
