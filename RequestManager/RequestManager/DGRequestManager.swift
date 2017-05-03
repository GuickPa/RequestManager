//
//  DGRequestManager.swift
//  RequestManager
//
//  Created by Guglielmo on 02/05/17.
//  Singleton class RequestManager
//

import Foundation


class RequestManager{
    
    static let sharedInstance = RequestManager()
    
    private init() {
        
    }
    
    private func startRequest(method: String, _ url: URL, _ params: Dictionary<String, Any>?, _ headers: Dictionary<String, String>?, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> Bool{
        
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        var request = URLRequest(url: url)
        request.httpMethod = method
        //GUI: set params
        if let params = params{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
            catch{
                print(error.localizedDescription)
                return false
            }
        }
        //GUI: set headers
        if let headers = headers{
            for (header, value) in headers{
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        (sessionWithoutADelegate.dataTask(with: request, completionHandler: completionHandler)).resume()
        
        return true
    }
    
    //GUI: url session data task without delegate
    func GET(_ urlString: String, _ params: Dictionary<String, Any>?, _ headers: Dictionary<String, String>?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> Bool{
        
        if let url = URL(string: urlString){
            return self.GET(url, params, headers, completionHandler: completionHandler)
        }
        
        return false;
    }
    
    func GET(_ url: URL, _ params: Dictionary<String, Any>?, _ headers: Dictionary<String, String>?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> Bool{
        return self.startRequest(method: "GET", url, params, headers, completionHandler)
    }
    
    //GUI: url session data task without delegate
    func POST(_ urlString: String, _ params: Dictionary<String, Any>?, _ headers: Dictionary<String, String>?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> Bool{
        
        if let url = URL(string: urlString){
            return self.POST(url, params, headers, completionHandler: completionHandler)
        }
        
        return false;
    }
    
    func POST(_ url: URL, _ params: Dictionary<String, Any>?, _ headers: Dictionary<String, String>?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> Bool{
        return self.startRequest(method: "POST", url, params, headers, completionHandler)
    }
}
