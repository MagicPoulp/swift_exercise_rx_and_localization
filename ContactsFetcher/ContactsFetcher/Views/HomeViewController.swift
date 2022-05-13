//
//  HomeViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import CountryPicker

class HomeViewController: UIViewController {
    var homeViewModel: HomeViewModel = HomeViewModel()

    @IBOutlet var countryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        countryButton.setTitle("", for: .normal)
        if let image = UIImage(named: "FR.png") {
            countryButton.setImage(image, for: .normal)
        }
    }

    @IBAction func tapFlag(_ sender: Any) {
        self.performSegue(withIdentifier: "showCountryPicker", sender: self )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountryPicker"{
            if let destinationVC = segue.destination as? PickerViewController {
                destinationVC.activeCountry = homeViewModel.activeCountry
            }
        }
    }

    // https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
    @IBAction func unwindPickerToHome(sender: UIStoryboardSegue)
    {
        let sourceVC = sender.source as! PickerViewController
        homeViewModel.activeCountry = sourceVC.activeCountry
    }
}
