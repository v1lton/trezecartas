//
//  EndGame.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI

struct EndGame: View {

    @State var description: String
    @State var isPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    // substituir a foto depois
                    Image("tempMorte")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 130)
                        .clipped()
                    Text("Game Over!")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                    Text("\(description)")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 230)
                        .padding()
                    Spacer()
                }
                
                VStack {
                    Text("Agite para tentar novamente.")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                        .frame(height: 60)
                }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.black)
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                self.isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                StartGame()
            })
            
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .preferredColorScheme(.light)
    }
}

struct EndGame_Previews: PreviewProvider {
    static var previews: some View {
        EndGame(description: "Você deu pt. Melhor sorte no próximo carnaval, se não tiver pandemia.")
    }
}
