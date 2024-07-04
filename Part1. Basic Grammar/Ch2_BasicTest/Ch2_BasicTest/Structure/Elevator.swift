//
//  Elevator.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/3/24.
//

import SwiftUI

struct Elevator: View {
    
    @State var myElevator: ElevatorStruct = ElevatorStruct()
    
    var body: some View {
        VStack {
            Text("층수 : \(myElevator.level)")
            
            HStack {
                Button {
                    myElevator.goDown()
                } label: {
                    Text("아래로")
                }
                
                Button {
                    myElevator.goUp()
                } label: {
                    Text("위로")
                }


            }
        }
    }
}

struct ElevatorStruct {
    // 층 수를 표시해주는 디스플레이
    var level: Int = 1
    
    // 위로 올라갈 수 있어야 함.
    mutating func goUp() {
        self.level += 1
    }
    
    // 아래로 내려갈 수 있어야 함.
    mutating func goDown() {
        self.level -= 1
    }
}

#Preview {
    Elevator()
}
