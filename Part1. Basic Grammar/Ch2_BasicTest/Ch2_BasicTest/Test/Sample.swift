//
//  Sample.swift
//  Ch2_BasicTest
//
//  Created by 박성훈 on 7/4/24.
//

import SwiftUI

struct Sample: View {
    let data = [
        Destination(
            direction: .north,
            food: "파스타 맛집",
            image: Image(systemName: "carrot")
        ),
        Destination(
            direction: .east,
            image: Image(systemName: "sunrise")
        ),
        Destination(
            direction: .west,
            image: Image(systemName: "balloon")
        ),
        Destination(
            direction: .south,
            food: "순대 맛집",
            image: Image(systemName: "cursor.rays")
        )
    ]
    
    @State private var selectedDestination: Destination?
    
    var body: some View {
        VStack {
            selectedDestination?.image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            VStack {
                if let destination = selectedDestination {
                    Text(destination.direction.rawValue)
                    if let food = destination.food {
                        Text(food)
                    }
                }
            }
            .font(.largeTitle)
            
            Button {
                self.selectedDestination = data.randomElement()
            } label: {
                Text("돌려요")
            }
            
        }
    }
    
}

struct Destination {
    let direction: Direction
    let food: String?
    let image: Image
    
    init(direction: Direction, food: String? = nil, image: Image) {
        self.direction = direction
        self.food = food
        self.image = image
    }
}

enum Direction: String {
    case north = "북"
    case west = "서"
    case east = "동"
    case south = "남"
}


#Preview {
    Sample()
}
