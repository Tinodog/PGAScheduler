//
//  AddViewController.swift
//  PGAAppScheduler
//
//  Created by Fabian Cooper on 9/13/21.
//

import UIKit

class AddViewController: ViewController, UITextFieldDelegate{
    
    @IBOutlet var nameField : UITextField!
    @IBOutlet var detailField : UITextField!
    @IBOutlet var datePicker : UIDatePicker!
    
    public var completion : ((String, String, Date) -> Void)?

    override func viewDidLoad() {
        
        nameField.delegate = self
        detailField.delegate = self
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        

    }
    
    @objc func didTapSave() {
        
        if let nameText = nameField.text, !nameText.isEmpty,
           let detailText = detailField.text, !detailText.isEmpty {
            
            let targetDate = datePicker.date
            
            completion?(nameText, detailText, targetDate)
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}
