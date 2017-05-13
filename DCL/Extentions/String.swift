//
//  String.swift
//  DCL
//
//  Created by Nikita on 1/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    //*****************************************************************
    // MARK: - Localized
    //*****************************************************************
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    //*****************************************************************
    // MARK: - Check Email
    //*****************************************************************
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }

    func isValidLoginOnly() -> Bool {
        let emailRegEx = "[A-Za-z - .]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self.lowercased())
    }
    
    //*****************************************************************
    // MARK: - forbid emoji
    //*****************************************************************
    
    func containsEmoji() -> Bool {
        
        if self.isEmoji() {
            return true
        }
        return false
    }
    
    func isEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9,// Special Characters
            0x1D000...0x1F77F,          // Emoticons
            0x2100...0x27BF,            // Misc symbols and Dingbats
            0xFE00...0xFE0F,            // Variation Selectors
            0x1F900...0x1F9FF:          // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    //*****************************************************************
    // MARK: - Check login fields
    //*****************************************************************
    
    static func unwrapCheck(_ item: String?, _ type: FieldType) -> Bool {
        let field : String  = type.rawValue + AlertText.FieldIsEmpty
        guard let current = item  else {            
            Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: field, action:nil)
            return false
        }
        if current.isEmpty || current.trimmingCharacters(in: CharacterSet.whitespaces).characters.count == 0 {
            Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: field, action:nil)
            return false
        }
        
        return true
    }
    
    //*****************************************************************
    // MARK: - String with Date
    //*****************************************************************

    func stringWithDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: self) else {return ""}
        return date.dateToString()
    }
    
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    
    //*****************************************************************
    // MARK: - Strikethrough text
    //*****************************************************************
    
    func strikeThroughText() -> NSAttributedString {
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 16) as Any,
                                NSForegroundColorAttributeName: DefaultGradient.checkListTextColor ]
        let attributeString = NSMutableAttributedString(string: self, attributes: myAttribute)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
 
        return attributeString
    }
    
    func normalText() -> NSAttributedString {
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 16) as Any,
                            NSForegroundColorAttributeName: DefaultGradient.checkListTextColor ]
        let attributeString = NSMutableAttributedString(string: self, attributes: myAttribute)
        return attributeString
    }
    
    //*****************************************************************
    // MARK: - To Base 64
    //*****************************************************************

    static func convertImageToBase64(image : UIImage) -> String {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.7)! as NSData
        let imageBase64:String = imageData.base64EncodedString(options: [])
        
        let paramString = "data:image/jpeg;base64,\(imageBase64)"
        return paramString
    }
    
    static func convertVideoToBase64(video: URL) -> String {
        guard let data:NSData = NSData.init(contentsOf: video) else {return ""}
        let dataBase64:String = data.base64EncodedString(options: [])
        
        let paramString = "data:image/MOV;base64,\(dataBase64)"
        return paramString
    }
    
    func checkFileSize() -> Bool {
        
        let maxSize = 24 * 1024 * 1024 // 24MB
      
        let lengthImage = self.lengthOfBytes(using: String.Encoding.utf32)
    
        if maxSize > lengthImage {
            return true
        }
        return false
    }
    
    //*****************************************************************
    // MARK: - Detect backspace pressed
    //*****************************************************************
    
    func detectBackspacePressed() -> Bool {
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }     
        
        return false
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
}


