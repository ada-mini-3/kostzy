//
//  ViewController.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//
import Foundation
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
    
//    var italicsFont1 = NSAttributedString(string: "kost", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
//    var italicsFont2 = NSAttributedString(string: "anak kost", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0)])
    
    lazy var descs = ["Find the most relatable 'kost' information, experience, culinary and hangout places that could be filtered based on your location.","Share your extraordinary 'kost' experiences to help the new 'anak kost' to know better about the real 'kost' life.", "We provide you the Community based on your 'kost' location. Join, socialize, and, discuss anything about your 'kost' life there! "]


    var imgs = ["onboarding1","onboarding2","onboarding3"]

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        print(UserDefaults.standard.bool(forKey: "FirstLaunch"))
        setupScrollView()
    }
    
//    private func setupItalicFont() -> String {
//        let italicAttrs = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)]
//        let kost = "kost"
//        _ = NSAttributedString(string: kost, attributes: italicAttrs)
//        return kost
//    }
    
    private func setupScrollView() {
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
            btnBack.isHidden = true
        }
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        self.scrollView.contentSize.height = 1.0
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }
    
    @IBAction func pageChanged(_ sender: Any) {
         scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    private func setIndicatorForCurrentPage()  {
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
                
                if pageCount == 0 {
                    btnBack.isHidden = true
                }
             }
             else {
                 pageControl.currentPage = pageCount
                 
                 return
             }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.scrollToPage(page: 2, animated: true)
        btnSkip.isHidden = true
        btnBack.isHidden=true
        btnStart.isHidden = false
        btnNext.isHidden = true
        pageCount = 2
        pageControl.currentPage = pageCount
        
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "FirstLaunch")
    }
    
}

extension ViewController{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            pageCount -= 1
        } else {
            pageCount += 1
        }
        
        if pageCount == 0 {
            btnSkip.isHidden=false
            btnBack.isHidden=true
            btnStart.isHidden=true
            btnNext.isHidden = false
        }
        else if pageCount == 1{
            btnSkip.isHidden=false
            btnBack.isHidden=false
            btnStart.isHidden=true
            btnNext.isHidden = false
        }
        else{
            btnSkip.isHidden=true
            btnNext.isHidden=true
            btnBack.isHidden=true
            btnStart.isHidden=false
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
}
