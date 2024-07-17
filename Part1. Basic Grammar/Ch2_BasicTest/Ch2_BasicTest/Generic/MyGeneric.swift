//
//  MyGeneric.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/4/24.
//

import SwiftUI

struct MyGeneric: View {
    @State private var input: String = ""
    @State private var myStack = MyStack<Int>()
    
    var body: some View {
        VStack {
            TextField("숫자를 입력해주세요", text: $input)
            
            Button {
                myStack.insertValue(input: Int(input) ?? 0)
            } label: {
                Text("저장")
            }
            
            Button {
                myStack.showData()
            } label: {
                Text("출력")
            }
        }
    }
}

// 제네릭 사용 -> 어떤 타입이던 상관없어~
struct MyStack<T> {
    var data: [T] = []
    
    mutating func insertValue(input: T) {
        data.append(input)
    }
    
    func showData() {
        data.forEach { item in
            print(item)
        }
    }
}

#Preview {
    MyGeneric()
}
