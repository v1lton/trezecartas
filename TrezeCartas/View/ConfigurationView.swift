//
//  ConfigurationView.swift
//  TrezeCartas
//
//  Created by Matheus Andrade on 11/03/21.
//

import SwiftUI

struct ConfigurationView: View {
    
    @Binding var shouldPopToRootView : Bool
    @Binding var showConfig: Bool
    
    @AppStorage("acessibility") var isAcessibilityOn : Bool = false
    @AppStorage("sound") var isSoundOn : Bool = false
    
    var isPause: Bool
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                VStack {
                    HStack {
                        Spacer()
                        Text(isPause ? "Pause" : "Configurações")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.brancoColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(7)
                            .padding(.top, -20)
                        Spacer()
                    }
                    .frame(height: 72)
                    .clipped()
                    .background(Color.azulColor)
                    .cornerRadius(10)
                    
                    
                    VStack {
                        Toggle(isOn: $isAcessibilityOn) {
                            Text("Botões de Acessibilidade")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.pretoColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            
                        }
                        //.padding()
                        .toggleStyle(SwitchToggleStyle(tint: Color.azulColor))
                        .frame(height: 55)
                        
                        Divider()
                        
                        Toggle(isOn: $isSoundOn) {
                            Text("Efeitos Sonoros")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.pretoColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .opacity(0.4)
                            
                        }
                        //.padding()
                        .toggleStyle(SwitchToggleStyle(tint: Color.azulColor))
                        .frame(height: 55)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .opacity(0.7)
                        
                    }.padding(.horizontal)
                    .padding(.vertical, 6)
                    .clipped()
                    .background(Color.brancoColor)
                    .cornerRadius(10)
                    .offset(x: 0, y: -30)
                }
                
                VStack(alignment: .center){
                    
                    Spacer()
                    
                    Button(action: {
                        // dismiss
                        self.showConfig.toggle()
                    }, label: {
                        HStack {
                            Spacer()
                            Text(isPause ? "Continuar" : "Voltar")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.brancoColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(7)
                            Spacer()
                        }
                        
                    }).frame(height: 55)
                    .clipped()
                    .background(Color.azulColor)
                    .cornerRadius(10)
                    
                    if isPause {
                        Button(action: {
                            // pop to root
                            self.shouldPopToRootView = false
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Retornar ao Menu")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.rosaColor)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding(7)
                                Spacer()
                            }
                            
                        }).frame(height: 55)
                        .clipped()
                        .background(Color.brancoColor)
                        .cornerRadius(10)
                    }
                }
                
            }
            
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        //ConfigurationView(rootIsActive: .constant(true))
        Testeeeee()
    }
}

struct Testeeeee: View {
    
    @State var showConfig: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showConfig.toggle()
                }, label: {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.brancoColor)
                        .padding(6)
                })
                .clipped()
                .background(Color.roxoClaroColor)
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    self.showConfig.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Text("mostrar config")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.brancoColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(7)
                        Spacer()
                    }
                    
                }).frame(height: 55)
                .clipped()
                .background(Color.azulColor)
                .cornerRadius(10)
                .padding()
                
            }
            
            VStack {
                Spacer()
                ConfigurationView(shouldPopToRootView: .constant(true), showConfig: $showConfig, isPause: true)
                    .offset(y: self.showConfig ? 0 : UIScreen.main.bounds.height)
                    
            }
            .background((self.showConfig ? Color.black.opacity(0.5) : Color.clear).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .edgesIgnoringSafeArea(.top)
            
        }.animation(.default)
    }
}
