//
//  CreateScheduleViewController.swift
//  MinhasPautas
//
//  Created by Hugo Hernany on 02/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import UIKit

protocol CreateScheduleViewControllerDelegate {
    func createSuccess()
    func createError(message: String)
}

class CreateScheduleViewController: UIViewController {

    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var totalCharactersTextField: UILabel!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var authorLabel: UILabel!
    
    // Layout Constraints
    @IBOutlet weak var footerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    // Variables and Constants
    var createScheduleViewModel: CreateScheduleViewModel?
    private var spinner: UIView? = nil
    private var textViewIsFocused = false
    
    // Keyboard status
    private var keyboardSize: CGRect!
    private var keyboardIsShowing: Bool!
    
    // Field total chars
    private var titleChars = 0
    private var descriptionChars = 0
    private var contentChars = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        setupLayoutAndDelegates()
        toolBarTextFields()
        createScheduleViewModel = CreateScheduleViewModel(delegate: self)
    }
    
    private func setupLayoutAndDelegates() {
        createButton.isEnabled = false
        authorLabel.text = "Autor: \(UserDefaults.standard.object(forKey: "nome_usuario") as? String ?? "")"
        titleTextField.becomeFirstResponder()

        titleTextField.delegate = self
        descriptionTextField.delegate = self
        contentTextView.delegate = self
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func toolBarTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let leftSideSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([leftSideSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        titleTextField.inputAccessoryView = toolbar
        descriptionTextField.inputAccessoryView = toolbar
        contentTextView.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue // Save keyboard size
            keyboardIsShowing = notification.name == UIResponder.keyboardWillShowNotification // keyboard status
            footerViewBottom.constant = keyboardIsShowing ? -keyboardSize.height : 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func didTapCreateButton(_ sender: UIBarButtonItem) {
        guard let _ = createScheduleViewModel else { fatalError("ViewModel not implemented") }
        spinner = self.view.showSpinnerGray()
        let formData = CreateScheduleModel(titulo: titleTextField.text ?? "", descricao: descriptionTextField.text ?? "", detalhes: contentTextView.text ?? "")
        createScheduleViewModel?.sendFormData(formData: formData)
    }

    private func checkTextFieldIsNotEmpty() {
        if titleChars != 0 && descriptionChars != 0 && contentChars != 0 {
            self.createButton.isEnabled = true
        } else {
            self.createButton.isEnabled = false
        }
    }
}

extension CreateScheduleViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? "" // current text
        guard let stringRange = Range(range, in: currentText) else { return false } // try read range
        let newText = currentText.replacingCharacters(in: stringRange, with: string) // new text
        let numberOfChars = newText.count

        // Update total chars while typing, and check if all fields contain characters
        if textField == titleTextField {
            titleChars = numberOfChars
            self.totalCharactersTextField.text = "\(titleChars) de 50"
            return numberOfChars < 50
        }
        if textField == descriptionTextField {
            descriptionChars = numberOfChars
            self.totalCharactersTextField.text = "\(descriptionChars) de 100"
            return numberOfChars < 100
        }
        checkTextFieldIsNotEmpty()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField {
            self.totalCharactersTextField.text = "\(titleChars) de 50"
        }
        if textField == descriptionTextField {
            self.totalCharactersTextField.text = "\(descriptionChars) de 100"
        }
    }
}

extension CreateScheduleViewController: UITextViewDelegate {
    // Update total chars while typing, and check if all fields contain characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        contentChars = numberOfChars
        self.totalCharactersTextField.text = "\(contentChars) de 1000"
        checkTextFieldIsNotEmpty()
        return numberOfChars < 1000
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.totalCharactersTextField.text = "\(contentChars) de 1000"
        updateTextViewLayoutPosition()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        updateTextViewLayoutPosition()
    }
    
    func updateTextViewLayoutPosition() {
        stackViewTopConstraint.constant = keyboardIsShowing ? -130 : 20
        // Effect while change constraints (self.view.layoutIfNeeded)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in }
    }
}

extension CreateScheduleViewController: CreateScheduleViewControllerDelegate {
    func createSuccess() {
        spinner?.removeSpinner()
        self.performSegue(withIdentifier: Segue.backToSchedules, sender: self) // Uwind Segue
    }
    
    func createError(message: String) {
        spinner?.removeSpinner()
        message.alert(self)
    }
}
