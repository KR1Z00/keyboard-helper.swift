//
//  KeybardHandlingViewController.swift
//  FlatMate
//
//  Created by Jamie Walker on 31/05/19.
//  Copyright © 2019 Jamie Walker. All rights reserved.
//

import UIKit

class KeyboardHandlingViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the handlers for the keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Set self as the delegate for all of the textfields in self
        let textfields = self.view.getTextFieldsInView(view: self.view)
        for textfield in textfields {
            textfield.delegate = self
        }
        
        // For when the user touches outside the textfield
        self.hideKeyboard()
    }
    
    // Handler for the keyboard showing
    @objc func keyboardWillShow(notification: NSNotification) {
        // Padding between the textfield and the keyboard
        let padding: CGFloat = 10
        
        // Gets the keyboard size information
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Gets the selected text field
            if let selectedTextField = self.view.getSelectedTextField(){
                // Gets the origin of the text field in the coordinate system of the main view
                var globalPoint = selectedTextField.superview?.convert(selectedTextField.frame.origin, to: nil)
                if globalPoint == nil {
                    globalPoint = selectedTextField.frame.origin
                }
                
                // Find if the keyboard is overlapping the textfield
                let selectedTextFieldMaxY = globalPoint!.y + selectedTextField.frame.height
                
                if selectedTextFieldMaxY > keyboardSize.minY {
                    // Find the difference and move the view up by the difference + the padding
                    let diff = selectedTextFieldMaxY - keyboardSize.minY
                    self.view.center.y -= diff + padding
                }
            }
        }
    }
    
    // Handler for the keyboard hiding
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // Handler for the keyboard changing
    @objc func keyboardWillChange(notification: NSNotification) {
        // Padding between the textfield and the keyboard
        let padding: CGFloat = 15
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let selectedTextField = self.view.getSelectedTextField(){
                var globalPoint = selectedTextField.superview?.convert(selectedTextField.frame.origin, to: nil)
                if globalPoint == nil {
                    globalPoint = selectedTextField.frame.origin
                }
                
                let selectedTextFieldMaxY = globalPoint!.y + selectedTextField.frame.height
                
                if selectedTextFieldMaxY > keyboardSize.minY {
                    let diff = selectedTextFieldMaxY - keyboardSize.minY
                    self.view.center.y -= diff + padding
                }
            }
        }
    }
    
    // If the user touches outside the keyboard
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(KeyboardHandlingViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // If the user hits return on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    // Gets the selected text field
    func getSelectedTextField() -> UITextField? {
        // Get all the text fields in the view
        let totalTextFields = getTextFieldsInView(view: self)
        
        // Loop through all text fields
        for textField in totalTextFields {
            // If the text field is the first responder, it's the active text field
            if textField.isFirstResponder {
                return textField
            }
        }
        
        return nil
    }
    
    // Gets all the text fields in the view
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        // Empty array initialiser
        var totalTextFields = [UITextField]()
        
        // Loops through all the views
        for subview in view.subviews as [UIView] {
            // If the subview is a textfield
            if let textField = subview as? UITextField {
                // Add it to the arrays
                totalTextFields += [textField]
            } else {
                // If not, get the text fields inside of it
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        
        return totalTextFields
    }
}
