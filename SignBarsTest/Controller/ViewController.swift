//
//  ViewController.swift
//  SignBarsTest
//
//  Created by Rick on 22/09/22.
//

import UIKit
import CryptoKit

let defaults = UserDefaults.standard

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var LogInBtn: UIButton!
    
    var viewModel = ViewModelLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        LogInBtn.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
    }
    
    @objc func logInAction() {
        showSpinner()
        guard let user = emailTxt.text else {return}
        guard let password = passTxt.text else {return}
        let modelUser = UserPass(email: user, pass: password)
        print(modelUser)
        viewModel.sendCredentials(user: modelUser.email ?? "", pass: modelUser.pass ?? "")
        viewModel.refreshData = {[weak self]() in
            DispatchQueue.main.async { [self] in
                self?.removeSpinner()
                print("response\(self?.viewModel.dataLoginResponse?.success)")
                if self?.viewModel.dataLoginResponse?.success == true{
                    //self?.performSegue(withIdentifier: "segueCodeBar", sender: self)
                    print("tokeeen\(self?.viewModel.dataLoginResponse?.token)")
                    self?.JSONWT(str: self?.viewModel.dataLoginResponse?.token)
                    let vc = self?.storyboard?.instantiateViewController(identifier: "CodeBarViewController") as? CodeBarViewController
                    //let objectSelected = self?.viewModel.dataLoginResponse?.token
                    //vc?.objectReceived = objectSelected ?? ""
                    //vc?.userReceived = user
                    self?.navigationController?.pushViewController(vc!, animated: true)
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func JSONWT(str: String?){
        let parts = str?.components(separatedBy: ".")
        if parts?.count != 3 { fatalError("jwt is not valid!") }
        //Token
        let header = parts?[0]
        print("tokenPart1\(header)")
        defaults.set(header, forKey: "firstPartToken")
        //Contain info User
        let payload = parts?[1]
        let signature = parts?[2]
        print(decodeJWTPart(part: payload ?? "") ?? "could not converted to json!")
        let name  = decodeJWTPart(part: payload ?? "")
        //print(name)
        //print(name?.keys)
        if let fbemail = (name as AnyObject)["titular"]! as? String
        {
            //Save in userdefaults
            defaults.set(fbemail, forKey: "Usuario")
            print(defaults.string(forKey: "Usuario"))
        }
    }
    
    func base64StringWithPadding(encodedString: String) -> String {
        var stringTobeEncoded = encodedString.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let paddingCount = encodedString.count % 4
        for _ in 0..<paddingCount {
            stringTobeEncoded += "="
        }
        return stringTobeEncoded
    }
    
    func decodeJWTPart(part: String) -> [String: Any]? {
        let payloadPaddingString = base64StringWithPadding(encodedString: part)
        guard let payloadData = Data(base64Encoded: payloadPaddingString) else {
            fatalError("payload could not converted to data")
        }
        return try? JSONSerialization.jsonObject(
            with: payloadData,
            options: []) as? [String: Any]
    }
    
}


