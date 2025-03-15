//
//  LoadingView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 26/02/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var degree: Int = 270
    @State private var spinnerLength = 0.6
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .trim(from: 0.0,to: spinnerLength)
                .stroke(LinearGradient(colors: [.red,.blue], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 8.0,lineCap: .round,lineJoin:.round))
                .frame(width: 60,height: 60)
                .rotationEffect(Angle(degrees: Double(degree)))
                .onAppear{
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        self.degree = 270 + 360
                    }
                    
                    withAnimation(.easeIn(duration: 1.0).repeatForever(autoreverses: true)) {
                        self.spinnerLength = 0
                    }
                }
        }
    }
}

#Preview {
    LoadingView()
}
