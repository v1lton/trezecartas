//
//  ContentView2.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//
import SwiftUI
import AVFoundation
import AudioToolbox

struct ContentView2: View {
    @State var health = 10
    @State var money = 10
    @State var drugs = 0
    @State var leftOption: String = ""
    @State var rightOption: String = ""
    @State var leftButton = false
    @State var rightButton = false
    @State var pass = false
    
    @State var isPresentedGameOver = false
    @State var isPresentedFinished = false
    @Binding var rootIsActive : Bool
    @State var end = false
    @State var description = ""
    
    @State var maxIntID: Int = 12
    @State var cards = CardData().getShuffledCards()
    @State var isCardShowingBack = false
    
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(cards.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(cards.count - 1 - id) * 10
    }
    
    // Compute what the max ID in the given users array is.
    private var maxID: Int {
        return self.cards.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                
                VStack {
                    Spacer()
                    // status
                    VStack {
                        ProgressBar(health: $health, money: $money, drugs: $drugs).frame(height: 50)
                            .clipped()
                    }.padding()
                    
                    ZStack {
                        
                        VStack {
                            Image("logo2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).opacity(0.3)
                            
                        }.frame(height: 500)
                        
                        ForEach(self.cards, id: \.self) { cardss in
                            /// Using the pattern-match operator ~=, we can determine if our
                            /// user.id falls within the range of 6...9
                            if (self.maxID - 3)...self.maxID ~= cardss.id {
                                CardView(card: cardss, onRemove: { removedCard in
                                    // Remove that card from our array
                                    if end {
                                        self.isPresentedGameOver.toggle()
                                    } else {
                                        maxIntID -= 1 // reduz o id maximo
                                        if maxID == 0 {
                                            self.isPresentedFinished.toggle()
                                        }
                                    }
                                    self.cards.removeAll { $0.id == removedCard.id }
                                }, health: $health, money: $money, drugs: $drugs, maxID: $maxIntID, leftOption: $leftOption, rightOption: $rightOption, end: $end, isCardShowingBack: $isCardShowingBack, leftButton: $leftButton, rightButton: $rightButton, pass: $pass)
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: cardss.id), height: 500)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: cardss.id))
                                
                            }
                        }
                    }
                    
                    Spacer().frame(height: 50)
                    
                    if !self.isCardShowingBack {
                        
                        HStack {
                            
                            Button(action: {
                                self.leftButton.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text(leftOption)
                                        //.font(.custom("Raleway-Bold", size: 18))
                                        .font(.system(size: 17)) // era 20
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brancoColor)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(10)
                                    Spacer()
                                }
                                
                            }).frame(height: 65)
                            .clipped()
                            .background(Color.roxoClaroColor)
                            .cornerRadius(10)
                            
                            Spacer()
                                .frame(width: 7)
                            
                            Button(action: {
                                self.rightButton.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text(rightOption)
                                        .font(.system(size: 17)) // era 20
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brancoColor)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(10)
                                    Spacer()
                                }
                                
                            }).frame(height: 65)
                            .clipped()
                            .background(Color.roxoClaroColor)
                            .cornerRadius(10)
                        }
                        
                       
                    } else {
                        
                        //HStack {
                            
                            Button(action: {
                                self.pass.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Bora Dale")
                                        //.font(.custom("Raleway-Bold", size: 18))
                                        .font(.system(size: 17)) // era 20
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brancoColor)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(10)
                                    Spacer()
                                }
                                
                            }).frame(height: 65)
                            .clipped()
                            .background(Color.roxoClaroColor)
                            .cornerRadius(10)
                            
                            
                       
                        
                    }
                    Spacer().frame(height: 30)
                    
                    
                    HStack {
                        HStack {
                            Image("lata")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.trailing, -10)
                            Text("Agite para o \nsucesso")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.pretoColor)
                                .lineLimit(2)
                                .padding(.top, 4.0)
                        }.padding()
                    }.opacity(end ? 0 : 1)
                    //Spacer()
                }
            }
        }
        .onChange(of: end, perform: { value in
            if health == 0 && money == 0 &&  drugs == 0 {
                self.description = "Assédio não é brincadeira. Aqui é só um jogo, mas pra assédio não existe espaço em nenhum lugar. Você foi cancelado!"
            } else if health == 0 {
                self.description = "Bicha, nem assim tu sobrevive um rolê na 13! Bora se preparar pra o ano que vem pois o estrago vai ser grande!"
            } else if money == 0 {
                self.description = "Bicha, cadê teu aqué? Se tu gastar demais não consegue voltar pra casa, demônia!"
            } else if drugs == 10 {
                self.description = "Viado, tu já desse pt de novo, foi? Melhor sorte no próximo carnaval, se não tiver pandemia."
            }
        })
        .saturation(end ? 0 : 1)
        .navigationTitle(Text(""))
        //.navigationBarHidden(true)
        .navigationBarBackButtonHidden(end ? true : false)
        .preferredColorScheme(.light)
        .blur(radius: CGFloat(drugs)/2)
        .padding()
        .background(Color.brancoColor)
        .edgesIgnoringSafeArea(.all)
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            //self.drugs += 1
            if !end {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.drugs += 1
            }
            if drugs == 10 {
                self.description = "Viado, tu já desse pt de novo, foi? Melhor sorte no próximo carnaval, se não tiver pandemia."
                self.isPresentedGameOver.toggle()
            }
        }
        .overlay(EndGame(shouldPopToRootView: self.$rootIsActive, description: $description).opacity(isPresentedGameOver ? 1 : 0).animation(.easeInOut(duration: 0.3)))
        // trocar para a tela de ganhou
        .overlay(FinalGame(shouldPopToRootView: self.$rootIsActive).opacity(isPresentedFinished ? 1 : 0).animation(.easeInOut(duration: 0.3)))
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
