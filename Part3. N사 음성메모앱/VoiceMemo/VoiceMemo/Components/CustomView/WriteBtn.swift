//
//  WriteBtn.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

// MARK: - 1️⃣ ViewModifier와 modifier를 사용
// 추후에 언제 어디서든 컴포넌트가 분리되고 모듈간의 분리가 됐을 때 public 호출할 수 있게끔 호출
// 디자인 시스템의 경우 별도의 모듈로 빼기 때문에 public을 권장
public struct WriteBtnViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}


// MARK: - 2️⃣ View 확장하여 메서드를 만들고 호출
extension View {
    public func writeBtn(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
        
    }
}


// MARK: - 3️⃣ 새로운 View를 생성
public struct WriteBtnView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
