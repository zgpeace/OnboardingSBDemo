//
//  ViewController.swift
//  OnboardingSBDemo
//
//  Created by zgpeace on 2019/10/29.
//  Copyright © 2019 zgpeace. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.delegate = self
        }
    }
    
    var slides:[Slide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
    }
    
    override func viewDidLayoutSubviews() {
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Slide] {
        let imageNames = ["ic_onboarding_1", "ic_onboarding_2", "ic_onboarding_3", "ic_onboarding_4", "ic_onboarding_5"]
        let titles = ["A real-life bear", "A real-life bear", "A real-life bear", "A real-life bear", "A real-life bear"]
        let descriptions = ["Did you know that Winnie the chubby little cubby was based on a real, young bear in London", "Did you know that Winnie the chubby little cubby was based on a real, young bear in London", "Did you know that Winnie the chubby little cubby was based on a real, young bear in London", "Did you know that Winnie the chubby little cubby was based on a real, young bear in London", "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"]
        let nibName = "Slide"
        
        var slides: [Slide] = []
        for i in 0...4 {
            let slide:Slide = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! Slide
            slide.imageView.image = UIImage(named: imageNames[i])
            slide.labelTitle.text = titles[i]
            slide.labelDesc.text = descriptions[i]
            slide.labelDesc.sizeToFit()
            slides.append(slide)
        }
        
        return slides
    }
    
    func setupSlideScrollView(slides: [Slide]) {
        let rect = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = rect
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(slides.count), height: rect.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: rect.width * CGFloat(i), y: 0, width: rect.width, height: rect.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVertiacalOffset: CGFloat = (maximumVerticalOffset == 0) ? 1 : currentVerticalOffset/maximumVerticalOffset
        
        // below code changes the background color of view on paging the scrollview
//        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        // below code scales the imageView on paging the scrollView
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVertiacalOffset)
        
        let unit: CGFloat = 0.25
        for i in 0...3 {
            let gap = unit * CGFloat(i)
            if percentOffset.x > (0 + gap)  && percentOffset.x <= (0.25 + gap) {
                slides[i].imageView.transform = CGAffineTransform(scaleX: ((0.25 + gap)-percentOffset.x)/0.25, y: ((0.25 + gap)-percentOffset.x)/0.25)
                slides[i+1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/(0.25 + gap), y: percentOffset.x/(0.25 + gap))
                break
            }
        }
                
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//
//            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
    }
    
    func scrollview(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if pageControl.currentPage == 0 {
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
            
        }
    }
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade color
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }


}

