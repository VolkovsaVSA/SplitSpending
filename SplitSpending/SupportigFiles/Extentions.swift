//
//  Extentions.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 16/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit


//extension String {
//
//    private func allNumsToDouble() -> String {
//
//        let symbolsCharSet = ".,"
//        let fullCharSet = "0123456789" + symbolsCharSet
//        var i = 0
//        var result = ""
//        let chars = Array(self)
//        while i < chars.count {
//            if fullCharSet.contains(chars[i]) {
//                var numString = String(chars[i])
//                i += 1
//                loop: while i < chars.count {
//                    if fullCharSet.contains(chars[i]) {
//                        numString += String(chars[i])
//                        i += 1
//                    } else {
//                        break loop
//                    }
//                }
//                if let num = Double(numString) {
//                    result += "\(num)"
//                } else {
//                    result += numString
//                }
//            } else {
//                result += String(chars[i])
//                i += 1
//            }
//        }
//        return result
//    }
//
//    func calculate() -> Double? {
//        let transformedString = allNumsToDouble()
//        let expr = NSExpression(format: transformedString)
//        return expr.expressionValue(with: nil, context: nil) as? Double
//    }
//}
//
//extension NSExpression {
//
//    func toFloatingPoint() -> NSExpression {
//        switch expressionType {
//        case .constantValue:
//            if let value = constantValue as? NSNumber {
//                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
//            }
//        case .function:
//           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
//           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
//        case .conditional:
//           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
//        case .unionSet:
//            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
//        case .intersectSet:
//            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
//        case .minusSet:
//            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
//        case .subquery:
//            if let subQuery = collection as? NSExpression {
//                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
//            }
//        case .aggregate:
//            if let subExpressions = collection as? [NSExpression] {
//                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
//            }
//        case .anyKey:
//            print("anyKey not yet implemented")
//        case .block:
//            print("block not yet implemented")
//        case .evaluatedObject, .variable, .keyPath:
//            break // Nothing to do here
//        @unknown default:
//            break
//        }
//        return self
//    }
//}

//extension UIImageView {
//
//    func setBlur(value: Int) {
//
//        let inputImage = CIImage(cgImage: (self.image?.cgImage)!)
//        let filter = CIFilter(name: "CIGaussianBlur")
//        filter?.setValue(inputImage, forKey: "inputImage")
//        filter?.setValue(value, forKey: "inputRadius")
//        let blurred = filter?.outputImage
//
//        var newImageSize: CGRect = (blurred?.extent)!
//        newImageSize.origin.x += (newImageSize.size.width - (self.image?.size.width)!) / 2
//        newImageSize.origin.y += (newImageSize.size.height - (self.image?.size.height)!) / 2
//        newImageSize.size = (self.image?.size)!
//
//        let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
//        let context: CIContext = CIContext.init(options: nil)
//        let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
//        let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
//
//        self.image = blurredImage
//    }
//
//}

extension UIViewController {
    //    func addTapGestureToHideKeyboard() {
    //        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
    //        view.addGestureRecognizer(tapGesture)
    //    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setupKeyboardObservers(heightCorrection: CGFloat) {
        UserDefaults.standard.set(heightCorrection, forKey: "heightCorrection")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any], let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        var heightCorrection: CGFloat = 0
        heightCorrection = CGFloat(UserDefaults.standard.float(forKey: "heightCorrection"))
        
        let keyboardHeight = keyboardFrame.height - heightCorrection
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardHeight
            }
        } else {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
        
    }
}


