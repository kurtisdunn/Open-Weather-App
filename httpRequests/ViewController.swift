//
//  ViewController.swift
//  httpRequests
//
//  Created by Kurtis Dunn on 23/06/2015.
//  Copyright (c) 2015 Kurtis Dunn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func getData(sender: AnyObject) {
        var city:String = nameTextField.text
        var ecaspedUrl:String = city.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        getHttpData("http://api.openweathermap.org/data/2.5/weather?q=\(ecaspedUrl)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHttpData("http://api.openweathermap.org/data/2.5/weather?q=Thredbo")
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getHttpData(urlString: String){
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){ (data, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabel(data)
            })

        }
        task.resume()
        
        
        
    }
    func setLabel(resultData: NSData){
        var jsonError: NSError?
        
        let json = NSJSONSerialization.JSONObjectWithData(resultData, options: nil, error: &jsonError) as! NSDictionary
        
        // println("json Response \(json)")
        
        if var name = json["name"] as? String{
            nameLabel.text = name
        }
        if var  main = json["main"] as? NSDictionary {
            if let temp = main["temp"] as? Double {
                let cel = String(format: "%.1f", temp - 273.15) + " c"
                tempLabel.text = cel
            }
        }

    }
}

