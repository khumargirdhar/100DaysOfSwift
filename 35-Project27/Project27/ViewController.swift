//
//  ViewController.swift
//  Project27
//
//  Created by Khumar Girdhar on 18/06/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawShockedEmoji()
            
        case 7:
            drawTWIN()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for column in 0..<8 {
                    if (row + column) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: column * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "Hello I'm a mouse! :D"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    //Challenge 1
    func drawShockedEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
            let leftEye = CGRect(x: 125, y: 100, width: 60, height: 90)
            let rightEye = CGRect(x: 320, y: 100, width: 60, height: 90)
            let mouth = CGRect(x: 180, y: 300, width: 150, height: 120)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawStarEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
        }
        
        imageView.image = image
    }
    
    //Challenge 2
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 20, y: 100)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            //Draw T
            ctx.cgContext.move(to: CGPoint(x: 5, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 53, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 53, y: 5))
            
            //Draw W
            ctx.cgContext.move(to: CGPoint(x: 130, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 160, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 175, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 175, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 190, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 190, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 220, y: 5))
            
            //Draw I
            ctx.cgContext.move(to: CGPoint(x: 250, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 345, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 297, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 297, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 250, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 345, y: 70))
            
            //Draw N
            ctx.cgContext.move(to: CGPoint(x: 375, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 375, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 375, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 430, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 430, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 430, y: 5))
            
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
}

