//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()

    // all the available languages to switch from
    let countries = ["FR", "GB"]
    // a mapping from country code to flag image
    var images: [String: UIImage?] = [:]

    @IBOutlet var countryButton: UIButton!
    @IBOutlet var sortByLabel: UILabel!
    @IBOutlet var firstnameButton: UIButton!
    @IBOutlet var lastnameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        countryButton.setTitle("", for: .normal)
        for code in countries {
            if let image = UIImage(named: code + ".png") {
                images[code] = image
            }
        }
        
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.activeCountry
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [self] in
                updateCountryFlag(country: $0)
                // Localize.setCurrentLanguage(val) is set in the Picker view controller
                viewModel.updateLanguageData(country: $0)
            }
            .store(in: &subscriptions)

        viewModel.sortByLabelText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: sortByLabel)
            .store(in: &subscriptions)
        viewModel.firstnameText
            .receive(on: DispatchQueue.main)
            .assign(to: \.normalTitleText!, on: firstnameButton)
            .store(in: &subscriptions)
        viewModel.lastnameText
            .receive(on: DispatchQueue.main)
            .assign(to: \.normalTitleText!, on: lastnameButton)
            .store(in: &subscriptions)
    }

    func updateCountryFlag(country: String) {
        countryButton.setImage(images[country] as? UIImage, for: .normal)
    }

    @IBAction func tapFlag(_ sender: Any) {
        self.performSegue(withIdentifier: "showCountryPicker", sender: self )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountryPicker"{
            if let destinationVC = segue.destination as? PickerViewController {
                destinationVC.activeCountry.value = viewModel.activeCountry.value
            }
        }
    }

    // https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
    @IBAction func unwindPickerToHome(sender: UIStoryboardSegue)
    {
        let sourceVC = sender.source as! PickerViewController
        viewModel.activeCountry.value = sourceVC.activeCountry.value
    }
}
