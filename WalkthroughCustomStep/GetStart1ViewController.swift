//
//  GetStart1ViewController.swift
//  WalkthroughCustomStep
//
//  Created by Lorenzo on 8/30/17.
//  Copyright © 2017 Lorenzo. All rights reserved.
//

import UIKit


class GetStart1ViewController: UIViewController {
    
    @IBOutlet weak var bluedotImg: UIImageView!
    
    @IBOutlet weak var baseView: UIView!
    
//    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var desclabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var exlplosivesImg: UIImageView!
    
    @IBOutlet weak var arrestImg: UIImageView!
    
    @IBOutlet weak var gunImg: UIImageView!
    
    @IBOutlet weak var htsLabel: UILabel!
    
    @IBOutlet weak var publicalertLabel: UILabel!
    
    @IBOutlet weak var notificationImg: UIImageView!
    
    public var animationShowed : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        desclabelConstraint.constant = UIScreen.main.bounds.width;
        secondConstraint.constant = UIScreen.main.bounds.width/2 - notificationImg.bounds.width/2
        
        setupInitialValues()
        
        self.exlplosivesImg.alpha = 0
        self.arrestImg.alpha = 0
        self.gunImg.alpha = 0
        
        self.htsLabel.alpha = 0
        self.publicalertLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            
            
            self.htsLabel.alpha =  1
            self.publicalertLabel.alpha = 1
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }

         
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupInitialValues() {
        
      
        
    }
    // MARK: - Button action

    
    //MARK: called from Main
    func startAnimation(){
        
        UIView.animate(withDuration: 1, animations: {
            
            
            self.publicalertLabel.alpha = 0.13
            
        })
        
        if animationShowed {
            
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.exlplosivesImg.alpha = 1
            
            
            
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            self.arrestImg.alpha = 1
            
        })
        
        UIView.animate(withDuration: 0.5, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            
            
            self.gunImg.alpha = 1
            
        })
        
        animationShowed = true
        
    }
    
    func animationBack(){
        
        self.publicalertLabel.alpha = 1
        
    }
    

    func setAlpha(alpah:CGFloat)
    {
        
        if animationShowed {
            self.exlplosivesImg.alpha = alpah
            self.arrestImg.alpha = alpah
            self.gunImg.alpha = alpah
            
            return
        }
        
    }
    

}
