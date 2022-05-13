//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import CountryPicker

class PickerViewController: UIViewController, CountryPickerDelegate {

    @IBOutlet var countryPicker: CountryPicker!
    @IBOutlet var closeButton: UIButton!
    var activeCountry: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.setTitle(" OK", for: .normal)
        
        if let image = UIImage(named: "check.png") {
            closeButton.setImage(image, for: .normal)
        }

        // https://cocoapods.org/pods/CountryPickerSwift
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = false
        countryPicker.displayOnlyCountriesWithCodes = ["FR", "GB"]
        // let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: true)
        // countryPicker.theme = theme //optional
        countryPicker.setCountry(activeCountry)
    }
    
    // MARK: - CountryPhoneCodePicker Delegate
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        activeCountry = countryCode
    }

    @IBAction func tapCloseButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindSeguePickerToHome", sender: self)
    }
}
