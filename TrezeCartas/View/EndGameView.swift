//
//  EndGame.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI

struct EndGameView: View {

    @Binding var shouldPopToRootView : Bool
    @Binding var description: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    // substituir a foto depois
                    Image("caveira1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height * 0.20)
                        .padding(.bottom)
                        .clipped()
                    Text("Game Over!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                    Text("\(description)")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 230)
                        .padding()
                    Spacer()
                }
                
                VStack {
                    Text("Toque para tentar novamente")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                        .frame(height: 60)
                }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.black)
            .onTapGesture {
                //presentationMode.wrappedValue.dismiss()
                self.shouldPopToRootView = false
            }
//            .onChange(of: isPresented, perform: { value in
//                self.mode.wrappedValue.dismiss()
//            })
//            .fullScreenCover(isPresented: $isPresented, content: {
//                StartGame()
//            })
            
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .preferredColorScheme(.light)
        .statusBar(hidden: true)
    }
}

//struct EndGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        EndGame(description: "Você deu pt. Melhor sorte no próximo carnaval, se não tiver pandemia.")
//    }
//}
