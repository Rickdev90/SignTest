//
//  ViewControllerExtension.swift
//  SignBarsTest
//
//  Created by Rick on 23/09/22.
//

import UIKit

fileprivate var activityView: UIView?

extension UIViewController{
    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activity = UIActivityIndicatorView(style: .large)
        activity.center = activityView!.center
        activity.startAnimating()
        activityView?.addSubview(activity)
        let textLabel = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height/3.3, width: self.view.bounds.width, height: self.view.bounds.height/2))
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.gray
            textLabel.text = "Conectando...."
        activityView?.addSubview(textLabel)

        self.view.addSubview(activityView!)
    }
    func removeSpinner(){
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func alertView(){
        let alert = UIAlertController(title: "Alert", message: "Email o contraseña incorrecto", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



    


