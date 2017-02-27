import Foundation
import UIKit

extension UITextView {
    
    func rangeOfWordAtCurrentCursorLocation() -> NSRange? {
        let selectedRange = self.selectedRange
        if selectedRange.length == 0 {
            return text.rangeOfWordAtLocation(location: selectedRange.location)
        }
        return nil
    }
    
    func wordAtCurrentCursorLocation() -> String? {
        guard let range = self.rangeOfWordAtCurrentCursorLocation() else { return nil }
        return (text as NSString).substring(with: range)
    }
    
    func replaceWordAtCurrentCursorPositionWithWord(word: String) {
        guard let rangeToReplace = self.rangeOfWordAtCurrentCursorLocation() else { return }
        var newText = (self.text as NSString).replacingCharacters(in: rangeToReplace, with: word)
        let rangeOfWord = newText.rangeOfWordAtLocation(location: rangeToReplace.location + 1)
        var newRange = NSRange(location: rangeOfWord.location + rangeOfWord.length, length: 0)
        
        if newRange.location == newText.utf16.count {
            newText = newText + " "
            newRange.location += 1
        }
        
        text = newText
        selectedRange = newRange
        delegate?.textViewDidChangeSelection?(self)
    }
}

extension String {
    
    public func wordAtLocation(location: Int) -> String {
        let range = self.rangeOfWordAtLocation(location: location)
        return (self as NSString).substring(with: range)
    }
    
    public func rangeOfWordAtLocation(location: Int) -> NSRange {
        let string = self as NSString
        
        let selfLength = string.length
        
        if location > selfLength {
            return NSRange(location: NSNotFound, length: NSNotFound)
        }
        
        let beforeRange = NSRange(location: 0, length: location)
        let afterRange = NSRange(location: location, length: selfLength - location)
        
        let whiteSpaceSet = NSCharacterSet.whitespacesAndNewlines
        
        var beforeWhiteSpaceLocation = string.rangeOfCharacter(from: whiteSpaceSet, options: .backwards, range: beforeRange).location
        
        beforeWhiteSpaceLocation = beforeWhiteSpaceLocation != NSNotFound ? beforeWhiteSpaceLocation + 1 : 0
        
        var afterWhiteSpaceLocation = string.rangeOfCharacter(from: whiteSpaceSet, options: [], range: afterRange).location
        
        afterWhiteSpaceLocation = (afterWhiteSpaceLocation != NSNotFound) ? afterWhiteSpaceLocation : selfLength
        
        return NSRange(location: beforeWhiteSpaceLocation, length: afterWhiteSpaceLocation - beforeWhiteSpaceLocation)
    }
}
