//
//  LoadingButtonView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 26/02/25.
//

import SwiftUI

public struct LoadingButtonView<Content: View>: View {
    private var width: CGFloat = 44
    private var customPadding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    @Binding public var isLoading: Bool
    public let content: Content
    public let action: () -> Void
    
    public init(
        isLoading: Binding<Bool>,
        action: @escaping () -> Void,
        @ViewBuilder builder: () -> Content
    ) {
        self._isLoading = isLoading
        content = builder()
        self.action = action
    }
    
    public var body: some View {
        Button {
            if !isLoading {
                action()
            }
            isLoading = true
        } label: {
            VStack {
                if isLoading {
                    CircleLoadingBar()
                } else {
                    content
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.primaryColor)
                    .frame(width: isLoading ? 44 : width , height: 44)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: 44)
        .padding(customPadding)
        .disabled(isLoading)
        .animation(.easeInOut, value: isLoading)
    }
    
    public func setWidth(_ width: CGFloat) -> Self {
        var view = self
        view.width = width
        return view
    }
    
    public func setPadding(_ padding: EdgeInsets) -> Self {
        var view = self
        view.customPadding = padding
        return view
    }
}

public struct CircleLoadingBar: View {
    @State private var isLoading: Bool = false
    private var height: CGFloat = 44
    private var width: CGFloat = 44
    private var backgroundColor: Color = Color.primaryColor
    private var loadingBackgroundColor: Color = Color.primaryColor
    private var strokeColor: Color = Color.black
    private var progress: Double = 0.7
    private var strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(strokeColor, style: strokeStyle)
            .frame(width: width - 20, height: height - 20)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear.repeatForever(autoreverses: false), value: isLoading)
            .onAppear {
                self.isLoading = true
            }
    }
}

public struct LoadingButtonStyle {
    public var width: CGFloat = .infinity
    public var height: CGFloat = 44
    public var cornerRadius: CGFloat = 22
    public var backgroundColor: Color = Color.primaryColor
    public var loadingBackgroundColor: Color = Color.primaryColor
    public var strokeWidth: CGFloat = 0
    public var strokeColor = Color.black
    
    init(
        width: CGFloat = .infinity,
        height: CGFloat = 44,
        cornerRadius: CGFloat = 22,
        backgroundColor: Color = Color.primaryColor,
        loadingBackgroundColor: Color = Color.primaryColor,
        strokeWidth: CGFloat = 0,
        strokeColor: Color = Color.black
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.loadingBackgroundColor = loadingBackgroundColor
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }
}

#Preview {
    LoadingButtonView(isLoading: .constant(true)) {
        print("button pressed")
    } builder: {
        Text("Submit")
            .font(.system(size: 14))
            .fontWeight(.bold)
            .foregroundStyle(Color.textPrimary)
    }
}
