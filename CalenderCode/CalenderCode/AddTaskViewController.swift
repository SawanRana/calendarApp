//
//  AddTaskViewController.swift
//  CalenderCode
//
//  Created by SAWAN RANA RAMVEER SINGH on 13/03/22.
//

import Foundation
import UIKit

protocol ToDoListProtocolMethods: AnyObject {
    func createItem(task: String)
}

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            print("AddTaskViewController is dismissed")
        })
    }
    
    @IBAction func done(_ sender: Any) {
        if let text = taskTextField.text, !text.isEmpty {
            self.delegate?.createItem(task: text)
        }
        self.dismiss(animated: true, completion: {
            print("AddTaskViewController is dismissed")
        })
    }
    
    weak var delegate: ToDoListProtocolMethods? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        taskTextField.delegate = self
        taskTextField.becomeFirstResponder()
        let df = DateFormatter()
        _ = Locale.current
        df.dateFormat = "dd MMM"
        if let sD = SelectedDate.selectedDate {
            dateTextField.text = sD
        } else {
            let ds = df.string(from: Date())
            dateTextField.text = ds
        }
        dateTextField.isEnabled = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
