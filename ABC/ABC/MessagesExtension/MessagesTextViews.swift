//
//  MessagesTextViews.swift
//  ABC
//
//  Created by Cedric Bahirwe on 11/18/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import Foundation
import UIKit

extension MessagesViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.numberOfLines() > 1 {
            if textView.numberOfLines() < 5 {
            UIView.animate(withDuration: 0.26) {
                self.textViewContainerheight.constant = CGFloat(40 * textView.numberOfLines())
            }
            }
        } else {
            UIView.animate(withDuration: 0.26) {
                self.textViewContainerheight.constant = 50.0
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Hello")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    /*
     func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
     return
     }
     
     func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
     
     }
     */
    
}


extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
