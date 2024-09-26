//
//  MainViewModel.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/13/24.
//

import Foundation
import RxSwift

final class MainViewModel: ViewModelType {
  var disposeBag = DisposeBag()
  var tvNetwork: TVNetwork
  var movieNetowrk: MovieNetwork
  var currentContentType: ContentType = .tv
  private var currentTVList: [TV] = []  // 페이지네이션을 위함
  
  init() {
    let provider = NetworkProvider()
    self.tvNetwork = provider.makeTVNetowrk()
    self.movieNetowrk = provider.makeMovieNetowrk()
  }
  
  func transform(input: Input) -> Output {
    // 두 개의 Observable을 결합하여 가장 최근의 두 값을 사용함.
    let tvList: Observable<Result<[TV], Error>> = Observable.combineLatest(input.tvTrigger, input.searchTrigger)
      .flatMapLatest { [weak self] page, searchKeyword -> Observable<Result<[TV], Error>> in
        guard let self = self else { return .just(.success([])) }
        self.currentContentType = .tv
        if page == 1 { self.currentTVList = [] }
        
        return self.fetchTVList(page: page, query: searchKeyword)
      }
      .map { [weak self] result -> Result<[TV], Error> in
        guard let self = self else { return .success([]) }
        switch result {
        case .success(let tvList):
          self.currentTVList += tvList
          return .success(self.currentTVList)
        case .failure(let error):
          return .failure(error)
        }
      }
    
    let movieResults = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<Result<MovieResults, Error>> in
      currentContentType = .movie
      return Observable.combineLatest(
        self.movieNetowrk.getNowPlayingList(),
        self.movieNetowrk.getPopularList(),
        self.movieNetowrk.getUpcomingList()
      ) { nowPlaying, popular, upcoming -> Result<MovieResults, Error> in
        return .success(MovieResults(nowPlaying: nowPlaying, popular: popular, upcoming: upcoming))
      }.catch { error in
        print(#fileID, #function, #line, "- Movie Result Fetch Error:")
        print(error)
        return Observable.just(.failure(error))
      }
    }
    
    return Output(tvList: tvList, movieResults: movieResults)
  }
  
  private func fetchTVList(page: Int, query: String) -> Observable<Result<[TV], Error>> {
    if query.isEmpty {
      return self.tvNetwork.getTopRatedList(page: page)
        .map { .success($0.results) }
        .catch { Observable.just(.failure($0)) }
    } else {
      return self.tvNetwork.getQuriedList(page: page, query: query)
        .map {
          print("✅ results: \($0)")
          return .success($0.results)
        }
        .catch { .just(.failure($0)) }
    }
  }
  
}

extension MainViewModel {
  struct Input {
    var tvTrigger: Observable<Int>
    var movieTrigger: Observable<Void>
    var searchTrigger: Observable<String>
  }
  
  struct Output {
    var tvList: Observable<Result<[TV], Error>>
    var movieResults: Observable<Result<MovieResults, Error>>
  }
}
