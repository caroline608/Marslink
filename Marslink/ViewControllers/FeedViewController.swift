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

class FeedViewController: UIViewController {

    let loader = JournalEntryLoader()
    let wxScanner = WxScanner() //Model object for weather conditions
    let collectionView: UICollectionView = {
//        start with a zero-sized rect since view isnt created yet
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .black
        return view
    }()
//    PathFinder() acts as a messaging system, and represents the physical Pathfinder rover the astronaut dug up on Mars
    let pathfinder = Pathfinder()
    
//  create an initialized variable for the ListAdapter, ListAdapter controls the collection view
    lazy var adapter: ListAdapter = {
        return ListAdapter(
//          handles row and section updates
            updater: ListAdapterUpdater(),
            viewController: self,
//          allows you to prepare content for sections just outside of the visible frame
            workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadLatest()
        view.addSubview(collectionView)
//        connects the collectonView to the adapter
        adapter.collectionView = collectionView
//        sets self as the dataSource
        adapter.dataSource = self
        pathfinder.delegate = self
        pathfinder.connect()
    }
    
//    this overrides viewDidLayoutSubviews(), setting the collectionView frame to match the view bounds.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    
}

// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource{
    //  returns an array of data objects that should show up in the collection view. i've provided loader.entries here as it contains the journal entries.
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//Adds the currentWeather to the items array
        var items:[ListDiffable] = [wxScanner.currentWeather]
        items += loader.entries as [ListDiffable]
        items += pathfinder.messages as [ListDiffable]
//        All the data conforms to the DataSortable protocol, so this sorts the data using that protocol. This ensures data appears chronologically.
        return items.sorted { (left: Any, right: Any) -> Bool in
            guard
                let left = left as? DateSortable,
                let right = right as? DateSortable
                else {
                    return false
            }
            return left.date > right.date
        }
    }
    
//  For each data object, listAdapter(_:sectionControllerFor:) must return a new instance of a section controller. For now you’re returning a plain ListSectionController to appease the compiler. In a moment, you’ll modify this to return a custom journal section controller.
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        if object is Message {
            return MessageSectionController()
        } else if object is Weather {
            return WeatherSectionController()
        }else {
            return JournalSectionController()
        }
    }
    
//  returns a view to display when the list is empty
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - PathfinderDelegate
extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true)
    }
}
