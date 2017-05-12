@testable import WallapopMarvel
import Quick
import Nimble

import ReactiveSwift
import Result

private class FakeDataSource:ComicDetailDataSource{
  
  var fakeResponse:((Int)->SignalProducer<Comic,DataSourceError>)?
  
  func getComic(id:Int)->SignalProducer<Comic,DataSourceError>{
    return fakeResponse?(id) ?? SignalProducer.empty
  }
}

final class ComicDetailViewModelSpec: QuickSpec {
  override func spec() {
    let dataSource = FakeDataSource()
    var viewModel:ComicDetailViewModel!
    beforeEach {
      dataSource.fakeResponse = nil
    }
    
    describe("outputs") {
      it("sets name from dataSource") {
        dataSource.fakeResponse = { _ in
          return SignalProducer(value:
            Comic(id: 0, title: "TEST", issueNumber: 1, description: "", pageCount: 1, thumbnail: nil, cover: nil)
          )
        }
        viewModel = ComicDetailViewModel(comicId: 1, dataSource: dataSource)
        expect(viewModel.outputs.title.value).to(equal("TEST"))
      }
    }
  }
}
