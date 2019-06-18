import UIKit

struct ImageSprite {
    var sprite: String?
    var name: String?
}

class SpritesCarouselViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spritesScrollView: UIScrollView!
    @IBOutlet var spritesPageControl: UIPageControl!
    
    var sprites: [String]?
    var slides: [SlideViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadSprites(_ sprites: [String: String]) {
        self.slides = createSlides(sprites)
        setupSlides()
        spritesPageControl.numberOfPages = slides?.count ?? 0
        spritesPageControl.currentPage = 0
        view.bringSubviewToFront(spritesPageControl)
    }
    
    func createSlides(_ sprites: [String: String]) -> [SlideViewController] {
        var items: [SlideViewController] = []
        
        for (key, sprite) in sprites {
            let scrollViewItem = SlideViewController()
            scrollViewItem.nameLabel.text = key
            scrollViewItem.imageView.imageFromURL(urlString: sprite, withSize: nil)
            items.append(scrollViewItem)
        }
        return items
    }
    
    func setupSlides() {
        
        spritesScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        spritesScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides?.count ?? 0), height: view.frame.height)
        spritesScrollView.isPagingEnabled = true
        
        for (index, item) in slides?.enumerated() ?? [].enumerated() {
            item.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height / 1.5)
            item.imageView.backgroundColor = UIColor.red
            item.backgroundColor = UIColor.green
            
//            item.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
            
            spritesScrollView.addSubview(item)
            
        }
    }
    
}
