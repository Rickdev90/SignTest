//
//  CodeBarViewController.swift
//  SignBarsTest
//
//  Created by Rick on 23/09/22.
//

import UIKit
import CryptoKit


class CodeBarViewController: UIViewController  {
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var barImg: UIImageView!
    @IBOutlet weak var tokenLbl: UILabel!
    
    var filter: CIFilter!
    //var objectReceived: String = ""
    //var userReceived: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    private func configureView(){
        
        generateCode(str: getSha(str: defaults.string(forKey: "firstPartToken") ?? ""))
        //generateCode(str: defaults.string(forKey: "firstPartToken") ?? "")
        //userLbl.text = userReceived
        userLbl.text = ("Good afternoon \(String(describing: defaults.string(forKey: "Usuario") ?? ""))")
        tokenLbl.text = defaults.string(forKey: "firstPartToken")
    }
    
    func generateCode(str: String){
        
        let data = str.data(using: .ascii, allowLossyConversion: false)
        filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y:10)
        let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
        barImg.image = image
    }
    
    func getSha (str: String) -> String {
        let inputData = Data(str.utf8)
        let hashed = SHA256.hash(data: inputData)
        //print(hashed.description)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        print("hashh\(hashString)")
        return hashString
    }
}
