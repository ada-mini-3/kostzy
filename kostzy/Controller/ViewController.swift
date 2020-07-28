//
//  ViewController.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnStart: UIButton!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    var pageCount:Int = 0
    var titles = ["Find Information","Sharing Experiences","Join Community"]
    var descs = ["Find the most relatable kost information, experience, culinary and hangout places that could be filtered based on your location.","Share your extraordinary kost experiences to help the new anak kost to know better about the real kost life.","We provide you the Community based on your kost location. Join, socialize, and discuss anything around kost there! "]
    var imgs = ["onboarding1","onboarding2","onboarding3"]

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        UserDefaults.standard.bool(forKey: "FirstLaunch")

        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            imageView.frame = CGRect(x:0,y:0,width:300,height:300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
          
            let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
            txt1.textAlignment = .center
            txt1.font = UIFont.boldSystemFont(ofSize: 24.0)
            txt1.text = titles[index]

            let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY - 20,width:scrollWidth-70
                ,height:100))
            txt2.textAlignment = .center
            txt2.numberOfLines = 5
            txt2.font = UIFont.systemFont(ofSize: 14.0)
            txt2.text = descs[index]

            slide.addSubview(imageView)
            slide.addSubview(txt1)
            slide.addSubview(txt2)
            scrollView.addSubview(slide)
            btnStart.isHidden = true
            
        }
               scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
               self.scrollView.contentSize.height = 1.0
               pageControl.numberOfPages = titles.count
               pageControl.currentPage = 0

           }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "First Launch") == true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "skipSegue", sender: self)
                print("Segue performed - user defaults returned true!")
            }
        }
        if pageCount == 0 {
            btnBack.isHidden = true
        }
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
        
    @IBAction func pageChanged(_ sender: Any) {
         scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
            }

            func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                setIndiactorForCurrentPage()
            }

            func setIndiactorForCurrentPage()  {
                let page = (scrollView?.contentOffset.x)!/scrollWidth
                pageControl?.currentPage = Int(page)
            }
    
    func scrollToPage(page: Int, animated: Bool) {
          var frame: CGRect = self.scrollView.frame
          frame.origin.x = frame.size.width * CGFloat(page)
          frame.origin.y = 0
          self.scrollView.scrollRectToVisible(frame, animated: animated)
      }

    @IBAction func nextPage(_ sender: Any) {
        btnBack.isHidden = false
              if pageCount < 2 {
                  pageCount += 1
                  self.scrollToPage(page: pageCount, animated: true)
                  pageControl.currentPage = pageCount
                  
                  if pageCount == 2 {
                    btnStart.isHidden = false
                    btnNext.isHidden = true
                    btnBack.isHidden = true
                    btnSkip.isHidden = true
                  }
                  else {
                      btnNext.setTitle("", for: UIControl.State.normal)
                  }
              }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        if pageCount == 1 {
                 btnBack.isHidden = false
             }
             
             if pageCount > 0 {
                 pageCount -= 1
                 self.scrollToPage(page: pageCount, animated: true)
                 pageControl.currentPage = pageCount
             }
             else {
                 pageControl.currentPage = pageCount
                 
                 return
             }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.scrollToPage(page: 2, animated: true)
        btnSkip.isHidden = true
        btnStart.isHidden = false
        btnNext.isHidden = true
    }
    
}
