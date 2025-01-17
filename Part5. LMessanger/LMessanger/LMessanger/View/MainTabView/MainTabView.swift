//
//  MainTabView.swift
//  LMessanger
//
//  Created by 박성훈 on 11/29/24.
//

import SwiftUI

struct MainTabView: View {
  @EnvironmentObject var authViewModel: AuthenticationViewModel
  @EnvironmentObject var container: DIContainer
  @State private var selectedTab: MainTabType = .home
  
  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(MainTabType.allCases, id: \.self) { tab in
        Group {
          switch tab {
          case .home:
            // nil일 때를 대비해 더 안전하게 작업하려면 바깥에서 체크를 한 뒤 홈뷰에 들어가게 할 수 있지만, 앞단에서 로그인 체크를 진행했기 때문에 그냥 진행
            HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
          case .chat:
            ChatListView()
          case .phone:
            Color.blackFix
          }
        }
        .tabItem {  // deprecated
          Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
        }
        .tag(tab)
      }
    }
    .tint(Color.bkText)
  }
  
  init() {
    UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
  }
}

#Preview {
  let container = DIContainer(services: StubService())
  
  MainTabView()
    .environmentObject(container)
    .environmentObject(AuthenticationViewModel(container: container))
}
