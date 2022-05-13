//
//  HomeViewModel.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-13.
//

import UIKit
import Combine

// https://swiftwithmajid.com/2020/02/05/building-viewmodels-with-combine-framework/

struct HomeViewModel {
    let activeCountry = CurrentValueSubject<String, Never>("")
    
    init() {
        let locale = Locale.current
        var localActiveCountry = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        if (localActiveCountry != "FR" && localActiveCountry != "GB") {
            localActiveCountry = "GB"
        }
        activeCountry.value = localActiveCountry
    }
}
