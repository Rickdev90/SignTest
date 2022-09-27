//
//  Manager.swift
//  SignBarsTest
//
//  Created by Rick on 22/09/22.
//

import Foundation


public class ViewModelLogin {
    
    var refreshData = {() -> () in}
    
    var dataLoginResponse: TokenResponse?  {
        didSet {
            refreshData()
        }
    }
    
    func sendCredentials(user: String, pass: String){
        guard let url = URL(string: "https://testandroid.macropay.com.mx") else {return}
        //let user1 = "admin@macropay.mx"
        //let pass = "Admin1"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data : Data = "email=\(user)&password=\(pass)&grant_type=password".data(using: .utf8)!
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("lag", forHTTPHeaderField: "Accept-Language")
        request.httpBody = data
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let decoder = JSONDecoder()
                self.dataLoginResponse = try decoder.decode(TokenResponse.self, from: data)
                print(self.dataLoginResponse)
                print(String(data: data, encoding: String.Encoding.utf8))
                //print(self.dataLoginResponse?.success)
            }
            catch{
                print(error)
            }
        }.resume()
    }
}
