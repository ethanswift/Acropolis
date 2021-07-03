//
//  NetworkManager.swift
//  Acropolis
//
//  Created by ehsan sat on 6/30/21.
//  Copyright © 2021 ehsan sat. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> ()

typealias ErrorHandler = (String) -> ()

class NetworkManager {
    
    static let errorGenericMsg = "Network couldn't be reached out"
    
    func getDataFromAPI (url: URL,
                         successHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping ErrorHandler)
    {
//        print("something")
        let completionHandler: NetworkCompletionHandler = {(data, urlResponse, error) in
            
            if let error = error {
                print(error.localizedDescription)
                errorHandler(NetworkManager.errorGenericMsg)
                return
            }
            print("first something")
            if self.isSuccees(urlResponse: urlResponse!) {
                guard let data = data else {
                    print(error?.localizedDescription)
                    errorHandler(NetworkManager.errorGenericMsg)
                    return
                }
                print("second something")
                successHandler(data)
                print(data)
//                let responseObject = try? JSONDecoder().decode(Data.self, from: data)
//                successHandler(responseObject!)
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print(json)
//                    successHandler(json as! Data)
//                } catch {
//                    print(error)
//                }
            } else {print(error)}
        }
            
        var request = URLRequest(url: url)
//        request.allHTTPHeaderFields = [//"Content-Type" :"text/html; charset=UTF-8",
//                                    "Content-Type": "application/json",
//                                    //"Content-Type": "application/x-www-form-urlencoded",
//                                    "Accept": "application/json"]
//                                    //"Accept": "multipart/form-data"]
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task =  session.dataTask(with: request, completionHandler: completionHandler)
        
        task.resume()
//        print("something")
            
    }
    func isSuccess (successCode: Int) -> Bool {
        return successCode >= 200 && successCode < 300
    }
    
    func isSuccees (urlResponse: URLResponse) -> Bool {
        guard let response = urlResponse as? HTTPURLResponse else {return false}
        return isSuccess(successCode: response.statusCode)
    }
}
    
