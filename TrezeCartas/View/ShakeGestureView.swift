//
//  ShakeGesture.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//

import SwiftUI

struct ShakeGestureView: View {
    @State var blur: Float = 0.0
    @State private var message = "Unshaken"
    
    var body: some View {
        VStack{
            Text("valor do blur: \(blur/2)")
                .padding()
                .blur(radius: CGFloat(blur)/2)
            Text("valor do blur: \(blur)")
                .padding()
                .blur(radius: CGFloat(blur))
            Text(message)
                .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                    self.blur += 1
                    self.message = "Agitei \(blur) vezes"
                }
        }.blur(radius: CGFloat(blur))
    }
}

struct ShakeGestureView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeGestureView()
    }
}
