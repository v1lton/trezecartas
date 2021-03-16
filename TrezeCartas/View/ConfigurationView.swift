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
    
    var environment : GameEnvironment?
    
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
                            self.environment?.reset()
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
