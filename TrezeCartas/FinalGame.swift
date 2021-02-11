//
//  FinalGame.swift
//  TrezeCartas
//
//  Created by Wilton Ramos on 11/02/21.
//

import SwiftUI

struct FinalGame: View {
    
    @State var isPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    // substituir a foto depois
                    Image("lataFinal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 182)
                        .clipped()
                    Text("Você sobreviveu!")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                    Text("Parabéns! Talvez não tenha restado dignidade, mas você conseguiu sobreviver a mais um Carnaval na 13.")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .padding()
                    Spacer()
                }
                
                VStack {
                    Text("Toque para jogar novamente.")
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
            .background(
                Image("confetes")
                    .resizable()
                    .scaledToFill()
            )
            .background(Color("roxoClaro"))
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                self.isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                StartGame()
            })
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .preferredColorScheme(.light)
    }
}

struct FinalGame_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FinalGame()
            FinalGame()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
