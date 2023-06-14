//
//  NetworkClient.swift
//  PCL_SwiftUI
//
//  Created by Deepesh on 6/9/23.
//

import Foundation

enum loginResponse {
    case success(LoginModel)
    case failre(String)
}

//MARK: - Login

func userLogin(username: String, password: String, completionHandler: @escaping (loginResponse) -> ()) {
    let Url = String(format: Constants.URL.userLogin)
    
    guard let url = URL(string: Url) else {
        return }
    let body: [String: Any] = [
        "UserName": username,
        "Password": password
    ]
    
    var request = URLRequest(url: url)
    
    
    requestData(urlRequest: request, completionHandler: { loginResult in
        switch loginResult{
            
        case .success(_):
            <#code#>
        case .failure(_):
            <#code#>
        }
        
    })
}
