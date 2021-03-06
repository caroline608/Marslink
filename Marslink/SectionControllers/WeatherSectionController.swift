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
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? WeatherSummaryCell {
            cell.setExpanded(expanded)
        } else if let cell = cell as? WeatherDetailCell {
            let title: String
            let detail: String
//     Configured four different weather detail cells, they will be populate depending on index.
            switch index {
            case 1:
                title = "SUNRISE"
                detail = weather.sunrise
            case 2:
                title = "SUNSET"
                detail = weather.sunset
            case 3:
                title = "HIGH"
                detail = String(weather.high)
            case 4:
                title = "LOW"
                detail = String(weather.low)
            default:
                title = "n/a"
                detail = "n/a"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
        }
        return cell
    }
    
//    The last thing I need to do is toggle the section expanded and update the cells when tapped.
    override func didSelectItem(at index: Int) {
//performBatch(animated:updates:completion:) batches and performs updates in the section in a single transaction. I can use this whenever the contents or number of cells changes in the section controller. Since I toggle the expansion with numberOfItems(), this will add or remove cells based on the expanded flag.
        collectionContext?.performBatch(animated: true, updates: { ListBatchContext in
            self.expanded.toggle()
            ListBatchContext.reload(self)
        }, completion: nil)
    }
}

