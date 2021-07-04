import UIKit

//Challenge 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: []) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        } completion: { finished in
            print("CGAffineTransform - ation finished")
        }

    }
}


//Challenge 2
extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else {
            print("Negative numbers are not allowed!")
            return
        }
        
        for _ in 0..<self {
            closure()
        }
    }
}


//Challenge 3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

