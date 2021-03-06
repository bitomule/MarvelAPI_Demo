@testable import WallapopMarvel
import Quick
import Nimble

import ReactiveSwift
import Result

private class FakeDataSource:ComicCoversDataSource{
  
  var fakeResponse:((Int?,Int?,Int?)->SignalProducer<[Comic],DataSourceError>)?
  
  func getComics(character:Int?,limit:Int?,offset:Int?)->SignalProducer<[Comic],DataSourceError>{
    return fakeResponse?(character, limit, offset) ?? SignalProducer.empty
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
      it("is has as many commics as data source") {
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
            ]
          )
        }
        
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        
        expect(viewModel.comics.value.count).to(equal(2))
      }
      
      it("is returns item count equal to comics councs") {
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        viewModel.comics.value = [
          Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
          Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
        ]
        expect(viewModel.outputs.itemsCount.value).to(equal(2))
      }
      
      it("returns the item at the right index"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        expect(viewModel.outputs.itemAt(index:1).id).to(equal(1))
      }
      
      it("calls elements added when new elements fetched from api"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
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
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
            ]
          )
        }
        var called = false
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        viewModel.outputs.itemsReloaded.observeValues({ _ in
          called = true
        })
        viewModel.inputs.filterByCharacter(1)
        expect(called).to(beTrue())
      }
      
      it("should not send negative added items"){
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        viewModel.comics.value = [
          Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
          Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
        ]
        var itemsAdded = 0
        viewModel.outputs.itemsAdded.observeValues({ added in
          itemsAdded = added
        })
        viewModel.comics.value = []
        expect(itemsAdded).to(beGreaterThanOrEqualTo(0))
      }
    }
    
    describe("inputs") {
      it("doesn't request more data if limit reached"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
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
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
            ]
          )
        }
        viewModel.inputs.loadMore()
        expect(viewModel.outputs.itemsCount.value).to(equal(2))
      }
      
      it("resets comics to empty when filtered"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:5,dataSource:dataSource)
        viewModel.inputs.filterByCharacter(1)
        expect(viewModel.outputs.itemsCount.value).toEventually(equal(0))
      }
      
      it("request more items from data source when loadMore called"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        var offsetRequested = 0
        dataSource.fakeResponse = { _, _, offset in
          offsetRequested = offset ?? 0
          return SignalProducer(value: [
            Comic(id: 1, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
            ]
          )
        }
        viewModel.inputs.loadMore()
        expect(offsetRequested).to(equal(1))
      }
      
      it("doesn't request more items if still loading"){
        dataSource.fakeResponse = { _, _, _ in
          return SignalProducer(value: [
            Comic(id: 0, title: "", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil),
            ]
          )
        }
        viewModel = ComicCoversViewModel(limit:1,dataSource:dataSource)
        dataSource.fakeResponse = { _, _, offset in
          return SignalProducer({_,_ in})
        }
        viewModel.inputs.loadMore()
        var newRequestPerformed = false
        dataSource.fakeResponse = { _, _, offset in
          newRequestPerformed = true
          return SignalProducer({_,_ in})
        }
        viewModel.inputs.loadMore()
        expect(newRequestPerformed).to(beFalse())
      }
    }
  }
}
