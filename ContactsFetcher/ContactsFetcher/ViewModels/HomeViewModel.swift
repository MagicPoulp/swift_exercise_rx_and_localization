//
//  HomeViewModel.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-13.
//

import UIKit
import Combine
import Localize_Swift

// https://swiftwithmajid.com/2020/02/05/building-viewmodels-with-combine-framework/

struct HomeViewModel {
    // publishers for the logic of the UI
    let activeCountry = CurrentValueSubject<String, Never>("")
    let activeContactsSortingState = CurrentValueSubject<ContactsSortingState, Never>(ContactsSortingState.byFirstname)

    // publishers for the text data
    let sortByLabelText = CurrentValueSubject<String, Never>("")
    let firstnameText = CurrentValueSubject<String, Never>("")
    let lastnameText = CurrentValueSubject<String, Never>("")
    
    init() {
        let locale = Locale.current
        var localActiveCountry = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        if (localActiveCountry != "FR" && localActiveCountry != "GB") {
            localActiveCountry = "GB"
        }
        activeCountry.value = localActiveCountry
    }

    func updateLanguageData(country: String) {
        sortByLabelText.value = "SORT_BY".localized()
        firstnameText.value = "FIRSTNAME".localized()
        lastnameText.value = "LASTNAME".localized()
    }
}
