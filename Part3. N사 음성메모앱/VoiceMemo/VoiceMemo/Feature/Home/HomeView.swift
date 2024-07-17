//
//  HomeView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            MainTabView(homeViewModel: homeViewModel)
                .environmentObject(homeViewModel)  // homeVM을 주입해줘야 함.

            SeperatorLineView()
        }
    }
}

// MARK: - 탭 뷰
private struct MainTabView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    
    fileprivate init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        TabView(selection: $homeViewModel.selectedTab) {
            TodoListView()
                .tabItem {
                    Image(
                        homeViewModel.selectedTab == .todoList
                        ? "todoIcon_selected"
                        : "todoIcon"
                    )
                }.tag(Tab.todoList)
            
            MemoListView()
                .tabItem {
                    Image(
                        homeViewModel.selectedTab == .memo
                        ? "memoIcon_selected"
                        : "memoIcon"
                    )
                }.tag(Tab.memo)
            
            VoiceRecorderView()
                .tabItem {
                    Image(
                        homeViewModel.selectedTab == .voiceRecoder
                        ? "recordIcon_selected"
                        : "recordIcon"
                    )
                }.tag(Tab.voiceRecoder)
            
            TimerView()
                .tabItem {
                    Image(
                        homeViewModel.selectedTab == .timer
                        ? "timerIcon_selected"
                        : "timerIcon"
                    )
                }.tag(Tab.timer)
            
            SettingView()
                .tabItem {
                    Image(
                        homeViewModel.selectedTab == .setting
                        ? "settingIcon_selected"
                        : "settingIcon"
                    )
                }.tag(Tab.setting)

        }
    }
}

// MARK: - 구분선
private struct SeperatorLineView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    // 탑 흰 ~ 아래 그레이
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .gray.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 10)
                .padding(.bottom, 60)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
        .environmentObject(MemoListViewModel())
}
