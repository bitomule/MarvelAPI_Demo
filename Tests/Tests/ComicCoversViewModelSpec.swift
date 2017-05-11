@testable import WallapopMarvel
import Quick
import Nimble

import ReactiveSwift
import Result

private class FakeDataSource:ComicCoversDataSource{
  
  var fakeResponse:(([String],Int?,Int?)->SignalProducer<[Comic],NoError>)?
  
  func getComics(characters:[String],limit:Int?,offset:Int?)->SignalProducer<[Comic],NoError>{
    return fakeResponse?(characters, limit, offset) ?? SignalProducer.empty
  }
}

final class ComicCoversViewModelSpec: QuickSpec {
  override func spec() {
    let dataSource = FakeDataSource()
    var viewModel:ComicCoversViewModel!
    beforeEach {
      dataSource.fakeResponse = nil
    }
    describe("outputs") {
      it("is returns item count equal to dataSource comics count") {
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        
        expect(viewModel.outputs.itemsCount.value).to(equal(2))
      }
      
      it("returns the item at the right index"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        expect(viewModel.outputs.itemAt(index:1).id).to(equal(1))
      }
      
      it("calls elements added when new elements fetched from api"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        var called = false
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        viewModel.outputs.itemsAdded.observeValues({ _ in
          called = true
        })
        viewModel.inputs.loadMore()
        expect(called).to(beTrue())
      }
      
      it("calls reload when local comics resetted"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        var called = false
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        viewModel.outputs.itemsReloaded.observeValues({ _ in
          called = true
        })
        viewModel.inputs.filterByCharacters(["1"])
        expect(called).to(beTrue())
      }
    }
    
    describe("inputs") {
      it("doesn't request more data if limit reached"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:5,dataSource:dataSource)
        var requestPerformed = false
        dataSource.fakeResponse = { _, _, _ in
          requestPerformed = true
          return SignalProducer(value: [])
        }
        viewModel.inputs.loadMore()
        expect(requestPerformed).to(beFalse())
      }
      
      it("appends new paginated items to current items"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        viewModel.inputs.loadMore()
        expect(viewModel.outputs.itemsCount.value).to(equal(2))
      }
      
      it("resets comics to empty when filtered"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:5,dataSource:dataSource)
        viewModel.inputs.filterByCharacters(["1"])
        expect(viewModel.outputs.itemsCount.value).toEventually(equal(0))
      }
      
      it("request more items from data source when loadMore called"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: []),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        var offsetRequested = 0
        dataSource.fakeResponse = { _, _, offset in
          offsetRequested = offset ?? 0
          return SignalProducer(value: [
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, images: [])
            ]
          )
        }
        viewModel.inputs.loadMore()
        expect(offsetRequested).to(equal(1))
      }
    }
  }
}
