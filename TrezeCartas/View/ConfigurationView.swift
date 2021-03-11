//
//  ConfigurationView.swift
//  TrezeCartas
//
//  Created by Matheus Andrade on 11/03/21.
//

import SwiftUI

struct ConfigurationView: View {
    
    @Binding var rootIsActive : Bool
    
    @State var isAcessibilityOn : Bool = true
    @State var isSoundOn : Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                //Rectangle()
                   // .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack {
                    HStack {
                        Spacer()
                        Text("Configurações")
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
                            
                        }
                        //.padding()
                        .toggleStyle(SwitchToggleStyle(tint: Color.azulColor))
                        .frame(height: 55)
                        
                    }.padding(.horizontal)
                    .padding(.vertical, 6)
                    .clipped()
                    .background(Color.brancoColor)
                    .cornerRadius(10)
                    .offset(x: 0, y: -30)
                }
                .padding()
                
                VStack(alignment: .center){
                    
                    Spacer()
                    
                    Button(action: {
                        // dismiss
                        
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Continuar")
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
                    
                    Button(action: {
                        // pop to root -> rootIsActive
                        
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
                .padding()
                
            }
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).opacity(0.5))
            
            
            
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(rootIsActive: .constant(true))
    }
}
