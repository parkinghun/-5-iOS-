//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            // TODO: 화면 전환 구현 필요
            OnboardingContentView(onboardingViewModel: onboardingViewModel)
                .navigationDestination(for: PathType.self) { pathType in
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                            .environmentObject(memoListViewModel)
                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                    case let .memoView(isCreateMode, memo):
                        MemoView(
                            memoViewModel: isCreateMode
                            ? .init(memo: .init(title: "", content: "", date: .now))
                            : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                            isCreateMode: isCreateMode
                        )
                        .navigationBarBackButtonHidden()
                        .environmentObject(memoListViewModel)
                    }
                }
        }
        .environmentObject(pathModel)
    }
}


// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            // 시작 버튼 뷰
            StartBtnView(onboardingViewModel: onboardingViewModel)
        }
        .ignoresSafeArea()
    }
}


// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        TabView(selection: $onboardingViewModel.onBoardingIndex) {
            ForEach(Array(onboardingViewModel.onBoardingContnts.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(
                    onboardingViewModel: onboardingViewModel,
                    onboardingContent: onboardingContent
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.height / 1.5)
        .background(
            onboardingViewModel.onBoardingIndex % 2 == 0 ? Color.ctmSky : Color.ctmBackgroundGreen
        )
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    private var onboardingContent: OnboardingContent
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        onboardingContent: OnboardingContent) {
            self.onboardingViewModel = onboardingViewModel
            self.onboardingContent = onboardingContent
        }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            VStack {
                Spacer()
                    .frame(height: 10)
                
                CustomPageControl(
                    currentPage: $onboardingViewModel.onBoardingIndex,
                    numberOfPages: onboardingViewModel.onBoardingContnts.count
                )
                
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text(onboardingContent.title)
                            .font(.system(size: 16, weight: .bold))
                        
                        Spacer()
                            .frame(height: 5)
                        
                        Text(onboardingContent.subTitle)
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                }
            }
            .background(Color.ctmWhite)
            .clipShape(RoundedRectangle(cornerRadius: 0))
        }
        .shadow(radius: 10)
    }
}

// MARK: - 커스텀 페이지 컨트롤
private struct CustomPageControl: UIViewRepresentable {
    @Binding var currentPage: Int
    var numberOfPages: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .gray
        return control
    }
    
    func updateUIView(_ control: UIPageControl, context: Context) {
        control.currentPage = currentPage
    }
}


// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject var onboardingViewModel: OnboardingViewModel
    
    fileprivate var body: some View {
        Button {
            onboardingViewModel.nextBtnTapped {
                pathModel.paths.append(.homeView)
            }
        } label: {
            HStack {
                Text(onboardingViewModel.isLastOnBoardingItem ? "시작하기" : "다음으로")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.customGreen)
                
                Image("startHome")
                    .renderingMode(.template)
                    .foregroundStyle(.customGreen)
            }
        }
        .padding(.bottom, 50)
        
    }
}

#Preview {
    OnboardingView()
}
