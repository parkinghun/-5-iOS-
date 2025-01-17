//
//  MyProfileView.swift
//  LMessanger
//
//  Created by 박성훈 on 1/4/25.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: MyProfileViewModel
  
  var body: some View {
    NavigationStack {
      ZStack {
        Image("profile_bg")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .ignoresSafeArea(edges: .vertical)  // 기본적으로 이미지뷰는 safeArea를 포함하지 않음
        
        VStack(spacing: 0) {
          Spacer()
          
          profileView
            .padding(.bottom, 16)
          
          nameView
            .padding(.bottom, 26)
          
          descriptionView
          
          Spacer()
          
          menuView
            .padding(.bottom, 58)
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image("close")
          }
        }
      }
      .task {  // onAppear가 불리기 직전에 실행됨
        await viewModel.getUser()
      }
    }
  }
  
  var profileView: some View {
    PhotosPicker(selection: $viewModel.imageSelection,
                 matching: .images) {
      
      // 앱이 재시작되면 다시 네트워크 통신을하여 이미지를 가져오는 작업
      // NSCache와 비슷하게 동작하는 것으로 예상이됨
      // 직접 만든 이미지캐시를 이용해서 AsyncImage를 대체할 뷰를 사용
      URLImageView(urlString: viewModel.userInfo?.profileURL)
        .frame(width: 80, height: 80)
        .clipShape(.circle)
      
//      AsyncImage(url: URL(string: viewModel.userInfo?.profileURL ?? "")) { image in
//        image.resizable()
//      } placeholder: {
//        Image("person")
//      }
//      .frame(width: 80, height: 80)
//      .clipShape(.circle)
    }
  }
  
  var nameView: some View {
    Text(viewModel.userInfo?.name ?? "이름")
      .font(.system(size: 24, weight: .bold))
      .foregroundStyle(Color.bgWh)
  }
  
  var descriptionView: some View {
    Button {
      viewModel.isPresentedDescEditView.toggle()
    } label: {
      Text(viewModel.userInfo?.description ?? "상태메시지를 입력해주세요.")
        .font(.system(size: 14))
        .foregroundStyle(Color.bgWh)
    }
    .sheet(isPresented: $viewModel.isPresentedDescEditView) {
      MyDescEditView(description: viewModel.userInfo?.description ?? "") { willBeDesc in  // 완료됐을 때 상태메세지
        Task {
          await viewModel.updateDescription(willBeDesc)
        }
      }
    }
  }
  
  var menuView: some View {
    HStack(alignment: .top, spacing: 27) {
      ForEach(MyProfileMenuType.allCases, id: \.self) { menu in
        Button {
          // TODO: - 딱히 기능은 없음
          print("프로필 메뉴 눌림 - \(menu.description)")
        } label: {
          VStack(alignment: .center) {
            Image(menu.imageName)
              .resizable()
              .frame(width: 50, height: 50)
            
            Text(menu.description)
              .font(.system(size: 10))
              .foregroundStyle(Color.bgWh)
          }
        }
      }
    }
  }
}

#Preview {
  MyProfileView(viewModel: .init(
    container: DIContainer(services: StubService()),
    userId: User.stub1.id
  ))
}
