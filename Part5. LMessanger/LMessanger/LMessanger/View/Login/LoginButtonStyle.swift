//
//  LoginButtonStyle.swift
//  LMessanger
//
//  Created by 박성훈 on 11/29/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
  
  let textColor: Color
  let borderColor: Color
  
  init(textColor: Color, borderColor: Color? = nil) {
    self.textColor = textColor
    self.borderColor = borderColor ?? textColor
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 14))
      .foregroundStyle(textColor)
      .frame(maxWidth: .infinity, maxHeight: 40)
      .overlay {
        RoundedRectangle(cornerRadius: 5)
          .stroke(borderColor, lineWidth: 0.8)
      }
      .padding(.horizontal, 15)
      .opacity(configuration.isPressed ? 0.5 : 1)
  }
}
