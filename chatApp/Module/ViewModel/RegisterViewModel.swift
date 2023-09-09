//
//  RegisterViewModel.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//



import UIKit

struct RegisterViewModel: AuthViewModelProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var formIsFaild: Bool{
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var backgroundColor: UIColor {
        return formIsFaild ? .label : .label.withAlphaComponent(0.5)
    }
    var titleColor: UIColor {
        return formIsFaild ? .label.complementaryColor() : .label.complementaryColor().withAlphaComponent(0.7)
    }
}
