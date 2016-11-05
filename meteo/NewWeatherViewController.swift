//
//  NewWeatherViewController.swift
//  meteo
//
//  Created by Rachid on 02/11/2016.
//  Copyright © 2016 Rachid. All rights reserved.
//

import UIKit

class NewWeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        performSegue(withIdentifier: "backWeatherList", sender: nil)
        return true
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backWeatherList" {
            if let vc = segue.destination as? ViewController{
                if let city = searchTextField{
                    vc.searchCityText = city.text
                }
            }
        }
    }
}
