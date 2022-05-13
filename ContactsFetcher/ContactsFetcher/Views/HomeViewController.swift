//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import CountryPicker
import Combine

class HomeViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel()
    var images: [String: UIImage?] = [:]
    let countries = ["FR", "GB"]

    @IBOutlet var countryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        countryButton.setTitle("", for: .normal)
        for code in countries {
            if let image = UIImage(named: code + ".png") {
                images[code] = image
            }
        }
        updateCountry(country: viewModel.activeCountry.value)
        
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.activeCountry
            //.receive(on: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: {
                self.updateCountry(country: $0)
            }
            .store(in: &subscriptions)
    }

    func updateCountry(country: String) {
        countryButton.setImage(images[country] as? UIImage, for: .normal)
    }

    @IBAction func tapFlag(_ sender: Any) {
        self.performSegue(withIdentifier: "showCountryPicker", sender: self )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountryPicker"{
            if let destinationVC = segue.destination as? PickerViewController {
                destinationVC.activeCountry = viewModel.activeCountry.value
            }
        }
    }

    // https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
    @IBAction func unwindPickerToHome(sender: UIStoryboardSegue)
    {
        let sourceVC = sender.source as! PickerViewController
        viewModel.activeCountry.value = sourceVC.activeCountry
    }
}
