//
//  GetStartMainViewController.swift
//  WalkthroughCustomStep
//
//  Created by Lorenzo on 8/30/17.
//  Copyright © 2017 Lorenzo. All rights reserved.
//

import UIKit

class GetStartMainViewController: LMWalkthroughViewController ,LMWalkthroughViewControllerDelegate{

    @IBOutlet weak var skipBtn: UIButton!
    
    var page_one : GetStart1ViewController? = nil;
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var pageCtl: UIPageControl!
    
    @IBOutlet weak var bottomSigninConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.title = " "

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.automaticallyAdjustsScrollViewInsets = false;
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        page_one = stb.instantiateViewController(withIdentifier: "GetStart1ViewController") as? GetStart1ViewController
      
        
        
        // Attach the pages to the master
        
        self.add(viewController:page_one!)
        
        self.delegate = self
        self.skipBtn.isHidden = true
        self.pageCtl.isHidden = true
        
        self.bottomSigninConstraint.constant = 13
        
    
        
    }
    
   
    @IBAction func signinBtn_pushed(_ sender: Any) {
        
    }
        
    @IBAction func getStartedBtn_pushed(_ sender: Any) {
        self.setPage(pagenumber: 1)
    }
    
    func startAnimation(){
        self.skipBtn.isHidden = true
        self.pageCtl.isHidden = true
        bottomSigninConstraint.constant = -(self.signInBtn.frame.height + self.getStartedBtn.frame.height + 13)
        
        page_one?.startAnimation();
        
        self.skipBtn.isHidden = false
        self.pageCtl.isHidden = false
        
    }
    
    func backAnimation(){
        
        self.skipBtn.isHidden = true
        self.pageCtl.isHidden = true
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomSigninConstraint.constant = 13
            self.view.layoutIfNeeded()
        })
        
        page_one?.animationBack()
    }
    
    //MARK: workthrough delegate
    func walkthroughPageDidChange(_ pageNumber: Int) {
        
        self.pageCtl?.currentPage = pageNumber
        if (pageNumber == 1){
            self.skipBtn.setTitle("Skip  >", for: .normal)
            
        }else if (pageNumber == 2){
            self.skipBtn.setTitle("Sign Up  >", for: .normal)
        }
        
        if pageNumber == 0 {
            backAnimation()
            
            if (page_one?.animationShowed)! {
                page_one?.exlplosivesImg.alpha = 0
                page_one?.arrestImg.alpha = 0
                page_one?.gunImg.alpha = 0
                
            }
            
        }else if pageNumber == 1{
            self.startAnimation()
            
            if (page_one?.animationShowed)! {
                page_one?.exlplosivesImg.alpha = 1
                page_one?.arrestImg.alpha = 1
                page_one?.gunImg.alpha = 1
                
            }
            
        }
        
    }
    
    func walkthroughPageSwitch(distance : CGFloat){
        var alpah: CGFloat = 0.0
        if (distance < 0)
        {
            alpah = 1 + 1 / 148 * distance
            
            print("Current Page \(alpah)")
            
            bottomSigninConstraint.constant = 13 - (self.signInBtn.frame.height + self.getStartedBtn.frame.height + 20) * alpah
            
        }else{
            alpah = 1 / 148 * distance
            
            bottomSigninConstraint.constant = 13 - (self.signInBtn.frame.height + self.getStartedBtn.frame.height + 20) * alpah
        }
        page_one?.setAlpha(alpah: alpah)
        self.view.layoutIfNeeded()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
