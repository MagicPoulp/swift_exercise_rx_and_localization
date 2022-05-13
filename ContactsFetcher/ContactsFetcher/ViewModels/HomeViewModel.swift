//
//  HomeViewModel.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-13.
//

import UIKit

struct HomeViewModel {
    var activeCountry = ""
    
    init() {
        let locale = Locale.current
        activeCountry = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        if (activeCountry != "FR" && activeCountry != "GB") {
            activeCountry = "GB"
        }
    }
}
