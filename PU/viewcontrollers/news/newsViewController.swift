//
//  newsViewController.swift
//  PU
//
//  Created by DHRUV on 30/03/24.
//

import UIKit
import WebKit

class newsViewController: UIViewController {
    

    @IBOutlet weak var newsweb: WKWebView!
    
    private let ur: URL = URL(string:"https://paruluniversity.ac.in/pu-mirror")!
    override func viewDidLoad() {
        super.viewDidLoad()
        let preference = WKWebpagePreferences()
        preference.preferredContentMode = .mobile
        preference.allowsContentJavaScript = true
        
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preference
        
        newsweb.load(URLRequest(url: ur))
         // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
