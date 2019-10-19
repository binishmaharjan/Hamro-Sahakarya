//
//  HSHomePagerController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/04/06.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import TinyConstraints


class HSHomePagerController:UIPageViewController{
  //MARK:Elements
  private var pages:[UIViewController] = [UIViewController]()
  private var currentIndex:Int = 0
  weak var topMenu:HSTopMenu?
  private var shouldScrollMenuBar:Bool = true
  
  //MARK:Init
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataSource = self
    self.delegate = self
    
    let view1 = UIViewController()
    view1.view.backgroundColor = HSColors.orange
    view1.view.tag = 0
    
    let view2 = UIViewController()
    view2.view.backgroundColor = HSColors.blue
    view2.view.tag = 1
    
    self.pages.append(view1)
    self.pages.append(view2)
    
    setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    
    setupScroll()
  }
  
  //MARK:Setup Scroll
  private func setupScroll(){
    let scrollView = self.view.subviews.compactMap{$0 as? UIScrollView}.first
    scrollView?.scrollsToTop = false
    scrollView?.delegate = self
  }
}

//MARK:Datasource and Delegate
extension HSHomePagerController:UIPageViewControllerDataSource, UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.firstIndex(of:viewController),
      viewControllerIndex != 0{
      return pages[0]
    }
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.firstIndex(of:viewController),
      viewControllerIndex != 1{
      return pages[1]
    }
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed{
      let index : Int = pageViewController.viewControllers?.first?.view.tag ?? 0
      currentIndex = index
    }
  }
}

//MARK:Scroll View Delegate
extension HSHomePagerController:UIScrollViewDelegate{
  func scrollViewDidScroll(_ scrollView: UIScrollView){
    // if scroll flag is negative return
    if !shouldScrollMenuBar{return}
    
    //            changes in x offset          -  scrollView.Content Size is three times the screen
    //                                            so dividing by 3 to get single screen size
    let scrollX = (scrollView.contentOffset.x) - (scrollView.contentSize.width / 3)
    //this gives the change in offset for one whole screen
    
    //Dividing it by the number of tabs  to get change in offset for a single tab
    let contentOffsetX = scrollX / 2
    
    //When scroll stops the offset gets reset to 0, so when not zero i.e swiping
    if contentOffsetX != 0{
      // required value = Current Index * Size of single tab + total change in x for the single tab
      let nextX = CGFloat(currentIndex) * (UIScreen.main.bounds.width / 2) + contentOffsetX
      self.pagerViewScrollChanged(offsetX: nextX)
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.shouldScrollMenuBar = true
  }
}

//MARK: Changes in the Bar / Current Page
extension HSHomePagerController{
  private func pagerViewScrollChanged(offsetX:CGFloat){
    guard let topMenu = self.topMenu else {return}
    topMenu.pagerViewScrollChanged(offsetX: offsetX)
  }
  
  func topMenuItemWasPressed(index:Int){
    self.shouldScrollMenuBar = false
    self.currentIndex = index
    let direction:UIPageViewController.NavigationDirection = (index == 0) ? .reverse : .forward
    self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
  }
}
