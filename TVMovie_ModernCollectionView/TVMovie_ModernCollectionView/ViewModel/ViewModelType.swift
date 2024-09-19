//
//  ViewModelType.swift
//  TVMovie_ModernCollectionView
//
//  Created by 박성훈 on 9/15/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  var disposeBag: DisposeBag { get set }
  
  func transform(input: Input) -> Output
}
