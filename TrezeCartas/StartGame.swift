//
//  StartGame.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI

struct StartGame: View {
    
    //@EnvironmentObject var appState: AppState
    @State var isPresented = false
    @Namespace var namespace
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom){
                    
                    NavigationLink(destination: ContentView2(rootIsActive: self.$isPresented), isActive: $isPresented) { EmptyView()}.isDetailLink(false)
                    
                    
                    VStack{
                        Spacer()
                        // coloquei essa carta aqui pra nao ficar sem nada, mas tem que decidir o que vai ter na carta inicial
                        //                    CardArt(complete: true)
                        //                        .frame(height: 450)
                        //                        .background(Color.roxoColor)
                        //                        .cornerRadius(10)
                        //                        .padding()
                        
                        Image("logo2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: UIScreen.main.bounds.height * 0.558, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Text("Toque para iniciar o jogo")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.pretoColor)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                            .frame(height: 60)
                    }
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.brancoColor)
                .onTapGesture {
                    self.isPresented.toggle()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .accentColor(Color.roxoColor)
        .navigationBarBackButtonHidden(false)
        .navigationBarHidden(true)
    }
}

struct StartGame_Previews: PreviewProvider {
    static var previews: some View {
        StartGame()
    }
}


