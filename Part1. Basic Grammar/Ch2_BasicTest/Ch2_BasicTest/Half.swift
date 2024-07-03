//
//  Half.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/3/24.
//

import SwiftUI

struct Half: View {
    
    let names: [String] = ["레오", "존", "바이", "테리우스", "올리비아"]
    
    var body: some View {
        List {
            ForEach(names, id: \.self) { name in
                var welcome = sayHi(to: name)
                if name == "레오" {
                    Text("기다렸어요. \(welcome)")
                } else {
                    Text(welcome)
                }
            }
        }
    }
    
    private func sayHi(to name: String) -> String {
        return "\(name)님 반갑습니다."
    }
}

#Preview {
    Half()
}
