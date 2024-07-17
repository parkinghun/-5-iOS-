//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboadingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            // TODO: 화면 전환 구현 필요
            OnboardingContentView(onboadingViewModel: onboadingViewModel)
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
    @ObservedObject var onboadingViewModel: OnboardingViewModel
    
    fileprivate init(onboadingViewModel: OnboardingViewModel) {
        self.onboadingViewModel = onboadingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(viewModel: onboadingViewModel)
            
            Spacer()
            // 시작 버튼 뷰
            StartBtnView()
        }
        .ignoresSafeArea()
    }
}


// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(viewModel: OnboardingViewModel, selectedIndex: Int = 0) {
        self.viewModel = viewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(viewModel.onBoardingContnts.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))  // 스와이프해서 넘기기
        .frame(width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0 ? Color.ctmSky : Color.ctmBackgroundGreen
        )
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .background(Color.ctmWhite)
            .clipShape(RoundedRectangle(cornerRadius: 0))
        }
        .shadow(radius: 10)
    }
}


// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homeView)  // 배열에 path를 추가해줌
        } label: {
            HStack {
                Text("시작하기")
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
