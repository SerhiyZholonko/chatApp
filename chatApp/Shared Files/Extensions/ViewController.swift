//
//  ViewController.swift
//  chatApp
//
//  Created by apple on 17.09.2023.
//

import UIKit


extension UIViewController {
    func stringValue (forDate date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string (from: date)
    }
}
