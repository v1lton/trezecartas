//
//  StartGame.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI

struct StartGame: View {
    
    @State var isPresented = false
    @Namespace var namespace
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    // coloquei essa carta aqui pra nao ficar sem nada, mas tem que decidir o que vai ter na carta inicial
//                    CardArt(complete: true)
//                        .frame(height: 450)
//                        .background(Color.roxoColor)
//                        .cornerRadius(10)
//                        .padding()
                    Spacer()
                }
                
                VStack {
                    Text("Agite para iniciar o jogo.")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.pretoColor)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                        .frame(height: 60)
                }
                
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                ContentView2()
                    .matchedGeometryEffect(id: "UniqueViewID", in: namespace, properties: .frame, isSource: isPresented)
            })
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.brancoColor)
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                self.isPresented.toggle()
            }
            
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct StartGame_Previews: PreviewProvider {
    static var previews: some View {
        StartGame()
    }
}

