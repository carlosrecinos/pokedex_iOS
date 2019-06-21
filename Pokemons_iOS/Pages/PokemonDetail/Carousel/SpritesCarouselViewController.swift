import UIKit

struct ImageSprite {
    var sprite: String?
    var name: String?
}

class SpritesCarouselViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spritesScrollView: UIScrollView!
    @IBOutlet var spritesPageControl: UIPageControl!
    
    var sprites: [String]?
    var slides: [SlideView]?

    override func viewDidLoad() {
        super.viewDidLoad()
        spritesScrollView?.delegate = self
    }
    
    func loadSprites(_ sprites: [String: String]) {
        self.slides = createSlides(sprites)
        setupSlides()
        spritesPageControl.numberOfPages = slides?.count ?? 0
        spritesPageControl.currentPage = 0
        view.bringSubviewToFront(spritesPageControl)
    }
    
    func createSlides(_ sprites: [String: String]) -> [SlideView] {
        var items: [SlideView] = []
        
        for (key, sprite) in sprites {
            let scrollViewItem = SlideView()
            scrollViewItem.nameLabel.text = key
            scrollViewItem.nameLabel.textColor = UIColor.pokeBlue
            scrollViewItem.imageView.imageFromURL(urlString: sprite, withSize: nil)

            items.append(scrollViewItem)
        }
        return items
    }
    
    func setupSlides() {
        
        spritesScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        spritesScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides?.count ?? 0), height: view.frame.height)
        spritesScrollView.isPagingEnabled = true
        
        for (index, item) in slides?.enumerated() ?? [].enumerated() {
            item.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
            item.imageView.backgroundColor = UIColor.pokeYellow

            spritesScrollView.addSubview(item)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(spritesScrollView.contentOffset.x / view.frame.width)
        spritesPageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = spritesScrollView.contentSize.width - spritesScrollView.frame.width
        let currentHorizontalOffset: CGFloat = spritesScrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = spritesScrollView.contentSize.height - spritesScrollView.frame.height
        let currentVerticalOffset: CGFloat = spritesScrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides?[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides?[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides?[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides?[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        }// else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            slides?[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            slides?[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            slides?[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides?[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
    }
    
}
