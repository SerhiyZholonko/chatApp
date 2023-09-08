//
//  LoginViewModel.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit

struct LoginViewModel {
    var email: String?
    var password: String?
    var formIsFaild: Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var backgroundColor: UIColor {
        return formIsFaild ? .black : .black.withAlphaComponent(0.5)
    }
    var titleColor: UIColor {
        return formIsFaild ? .white : .white.withAlphaComponent(0.7)
    }
}
