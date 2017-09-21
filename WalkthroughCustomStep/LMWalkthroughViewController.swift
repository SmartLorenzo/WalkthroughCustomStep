
 //  WalkthroughCustomStep
 //
 //  Created by Lorenzo on 9/7/17.
 //  Copyright © 2017 Lorenzo. All rights reserved.
 //
import UIKit

// MARK: - Protocols -


/// Walkthrough Delegate:
/// This delegate performs basic operations such as dismissing the Walkthrough or call whatever action on page change.
/// Probably the Walkthrough is presented by this delegate.
@objc public protocol LMWalkthroughViewControllerDelegate{
   
    @objc optional func walkthroughPageDidChange(_ pageNumber:Int)   // Called when current page changes
    @objc optional func walkthroughPageSwitch(distance : CGFloat)
}


/// Walkthrough Page:
/// The walkthrough page represents any page added to the Walkthrough.
@objc public protocol LMWalkthroughPage{
    /// While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
    /// While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
    /// The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
    /// This value can be used on the previous, current and next page to perform custom animations on page's subviews.
    @objc func walkthroughDidScroll(to:CGFloat, offset:CGFloat)   // Called when the main Scrollview...scrolls
}


@objc open class LMWalkthroughViewController: UIViewController, UIScrollViewDelegate{
    
    // MARK: - Public properties -
    
    weak open var delegate:LMWalkthroughViewControllerDelegate?
    
    // If you need a page control, next or prev buttons, add them via IB and connect with these Outlets
    @IBOutlet open var pageControl:UIPageControl?
    @IBOutlet open var nextButton:UIButton?
    @IBOutlet open var prevButton:UIButton?
    @IBOutlet open var closeButton:UIButton?
    
    var currentPage : Int = 0
    
    open var currentViewController:UIViewController{ //the controller for the currently visible page
        get{
            let currentPage = self.currentPage;
            return controllers[currentPage];
        }
    }
    
    open var numberOfPages:Int{ //the total number of pages in the walkthrough
        get {
            return self.controllers.count
        }
    }
    
    
    // MARK: - Private properties -
    
    open let scrollview = UIScrollView()
    private var controllers = [UIViewController]()
    private var lastViewConstraint: [NSLayoutConstraint]?
    
    
    // MARK: - Overrides -
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Setup the scrollview
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.isPagingEnabled = false
        scrollview.clipsToBounds = false
        scrollview.decelerationRate = UIScrollViewDecelerationRateNormal
        scrollview.isUserInteractionEnabled = false
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UI Elements
        
        pageControl?.addTarget(self, action: #selector(LMWalkthroughViewController.pageControlDidTouch), for: UIControlEvents.touchUpInside)
        
        // Scrollview
        
        scrollview.delegate = self
        scrollview.translatesAutoresizingMaskIntoConstraints = false 
        view.insertSubview(scrollview, at: 0) //scrollview is inserted as first view of the hierarchy
        
        // Set scrollview related constraints
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollview]-0-|", options:[], metrics: nil, views: ["scrollview":scrollview] as [String: UIView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollview]-0-|", options:[], metrics: nil, views: ["scrollview":scrollview] as [String: UIView]))
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        updateUI(scrollView: self.scrollview)
        
        pageControl?.numberOfPages = controllers.count
        pageControl?.currentPage = 0
    }
    
    
  
    
    /// If you want to implement a "skip" button
    /// connect the button to this IBAction and implement the delegate with the skipWalkthrough
    @IBAction open func close(_ sender: AnyObject) {
        
    }
    
    func pageControlDidTouch(){
        if let pc = pageControl{
            gotoPage(pc.currentPage)
        }
    }
    
    fileprivate func gotoPage(_ page:Int){
        
        if page < controllers.count{
            var frame = scrollview.frame
            frame.origin.x = CGFloat(page) * frame.size.width
            scrollview.scrollRectToVisible(frame, animated: true)
        }
    }
    
    /// Add a new page to the walkthrough.
    /// To have information about the current position of the page in the walkthrough add a UIViewController which implements LMWalkthroughPage
    /// - viewController: The view controller that will be added at the end of the view controllers list.
    open func add(viewController:UIViewController)->Void{
        
        controllers.append(viewController)
        
        // Make children aware of the parent
        
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        
        // Setup the viewController view
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(viewController.view)
        
        // Constraints
        
        let metricDict = ["w":viewController.view.bounds.size.width,"h":viewController.view.bounds.size.height]
        
        // Generic cnst
        let viewsDict: [String: UIView] = ["view":viewController.view, "container": scrollview]
        
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==container)]", options:[], metrics: metricDict, views: viewsDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==container)]", options:[], metrics: metricDict, views: viewsDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]|", options:[], metrics: nil, views: viewsDict))
        
        // cnst for position: 1st element
        if controllers.count == 1{
            scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]", options:[], metrics: nil, views: ["view":viewController.view]))
            
            // cnst for position: other elements
        } else {
            
            if  (controllers.count == 2)
            {
                let previousVC = controllers[0]
            
                if (previousVC.view) != nil {
                    // For this constraint to work, previousView can not be optional
                    scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[view]", options:[], metrics: nil, views: ["view":viewController.view]))
                }
            }
            
            if (controllers.count == 3){
                
                let previousVC = controllers[1]
                
                if let previousView = previousVC.view {
                    // For this constraint to work, previousView can not be optional
                    scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-50-[view]", options:[], metrics: nil, views: ["previousView":previousView,"view":viewController.view]))
                }
            }
            if let cst = lastViewConstraint {
                scrollview.removeConstraints(cst)
            }
            lastViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-0-|", options:[], metrics: nil, views: ["view":viewController.view])
            scrollview.addConstraints(lastViewConstraint!)
        }
    }
    
    /// Update the UI to reflect the current walkthrough status
    fileprivate func updateUI(scrollView: UIScrollView){
        
        print("\(scrollview.contentOffset.x)")
        
        let screenWidth = UIScreen.main.bounds.width
        let currentOffset = scrollview.contentOffset.x
        
        if (currentOffset < 90)
        {
            self.setPage(pagenumber: 0)
        }else if (currentOffset >= 90 && currentOffset <= 90 + screenWidth/3*2) {
           
            self.setPage(pagenumber: 1)
            
        }else {
            scrollView.setContentOffset(CGPoint(x: screenWidth  + 148, y:0) , animated: true)
            self.setPage(pagenumber: 2)
        }
        
        
    }
    func setPage(pagenumber:Int) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        if (pagenumber == 0)
        {
            scrollview.setContentOffset(CGPoint(x: 0, y:0) , animated: true)
            currentPage = 0
        }else if (pagenumber == 1)
        {
            scrollview.setContentOffset(CGPoint(x: 148, y:0) , animated: true)
            currentPage = 1
        }else if (pagenumber == 2)
        {
            scrollview.setContentOffset(CGPoint(x: screenWidth  + 148, y:0) , animated: true)
            currentPage = 2
        }
        
        self.delegate?.walkthroughPageDidChange!(currentPage)
    }
    
    
    
    
    var beginX : CGFloat?
    var currentOffset : CGFloat?
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        beginX = touches.first?.location(in: self.view).x
        currentOffset = scrollview.contentOffset.x
        
        
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        var distance = beginX! - (touches.first?.location(in: self.view).x)!
        
        
        if (currentPage == 0 && distance < 0)
        {
            distance = distance * 0.1
            
        }else if ((currentPage == 0 && distance > 0) || (currentPage == 1 && distance < 0))
        {
            distance = distance * (148 / UIScreen.main.bounds.width)
            
            self.delegate?.walkthroughPageSwitch!(distance: distance)
            
        }else if (currentPage == 2 && distance > 0)
        {
            distance = distance * 0.1
        }
        
        let newOffset = currentOffset! + distance
        
        scrollview.setContentOffset(CGPoint(x: newOffset, y:0) , animated: false)
 
       
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentOffset = scrollview.contentOffset.x
        
        let screenWidth = UIScreen.main.bounds.width
        
        if (currentOffset! < 90)
        {
            self.setPage(pagenumber: 0)
        }else if (currentOffset! >= 90 && currentOffset! <= 90 + screenWidth/3*2) {
            
            self.setPage(pagenumber: 1)
            
        }else {
            scrollview.setContentOffset(CGPoint(x: screenWidth  + 148, y:0) , animated: true)
            self.setPage(pagenumber: 2)
        }
    }
}
