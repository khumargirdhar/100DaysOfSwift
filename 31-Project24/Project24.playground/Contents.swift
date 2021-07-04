import UIKit

//var name = "Taylor"
//
//for letter in name {
//    print(letter)
//}
//
//print(name[name.index(name.startIndex, offsetBy: 3)])
//
//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
//
//let letter2 = name[5]

//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("456")
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//
//    func deletingSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}

//let weather = "it's going to rain."
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}

//let input = "Swift is like Objective-C without the C"
//input.contains("Swift")
//
//let languages = ["Python", "C++", "Swift", "Java", "VB.NET"]
//languages.contains("Swift")
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//
//        return false
//    }
//}
//
//input.containsAny(of: languages)
//
//languages.contains(where: input.contains)

//let string = "This is a test string"

//let attributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor: UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]
//
//let attributedString = NSAttributedString(string: string, attributes: attributes)

//let attributedString = NSMutableAttributedString(string: string)
//
//attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
//attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
//attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
//attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

//CHALLENGE 1
//let string = "pet"

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return prefix + self
    }
}

//string.withPrefix("Car")

//CHALLENGE 2
//let string = "Hello123World"

extension String {
    var isNumeric: Bool {
        for character in self {
            let character = String(character)
            if Int(character) != nil {
                return true
            }
        }
        return false
    }
}

//string.isNumeric

//CHALLENGE 3
let string = "Hello\nWorld\nThis\nIs\nA\nString"

extension String {
    var lines: [String] {
        var arr = [String]()
        arr = self.components(separatedBy: "\n")
        return arr
    }
}

print(string.lines)
