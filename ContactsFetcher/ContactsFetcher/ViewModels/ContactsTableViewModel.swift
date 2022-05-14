//
//  HomeViewModel.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-13.
//

import UIKit
import Combine

// https://swiftwithmajid.com/2020/02/05/building-viewmodels-with-combine-framework/

struct ContactsTableViewModel {
    // publishers for the logic of the UI
    let activeContactsSortingState = CurrentValueSubject<ContactsSortingState, Never>(ContactsSortingState.byFirstname)
    var previousContactsSortingState = ContactsSortingState.byFirstname
    var sortingMultiplier = 1
    
    init() {
        previousContactsSortingState = activeContactsSortingState.value
    }
}
