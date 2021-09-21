//
//  ViewController.swift
//  14
//
//  Created by Валентин on 11.09.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserD.shared.firstName = "Валентин"
        UserD.shared.secondName = "Парфенов"
        firstNameTextField.text = UserD.shared.firstName
        surNameTextField.text = UserD.shared.secondName
        
        print(UserD.shared.firstName, UserD.shared.secondName)
    }
}

