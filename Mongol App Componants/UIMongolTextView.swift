import UIKit

@IBDesignable class UIMongolTextView: UIView {

    // FIXME: long load time
    
    // MARK:- Unique to TextView
    
    // ********* Unique to TextView *********
    private var view = UITextView()
    private var userInteractionEnabledForSubviews = true
    private let mongolFontName = "ChimeeWhiteMirrored"
    private let defaultFontSize: CGFloat = 17
    
    @IBInspectable var text: String {
        get {
            return view.text
        }
        set {
            view.text = newValue
        }
    }
    
    @IBInspectable var fontSize: CGFloat {
        get {
            if let font = view.font {
                return font.pointSize
            } else {
                return 0.0
            }
        }
        set {
            view.font = UIFont(name: mongolFontName, size: newValue)
        }
   }
    
    @IBInspectable var textColor: UIColor {
        get {
            if let color = view.textColor {
                return color
            } else {
                return UIColor.blackColor()
            }
        }
        set {
            view.textColor = newValue
        }
    }
    
    @IBInspectable var centerText: Bool {
        get {
            return view.textAlignment == NSTextAlignment.Center
        }
        set {
            if newValue {
                view.textAlignment = NSTextAlignment.Center
            }
        }
    }
    
    @IBInspectable var editable: Bool {
        get {
            return view.editable
        }
        set {
            view.editable = newValue
        }
    }
    
    @IBInspectable var selectable: Bool {
        get {
            return view.selectable
        }
        set {
            view.selectable = newValue
        }
    }
    
    var scrollEnabled: Bool {
        get {
            return view.scrollEnabled
        }
        set {
            view.scrollEnabled = newValue
        }
    }
    
    var attributedText: NSAttributedString! {
        get {
            return view.attributedText
        }
        set {
            view.attributedText = newValue
        }
    }
    
    var layoutManager: NSLayoutManager {
        get {
            return view.layoutManager
        }
    }
    
    var contentSize: CGSize {
        get {
            return CGSize(width: view.contentSize.height, height: view.contentSize.width)
        }
        set {
            view.contentSize = CGSize(width: newValue.height, height: newValue.width)
        }
    }
    
    var underlyingTextView: UITextView {
        get {
            return view
        }
        set {
            view = newValue
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        // swap the length and width coming in and going out
        let fitSize = view.sizeThatFits(CGSize(width: size.height, height: size.width))
        return CGSize(width: fitSize.height, height: fitSize.width)
    }
    
    func setup() {
        // 1-10: ᠨᠢᠭᠡ ᠬᠤᠶᠠᠷ ᠭᠤᠷᠪᠠ ᠳᠦᠷᠪᠡ ᠲᠠᠪᠤ ᠵᠢᠷᠭᠤᠭ᠎ᠠ ᠳᠤᠯᠤᠭ᠎ᠠ ᠨᠠᠢ᠌ᠮᠠ ᠶᠢᠰᠦ ᠠᠷᠪᠠ
        
        view.backgroundColor = UIColor.clearColor()
        
        // set font if user didn't specify size in IB
        if self.view.font?.fontName != mongolFontName {
            
            view.font = UIFont(name: mongolFontName, size: defaultFontSize)
        }
        
    }
    
    
    // MARK:- General code for Mongol views
    
    // *******************************************
    // ****** General code for Mongol views ******
    // *******************************************
    
    private var oldWidth: CGFloat = 0
    private var oldHeight: CGFloat = 0
    
    // This method gets called if you create the view in the Interface Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // This method gets called if you create the view in code
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layoutSubviews gets called multiple times, only need it once
        if self.frame.height == oldHeight && self.frame.width == oldWidth {
            return
        } else {
            oldWidth = self.frame.width
            oldHeight = self.frame.height
        }
        
        // Remove the old rotation view
        if self.subviews.count > 0 {
            self.subviews[0].removeFromSuperview()
        }
        
        // setup rotationView container
        let rotationView = UIView()
        rotationView.frame = CGRect(origin: CGPointZero, size: CGSize(width: self.bounds.height, height: self.bounds.width))
        rotationView.userInteractionEnabled = userInteractionEnabledForSubviews
        self.addSubview(rotationView)
        
        // transform rotationView (so that it covers the same frame as self)
        rotationView.transform = translateRotateFlip()
        
        
        
        // add view
        view.frame = rotationView.bounds
        rotationView.addSubview(view)
        
    }
    
    func translateRotateFlip() -> CGAffineTransform {
        
        var transform = CGAffineTransformIdentity
        
        // translate to new center
        transform = CGAffineTransformTranslate(transform, (self.bounds.width / 2)-(self.bounds.height / 2), (self.bounds.height / 2)-(self.bounds.width / 2))
        // rotate counterclockwise around center
        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        // flip vertically
        transform = CGAffineTransformScale(transform, -1, 1)
        
        return transform
    }

}
