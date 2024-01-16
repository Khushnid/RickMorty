//
//  UIViewController+Extensions.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, callback: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            callback()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
