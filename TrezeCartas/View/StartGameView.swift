//
//  StartGame.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI

struct StartGameView: View {
    
    //@EnvironmentObject var appState: AppState
    @State var isPresented = false
    @Namespace var namespace
    @State var showConfig = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom){
                    
                    NavigationLink(destination: GameView(rootIsActive: self.$isPresented), isActive: $isPresented) { EmptyView()}.isDetailLink(false)
                    
                    
                    VStack{
                        Spacer()
                        
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
                    
                    VStack (alignment: .trailing) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                self.showConfig.toggle()
                            }, label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minHeight: 25)
                                    .frame(height: UIScreen.main.bounds.height*0.035)
                                    .foregroundColor(Color.roxoClaroColor)
                                    //.padding(6)
                            })
                            .padding()
                            .padding(.top, UIScreen.main.bounds.height > 800 ? UIScreen.main.bounds.height*0.02 : 0)
                        }
                        
                        Spacer()
                    }
                    
                    /// config
                    VStack {
                        Spacer()
                        ConfigurationView(shouldPopToRootView: .constant(false), showConfig: $showConfig, isPause: false)
                            .offset(y: self.showConfig ? 0 : UIScreen.main.bounds.height)
                            .padding()
                            //.padding(.bottom)
                    }
                    .background(VisualEffectView(effect: UIBlurEffect(style: .dark))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .opacity((self.showConfig ? 1 : 0)))
                    
                }
                .padding()
                .animation(.default)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.brancoColor)
                .onTapGesture {
                    if !showConfig {
                        self.isPresented.toggle()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.brancoColor)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .accentColor(Color.roxoColor)
        .navigationBarBackButtonHidden(false)
        .navigationBarHidden(true)
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}


