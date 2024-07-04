//
//  Exception.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/4/24.
//

import SwiftUI

struct Exception: View {
    
    @State private var inputNumber = ""
    @State private var resultNumber: Float = 0.0
    
    var body: some View {
        VStack {
            TextField("나눌 숫자를 입력해주세요", text: $inputNumber)
            Text("나눈 결과는 다음과 같아요 \(resultNumber)")
            Button {
                
                do {
                    resultNumber = try devideTen(with: (Float(inputNumber) ?? 1.0))
                } catch DivideError.dividedByZero {
                    print("0으로 나누었대요")
                    resultNumber = -1
                    // 얼럿 같은 것들을 사용해 사용자에게 메시지를 줄 수 있음
                } catch {
                    print(error.localizedDescription)
                }
                
            } label: {
                Text("나누기")
            }
        }
    }
    
    // throws: 문제가 생길 수 있음을 나티냄
    // 에러를 던짐으로써 사용자도 명시적으로 알 수 있게 되고,
    // 개발자도 코드에 대한 신뢰도를 높일 수있게 됨
    func devideTen(with inputNumber: Float) throws -> Float {
        var result: Float = 0
        if inputNumber == 0 {
            // 에러가 발생할 수 있는 부분을 탐지함.
            // 물론 에러를 안던지고, if문을 통해 0이 아닐 때만 나눌 수 있음
            // 그러나, 사용자가 0을 입력하는 것을 막을 수 없기 때문에 0을 입력했을 때 에러를 명시적으로 던지기 위해 사용
            throw DivideError.dividedByZero
        } else {
            result = 10 / inputNumber
        }
        return result
        
    }
}

// 정의한 에러
enum DivideError: Error {
    case dividedByZero
}

#Preview {
    Exception()
}
