//
//  ViewController.swift
//  SignBarsTest
//
//  Created by Rick on 22/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var LogInBtn: UIButton!
    
    var viewModel = ViewModelLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            DispatchQueue.main.async {
                self?.removeSpinner()
                print("hola\(self?.viewModel.dataLoginResponse?.success)")
                if self?.viewModel.dataLoginResponse?.success == true{
                    self?.performSegue(withIdentifier: "segueCodeBar", sender: self)
                }else{
                    
                    //self?.invalidLbl.isHidden = false
                }
            }
        }
        
    }


}

