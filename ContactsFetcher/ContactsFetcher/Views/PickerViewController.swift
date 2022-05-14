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
    let mapCountryToLocale = ["FR": "fr", "GB": "en-GB"]

    @IBOutlet var countryPicker: CountryPicker!
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "check.png") {
            closeButton.setImage(image, for: .normal)
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
                if let val = mapCountryToLocale[$0] {
                    Localize.setCurrentLanguage(val)
                }
                closeButton.setTitle("SAVE".localized(), for: .normal)
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
