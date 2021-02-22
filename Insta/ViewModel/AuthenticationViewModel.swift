//
//  LoginViewModel.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonColor: UIColor{ get }
    var buttonIsEnable: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonColor: UIColor {
        return formIsValid ? lightBlue : darkBlue
    }
    
    var buttonIsEnable: Bool {
        return formIsValid ? true : false
    }
}

struct SignUpViewModel: AuthenticationViewModel {
    
    var email: String?
    var username: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && username?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonColor: UIColor {
        return formIsValid ? lightBlue : darkBlue
    }
    
    var buttonIsEnable: Bool {
        return formIsValid ? true : false
    }
}
