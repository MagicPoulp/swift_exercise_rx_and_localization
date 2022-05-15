//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import Combine
import Localize_Swift

class HomeViewController: UIViewController {
    var storage: PersistenceStorageManager = PersistenceStorageManager()
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()
    let notificationCenter = NotificationCenter.default

    // all the available languages to switch from
    let countries = ["FR", "GB"]
    // a mapping from country code to flag image
    var images: [String: UIImage?] = [:]

    @IBOutlet var countryButton: UIButton!
    @IBOutlet var sortByLabel: UILabel!
    @IBOutlet var firstnameButton: UIButton!
    @IBOutlet var lastnameButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stackView1: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        firstnameButton.layer.cornerRadius = 12
        firstnameButton.layer.borderWidth = 0.6
        firstnameButton.layer.borderColor = firstnameButton.tintColor.cgColor
        lastnameButton.layer.cornerRadius = 12
        lastnameButton.layer.borderWidth = 0.6
        lastnameButton.layer.borderColor = firstnameButton.tintColor.cgColor
        
        stackView1.setCustomSpacing(0, after: titleLabel)
        stackView1.setCustomSpacing(0, after: countryButton)

        countryButton.setTitle("", for: .normal)
        for code in countries {
            if let image = UIImage(named: code + ".png") {
                images[code] = image
            }
        }
        
        bindViewModel()
        if let savedLanguage = storage.getSavedLanguage() {
            viewModel.isLanguageBeingSetFromStorage = true
            viewModel.activeLanguage.value = savedLanguage
        }
    }

    func bindViewModel() {
        // binding UI logic publishers to some work to be done
        viewModel.activeLanguage
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [self] in
                Localize.setCurrentLanguage(PickerViewController.mapCountryToLocale[$0]!)
                if (!viewModel.isLanguageBeingSetFromStorage) {
                    storage.save(language: $0)
                }
                viewModel.isLanguageBeingSetFromStorage = false

                // update based on the newly selected language
                updateCountryFlag(country: $0)
                viewModel.updateLanguageTextData(country: $0)
            }
            .store(in: &subscriptions)
        // See in the README file, why we need a notification to propagate data to the embedded table view controller
        viewModel.activeContactsSortingState
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [self] in
                notificationCenter.post(name: Notification.Name("sortContacts"), object: nil,
                                        userInfo: ["activeContactsSortingState": $0])
            }
            .store(in: &subscriptions)

        // binding text publishers to UI elements
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
        viewModel.titleLabelText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: titleLabel)
            .store(in: &subscriptions)
    }

    func updateCountryFlag(country: String) {
        countryButton.setImage(images[country] as? UIImage, for: .normal)
    }

    @IBAction func tapFlag(_ sender: Any) {
        self.performSegue(withIdentifier: "showCountryPicker", sender: self )
    }

    @IBAction func firstnameButtonTap(_ sender: Any) {
        viewModel.activeContactsSortingState.value = ContactsSortingState.byFirstname
    }

    @IBAction func lastnameButtonTap(_ sender: Any) {
        viewModel.activeContactsSortingState.value = ContactsSortingState.byLastname
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // transition when clicking the flag button
        if segue.identifier == "showCountryPicker"{
            if let destinationVC = segue.destination as? PickerViewController {
                destinationVC.activeCountry.value = viewModel.activeLanguage.value
            }
        }
    }

    // transition when comming back from the flag button with
    // the country picker
    // https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
    @IBAction func unwindPickerToHome(sender: UIStoryboardSegue)
    {
        let sourceVC = sender.source as! PickerViewController
        viewModel.activeLanguage.value = sourceVC.activeCountry.value
    }
}
