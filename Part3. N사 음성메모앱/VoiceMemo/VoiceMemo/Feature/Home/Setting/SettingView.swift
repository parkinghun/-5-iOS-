//
//  SettingView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            TotalTabCountView()
            
            Spacer()
                .frame(height: 40)
            
            TotalTabMoveView()
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.ctmBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - 전체 탭 설정된 카운트 뷰
private struct TotalTabCountView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    fileprivate var body: some View {
        // 각각 탭 카운트 뷰(totalList, 메모장, 음성메모)
        HStack {
            // to-do/메모/음성메모의 갯수를 homeVM에 어떻게 주입시킬 것인가?
            TabCountView(title: "To do", count: homeViewModel.todosCounot)
            
            Spacer()
                .frame(width: 70)
            
            TabCountView(title: "메모", count: homeViewModel.memosCount)
            
            Spacer()
                .frame(width: 70)

            TabCountView(title: "음성메모", count: homeViewModel.voiceRecoderCount)
        }
    }
}


// MARK: - 각 탭 설정된 카운트 뷰(공통 뷰 컴포넌트)
fileprivate struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(
        title: String,
        count: Int
    ) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(Color.ctmBlack)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.ctmBlack)
        }
    }
}


// MARK: - 총 탭 이동 뷰
private struct TotalTabMoveView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    fileprivate var body: some View {
        VStack {
            
            Rectangle()
                .fill(Color.ctmGray1)
                .frame(height: 1)
            
            // 각 탭 4개 이동 컴포넌트 호출
            TabMoveView(title: "To do List") {
                    homeViewModel.changeSelectedTab(.todoList)
                }
            
            TabMoveView(title: "메모") {
                    homeViewModel.changeSelectedTab(.memo)
                }
            
            TabMoveView(title: "음성메모") {
                    homeViewModel.changeSelectedTab(.voiceRecoder)
                }
            
            TabMoveView(title: "타이머") {
                    homeViewModel.changeSelectedTab(.timer)
                }
            
            
            Rectangle()
                .fill(Color.ctmGray1)
                .frame(height: 1)
        }
    }
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(
        title: String,
        tabAction: @escaping () -> Void
    ) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button {
            tabAction()
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.ctmBlack)
                
                Spacer()
                
                Image("arrowRight")
            }
        }
        .padding(20)
    }
}


#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
}
