//
//  PCL_Network_Layer.swift
//  PCL_SwiftUI
//
//  Created by Deepesh on 6/9/23.
//

import Foundation

enum NetworkResult: Codable {
    case success(Data)
    case failure(String)
}


func makeRequest(url: String,
                 body: [String : Any]? = nil,
                 headers: [String : String]) -> (URLRequest?, NetworkRequestError?) {
    //URL creation
    guard let url = URL(string: url) else {
        return (nil, NetworkRequestError.invalidURL)
    }
    
    // Request Creation
    var request = URLRequest(url: url)
    
    // adding body
    if let body = body {
        request.httpMethod = "POST"
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch { return (nil, NetworkRequestError.invalidBody) }
    } else{ request.httpMethod = "GET" }
    
    //Adding headers
    for (key, value) in headers {
        request.addValue(value, forHTTPHeaderField: key)
    }
    // Default Headers
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return (request,nil)
    
}

func performTask<T : Codable>(url: String,
                 headers: [String : String],
                 body: [String: Any]? = nil ,
                 retry: Int = 3,
                 successModel: T.Type,
                 failureModel : T.Type,
                 completionHandler: @escaping (T) -> Void){
    let response = makeRequest(url: url, headers: headers)
    guard let request = response.0  else {
        let returnValue: Codable = response.1 ?? NetworkRequestError.invalidRequest
        completionHandler(returnValue as! T)
        return
    }
    
    requestData(urlRequest: request, completionHandler: { networkResult in
        switch networkResult{
            
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let newtorkData = try decoder.decode(successModel, from: data)
            } catch{
                completionHandler(NetworkRequestError.decodingError as! T)
            }
        case .failure(_):
            completionHandler(NetworkRequestError.invalidURL as! T)
        }
    })
}

func requestData(urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> Void){
    URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
        if let error = error{
            completionHandler(.failure(error.localizedDescription))
        }
        
        if let data = data {
            completionHandler(.success(data))
        }else{
            completionHandler(.failure("Data not found"))
        }
    }
}
