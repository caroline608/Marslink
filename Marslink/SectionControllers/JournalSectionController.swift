/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import IGListKit

class JournalSectionController: ListSectionController {
//  model class that I'll use when implementing the data source
    var entry: JournalEntry!
//  SolFormatter class provides methods for converting dates to Sol format
    let solFormatter = SolFormatter()
    
    
//  Without this, the cells between sections will butt up next to each other. This adds 15 point padding to the bottom of JournalSectionController objects.
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }

}

// MARK: - Data Provider
extension JournalSectionController {
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
//  The collectionContext is a weak variable and must be nullable. Though it should never be nil, it’s best to take precautions and Swift guard makes that simple.
        guard
            let context = collectionContext,
            let entry = entry
            else {
        return .zero
        }
//   ListCollectionContext is a context object with information about the adapter, collection view and view controller that’s using the section controller. Here I get the width of the container.
        let width = context.containerSize.width
//   If the first index (a date cell), return a size as wide as the container and 30 points tall. Otherwise, use the cell helper method to calculate the dynamic text size of the cell.
        if index == 0 {
            return CGSize(width: width, height: 30)
        } else {
            return JournalEntryCell.cellSize(width: width, text: entry.text)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
//  If the index is the first, use a JournalEntryDateCell cell, otherwise use a JournalEntryCell cell. Journal entries always appear with a date followed by the text.
        let cellClass: AnyClass = index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self
//   Dequeue the cell from the reuse pool using the cell class, a section controller (self) and the index.
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
//      Depending on the cell type, configure it using the JournalEntry you set earlier in didUpdate(to object:)
        if let cell = cell as? JournalEntryDateCell {
            cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
        } else if let cell = cell as? JournalEntryCell {
            cell.label.text = entry.text
        }
        return cell
    }
    
//  IGListKit calls didUpdate(to:) to hand an object to the section controller. Note this method is always called before any of the cell protocol methods. Here, I saved the passed object in entry.
    override func didUpdate(to object: Any) {
        entry = object as? JournalEntry
    }
}
