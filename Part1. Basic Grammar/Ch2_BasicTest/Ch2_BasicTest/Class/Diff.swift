//
//  Diff.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/3/24.
//

import SwiftUI

struct Diff: View {
    
    var myCar = Car(name: "리어카", owner: "레오")
    @StateObject private var myCaar = Caar(name: "리어카2", owner: "레오2")
    
    var body: some View {
        VStack {
            Text("\(myCar.name)의 주인은 \(myCar.owner)입니다.")
            
            Button {
                myCar.sayHi()
            } label: {
                Text("출발~")
            }
            .padding(.bottom)

            
            Text("\(myCaar.name)의 주인은 \(myCaar.owner)입니다.")
            Button {
                // 동생한테 차를 줌
                var broCar = myCaar
                broCar.name = "동생차"
                broCar.owner = "동생"
                
                // ObservableObject를 사용하지 않았을 때는,
                // print 할 때는 내용이 바뀌었지만, 뷰에서는 그대로 나옴 
                // View는 구조체이기 때문에 내용이 바뀌면 화면을 다시 그리게 해야함. 그런데 구조체가 다시 실행하면, 처음에 변수를 생성하던 것으로 그려짐 -> Observable 사용!
                
                myCaar.sayHi()  // print: hi 동생
            } label: {
                Text("출발~")
            }
            .padding(.bottom)
            
            
        }
    }
}

struct Car {
    var name: String
    var owner: String
    
    func sayHi() {
        print("hi \(owner)")
    }
}

final class Caar: ObservableObject {
    @Published var name: String
    @Published var owner: String
    
    init(name: String, owner: String) {
        self.name = name
        self.owner = owner
    }
    
    func sayHi() {
        print("hi \(owner)")
    }
}

#Preview {
    Diff()
}
