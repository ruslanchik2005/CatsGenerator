//
//  CatTextController.swift
//  CatsGenerator
//
//  Created by Руслан on 06.11.2024.
//

import UIKit

class CatTextViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var catScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        statusLabel.text = "ПАПРОБУЙ ЗОГРУЗИТЬ КОТЕГА С ТЕКСТОМ!!!"
        activityIndicator.hidesWhenStopped = true
        generateButton.isEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
                view.addGestureRecognizer(gestureRecognizer)
        
        view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        catScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        catScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    func resetForm () {
        generateButton.isEnabled = false
        errorMessageLabel.isHidden = false
    }
    
    @IBAction func inputChanged(_ sender: UITextField) {
        if let userInput = textField.text {
            if let errorMessage = invalidInputText(userInput) {
                errorMessageLabel.text = errorMessage
                errorMessageLabel.isHidden = false
            } else {
                errorMessageLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidInputText(_ value: String) -> String? {
        if value.isEmpty {
            return "Эта чё такое? ЗОГРУЗКО АТМИНЯЕЦА!"
        }
        return nil
    }
    
    func checkForValidForm() {
        if errorMessageLabel.isHidden {
            generateButton.isEnabled = true
        } else {
            generateButton.isEnabled = false
        }
    }
    
    func text() -> String {
        guard let userInput = textField.text else {
                    return ""
                }
        return userInput
    }
        
    private func downloadCat(with text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?fontSize=50&fontColor=white") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = "КОТЕГ ЗАГРУЖЕН!!!"
                self?.activityIndicator.stopAnimating()
                self?.generateButton?.isEnabled = true
            }
        }
                
        task.resume()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        (sender as? UIButton)?.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "ЗОГРУЖАЕМ КОТЕГА"
        downloadCat(with: text())
    }
}
