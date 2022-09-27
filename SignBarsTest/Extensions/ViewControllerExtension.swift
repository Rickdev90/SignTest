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
    
    
}



    


