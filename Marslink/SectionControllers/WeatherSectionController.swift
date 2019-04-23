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

class WeatherSectionController: ListSectionController {
//  This section controller will receive a Weather object in didUpdate(to:)
    var weather: Weather!
//  expanded is a Bool used to track whether the astronaut has expanded the weather section. I initialize it to false so the detail cells are initially collapsed.
    var expanded = false
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: - Data Provider
extension WeatherSectionController {
//    In didUpdate(to:), I save the passed Weather object
    override func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
//    If I'm displaying the expanded weather, numberOfItems() returns five cells that will contain different pieces of weather data. If not expanded, I need only a single cell to display a placeholder.
    override func numberOfItems() -> Int {
        return expanded ? 5 : 1
    }
    
    
//    The first cell should be a little larger than the others, as it displays a header. I don’t have to check the state of expanded because that header cell is the first cell in either case.
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero}
        let width = context.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
}

