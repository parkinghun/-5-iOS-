//
//  MyCar.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/4/24.
//

import SwiftUI

protocol Driveable {
    func speedDown(with speed: Int) -> Int
}

struct MyCar: View {
    @State private var speed: Int = 10
    
    var myCar: KIA = KIA()
    var broCar: Hyundai = Hyundai()
    let cars: [Driveable] = [KIA(), Hyundai()]
    // login 가능한 것들에도 사용 가능. 구글, 네이버 등.. -> loginable
    
    var body: some View {
        VStack {
            Text("speed: \(speed)")
            
            Button {
                speed = broCar.speedDown(with: speed)
                cars.first?.speedDown(with: speed)
                cars.randomElement()?.speedDown(with: speed)
            } label: {
                Text("감속!")
            }
        }
    }
}

struct Hyundai: Driveable {
    func speedDown(with speed: Int) -> Int {
        print("속도가 촤촤촤 줄어들어요")
        return speed - 9
    }
}

struct KIA: Driveable {
    func speedDown(with speed: Int) -> Int {
        print("속도가 0으로 줄어듭니다.")
        return speed - 5
    }
}



#Preview {
    MyCar()
}
