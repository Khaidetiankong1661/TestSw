//
//  ProfileViewController.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , Emitterables {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vies = TextView.loadFromNib()
        
        view.addSubview(vies)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        start()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
