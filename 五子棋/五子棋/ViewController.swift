//
//  ViewController.swift
//  五子棋
//
//  Created by 叶俊中 on 16/7/17.
//  Copyright © 2016年 叶俊中. All rights reserved.
//

import UIKit

class ViewController: UIViewController,step{
    var qipan = lineView()
    
    @IBOutlet weak var wininfo: UILabel!
    @IBAction func reload(sender: UIButton) {
        //self.viewDidLoad()
        qipan.removeFromSuperview()
        qipan = lineView.init(frame: CGRectMake(qipanview.frame.origin.x + 25, qipanview.frame.origin.y + 25, self.view.bounds.width - 50,self.view.bounds.width - 50))
        qipan.delegate = self
        qipan.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(qipan)
        step.text = "0"
        //self.reloadInputViews()
    }
    @IBOutlet weak var step: UILabel!
    
    @IBOutlet weak var qipanview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        wininfo.hidden = true
        qipan = lineView.init(frame: CGRectMake(qipanview.frame.origin.x + 25, qipanview.frame.origin.y + 25, self.view.bounds.width - 50,self.view.bounds.width - 50))
        qipan.delegate = self
        qipan.backgroundColor = UIColor.yellowColor()
        //qipan.removeFromSuperview()
        self.view.addSubview(qipan)
        let a = ["A","B","C","D","E","F","G","H","I","J","K","L","M"]
        for i in 1...13 {
            let tab = UILabel(frame:CGRectMake(0,0, 25, (self.view.bounds.width - 50) / 14))
            tab.center = CGPointMake(25 / 2, qipanview.frame.origin.y + 25 + (self.view.bounds.width - 50) * CGFloat(i) / 14)
            tab.text = "\(i)"
            tab.textAlignment = .Center
            self.view.addSubview(tab)
            let tab1 = UILabel(frame:CGRectMake(0,0,(self.view.bounds.width - 50) / 14,25))
            tab1.center = CGPointMake(25 + (self.view.bounds.width - 50) * CGFloat(i) / 14, qipanview.frame.origin.y + 25 / 2)
            tab1.text = a[i-1]
            tab1.textAlignment = .Center
            self.view.addSubview(tab1)
        }
    }
    func stepnum(a: Int){
        //print(a)
        step.text = "\(a)"
    }
    func wininfo(a:Int){
        switch a {
        case 1:
            wininfo.text = "黑棋胜利"
        case -1:
            wininfo.text = "白棋胜利"
        default:
            break
        }
        wininfo.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

