//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import CountryPicker
import Combine
import Localize_Swift

class PickerViewController: UIViewController, CountryPickerDelegate {
    let activeCountry = CurrentValueSubject<String, Never>("")
    var subscriptions = Set<AnyCancellable>()
    // a mapping from country to locale
    static let mapCountryToLocale = ["FR": "fr", "GB": "en-GB"]

    @IBOutlet var countryPicker: CountryPicker!
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "check.png") {
            // this doc gives more info for why we need withRenderingMode()
            // https://stackoverflow.com/questions/18133465/setting-uibutton-image-results-in-blue-button-in-ios-7
            closeButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        // https://cocoapods.org/pods/CountryPickerSwift
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = false
        countryPicker.displayOnlyCountriesWithCodes = ["FR", "GB"]
        // optional theming for later:
        // let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: true)
        // countryPicker.theme = theme //optional
        countryPicker.setCountry(activeCountry.value)
        activeCountry
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [self] in
                if let val = PickerViewController.mapCountryToLocale[$0] {
                    Localize.setCurrentLanguage(val)
                }
                closeButton.setTitleWithOutAnimation(title: "SAVE".localized())
                // one can exchange these 2 lines to see the animation that we removed
                //closeButton.setTitle("SAVE".localized(), for: .normal)
                closeButton.centerTextAndImage(spacing: 10)
            }
            .store(in: &subscriptions)
    }

    // MARK: - CountryPhoneCodePicker Delegate
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        activeCountry.value = countryCode
    }

    @IBAction func tapCloseButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindSeguePickerToHome", sender: self)
    }
}
