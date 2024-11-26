//
//  ViewController.swift
//  CatsGenerator
//
//  Created by Руслан on 06.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
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
            }
        }
        
        task.resume()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        activityIndicator.startAnimating()
        statusLabel.text = "ЗОГРУЖАЕМ КОТЕГА"
        downloadCat()
    }
    
}
