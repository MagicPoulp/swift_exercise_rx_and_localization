//
//  Extensions.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

import UIKit

// https://stackoverflow.com/questions/69469448/is-there-a-way-to-update-uibuttons-titlelabel-text-using-combines-assign-inst
extension UIButton {
    var normalTitleText: String? {
        get {
            title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
}

