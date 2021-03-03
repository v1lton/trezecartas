//
//  FinalGame.swift
//  TrezeCartas
//
//  Created by Wilton Ramos on 11/02/21.
//

import SwiftUI

struct FinalGame: View {
    
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    // substituir a foto depois
                    Image("lata1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height * 0.20)
                        .clipped()
                    Text("Você sobreviveu!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                    Text("Parabéns! Talvez não tenha restado dignidade, mas você conseguiu sobreviver a mais um Carnaval na 13.")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.brancoColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .padding()
                    Spacer()
                }
                
                VStack {
                    Text("Toque para jogar novamente")
                        .font(.subheadline)
                        .fontWeight(.regular)
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
            .onTapGesture {
                //presentationMode.wrappedValue.dismiss()
                self.shouldPopToRootView = false
            }
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .preferredColorScheme(.light)
    }
}

//struct FinalGame_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            FinalGame()
//            FinalGame()
//                .previewDevice("iPhone SE (2nd generation)")
//        }
//    }
//}
