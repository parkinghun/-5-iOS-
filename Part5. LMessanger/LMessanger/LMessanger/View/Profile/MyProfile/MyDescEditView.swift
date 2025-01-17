//
//  MyDescEditView.swift
//  LMessanger
//
//  Created by 박성훈 on 1/6/25.
//

import SwiftUI

struct MyDescEditView: View {
  @Environment(\.dismiss) var dismiss
  @State var description: String
  
  var onCompleted: (String) -> Void
  
  var body: some View {
    NavigationStack {
      VStack {
        TextField("상태메시지를 입력해주세요", text: $description)
          .multilineTextAlignment(.center)
      }
      .toolbar {
        Button("완료") {
          dismiss()
          onCompleted(description)
        }
        .disabled(description.isEmpty)
      }
    }
  }
}

#Preview {
  MyDescEditView(description: "") { _ in
  }
}
