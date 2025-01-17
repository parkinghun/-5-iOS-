//
//  HomeView.swift
//  LMessanger
//
//  Created by 박성훈 on 12/3/24.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var container: DIContainer
  @StateObject var viewModel: HomeViewModel
  
  var body: some View {
    NavigationStack {
      content
        .fullScreenCover(item: $viewModel.modalDestination) {
          switch $0 {
          case .myProfile:
            MyProfileView(viewModel: .init(container: container, userId: viewModel.userId))
          case let .otherProfile(userId):
            OtherProfileView(viewModel: .init(container: container, userId: userId)) { otherUserInfo in
              // TODO: -
            }
          }
        }
    }
  }
  
  @ViewBuilder  // 뭐였지
  var content: some View {
    switch viewModel.phase {
    case .notRequested:
      PlaceholderView()
        .onAppear {
          viewModel.send(action: .load)
        }
    case .loading:
      LoadingView()
    case .success:
      loadedView
        .toolbar {
          Image("bookmark")
          Image("notifications")
          Image("person_add")
          Button {
            // TODO: -
          } label: {
            Image("settings")
          }
        }
    case .fail:
      ErrorView()  // 추후에 에러타입을 받아서 보완할 수 있을 것 같음
    }
  }
  
  var loadedView: some View {
    ScrollView {
      profileView
        .padding(.bottom, 30)
      
      searchButton
        .padding(.bottom, 24)

      HStack {
        Text("친구")
          .font(.system(size: 14))
          .foregroundStyle(Color.bkText)
        Spacer()
      }
      .padding(.horizontal, 30)
      
      if viewModel.users.isEmpty {
        Spacer(minLength: 89)
        emptyView
      } else {  // 친구목록 - 무한정 늘어날 수 있기 때문에 LazyVStack으로 구현
        LazyVStack {
          ForEach(viewModel.users, id: \.id) { user in
            Button {
              viewModel.send(action: .presentOtherProfileView(user.id))
            } label: {
              HStack(spacing: 8) {
                Image("person")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .clipShape(Circle())
                Text(user.name)
                  .font(.system(size: 12))
                  .foregroundStyle(Color.bkText)
                Spacer()
              }
              .padding(.horizontal, 30)
            }
          }
        }
      }
    }
  }
  
  var profileView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 7) {
        Text(viewModel.myUser?.name ?? "이름")
          .font(.system(size: 22, weight: .bold))
          .foregroundStyle(Color.bkText)
        Text(viewModel.myUser?.description ?? "상태 메시지 입력")
          .font(.system(size: 12))
          .foregroundStyle(Color.greyDeep)
      }
      
      Spacer()
      
      Image("person")
        .resizable()
        .frame(width: 52, height: 52)
        .clipShape(Circle())
    }
    .padding(.horizontal, 30)
    .onTapGesture {
      // 여기서 직접적인 값의 변경을 지양하기 때문에 액션을 만들어 추가해줌
      viewModel.send(action: .presentMyProfileView)
    }
  }
  
  var searchButton: some View {
    ZStack {
      Rectangle()
        .foregroundStyle(Color.clear)
        .frame(height: 36)
        .background(Color.greyCool)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      
      HStack {
        Text("검색")
          .font(.system(size: 12))
          .foregroundStyle(Color.greyLightVer2)
        
        Spacer()
      }
      .padding(.leading, 22)
    }
    .padding(.horizontal, 30)
  }
  
  var emptyView: some View {
    VStack {
      VStack(spacing: 3) {
        Text("친구를 추가해보세요.")
          .foregroundStyle(Color.bkText)
        Text("큐알코드나 검색을 이용해서 친구를 추가해보세요.")
          .foregroundStyle(Color.greyDeep)
      }
      .font(.system(size: 14))
      .padding(.bottom, 30)
      
      Button {
        viewModel.send(action: .reqeustContacts)
      } label: {
        Text("친구추가")
          .font(.system(size: 12))
          .foregroundStyle(Color.bkText)
          .padding(.vertical, 9)
          .padding(.horizontal, 24)
      }
      .overlay {
        RoundedRectangle(cornerRadius: 5)
          .stroke(Color.greyLightVer2)
      }
    }
  }
}

#Preview {
  let container = DIContainer(services: StubService())
  
  HomeView(viewModel: .init(
    container: container,
    userId: "user1_id"
  ))
  .environmentObject(container)
}
