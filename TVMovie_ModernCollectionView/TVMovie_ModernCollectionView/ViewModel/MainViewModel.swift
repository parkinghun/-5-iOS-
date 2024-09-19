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
  
  init() {
    let provider = NetworkProvider()
    self.tvNetwork = provider.makeTVNetowrk()
    self.movieNetowrk = provider.makeMovieNetowrk()
  }
  
  func transform(input: Input) -> Output {
    let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<Result<[TV], Error>> in
      return self.tvNetwork.getTopRatedList(page: 1).map { tvListModel in
          return .success(tvListModel.results)
      }.catch { error in
        print(#fileID, #function, #line, "- TVList Fetch Error:")
        print(error)
        return Observable.just(.failure(error))
      }
    }
    
    let movieResults = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<Result<MovieResults, Error>> in
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
}

extension MainViewModel {
  struct Input {
    var tvTrigger: Observable<Int>
    var movieTrigger: Observable<Void>
  }
  
  struct Output {
    var tvList: Observable<Result<[TV], Error>>
    var movieResults: Observable<Result<MovieResults, Error>>
  }
}
