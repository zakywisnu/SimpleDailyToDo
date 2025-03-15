//
//  CircularProgressBar.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 20/02/25.
//

import SwiftUI

struct CircularProgressBar: View {
    
    private var linewidth: CGFloat
    let progress: Double
    
    init(linewidth: CGFloat = 30, progress: Double = 0.5) {
        self.linewidth = linewidth
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.progressPink,
                    style: StrokeStyle(lineWidth: linewidth, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.progressBlue,
                    style: .init(lineWidth: linewidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
    
}

#Preview {
    CircularProgressBar()
}
