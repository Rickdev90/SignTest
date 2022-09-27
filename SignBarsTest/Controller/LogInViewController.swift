//
//  LogInViewController.swift
//  SignBarsTest
//
//  Created by Rick on 26/09/22.
//

import UIKit
import CryptoKit

let defaults = UserDefaults.standard

class LogInViewController: UIViewController {
    
    
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
        LogInBtn.layer.cornerRadius = 5
        LogInBtn.layer.borderWidth = 1
        LogInBtn.layer.borderColor = UIColor.black.cgColor
        self.hideKeyboardWhenTappedAround()
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
                    self?.navigationController?.pushViewController(vc!, animated: true)
                    
                }else{
                    self?.alertView()
                }
            }
        }
    }
}
