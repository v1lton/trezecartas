//
//  ShakeGesture.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//

import SwiftUI

struct ShakeGesture: View {
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

struct ShakeGesture_Previews: PreviewProvider {
    static var previews: some View {
        ShakeGesture()
    }
}

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
