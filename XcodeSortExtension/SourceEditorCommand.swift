//
//  SourceEditorCommand.swift
//  XcodeSortExtension
//
//  Created by Joseph Lin on 11/2/16.
//  Copyright © 2016 Joseph Lin. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        if let textRange = invocation.buffer.selections.firstObject as? XCSourceTextRange {
            let endline = (textRange.end.column == 0) ? textRange.end.line - 1 : textRange.end.line
            let diff = endline - textRange.start.line
            if diff > 0 {
                let range = NSRange(location: textRange.start.line, length: diff + 1)
                let lines = invocation.buffer.lines
                if let selectedLines = lines.subarray(with: range) as? [String] {
                    let sortedSelectedLines = selectedLines.sorted(by: { (a, b) -> Bool in
                        return a.compare(b, options: [.numeric]) == .orderedAscending
                    })
                    lines.replaceObjects(in: range, withObjectsFrom: sortedSelectedLines)
                }
            }
        }
        completionHandler(nil)
    }
}
