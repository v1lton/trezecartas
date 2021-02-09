//
//  CardView.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//

import SwiftUI

struct CardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    @State private var cardStatus: Cards = .none
    @State var degrees: Double = 0.0
    //@State var flipped = false
    
    private var user: User
    private var onRemove: (_ user: User) -> Void
    
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 30% the width of the screen in either direction
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    private enum Cards: Int {
        case back, front, none
    }
    
    init(user: User, onRemove: @escaping (_ user: User) -> Void) {
        self.user = user
        self.onRemove = onRemove
    }
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.0)]), startPoint: .bottom, endPoint: .center)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                if cardStatus == .front {
                    
                    ZStack(alignment: self.swipeStatus == .like ? .bottomLeading : .bottomTrailing) {
                        /// chamada do codigo para a arte da carta
                        CardArt(complete: false)
                        
                        VStack(alignment: .center, spacing: 0) {
                            Image("teste")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 176)
                                .clipped()
                                .cornerRadius(10)
                                //.cornerRadius(10, corners: [.topLeft, .topRight])
                                .padding([.top, .leading, .trailing])
                                .padding([.top, .leading, .trailing], 10)
                            Spacer()
                            VStack(alignment: .center, spacing: 0){
                                Text("O boy magia")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text("O boy que você tem o maior crush apareceu, mas você está atrás de um bloco com seus amigos.")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 70.0)
                                    .padding(.bottom)
                            }
                            Spacer()
                        }
                        /// swipe
                        if self.swipeStatus == .like {
                            Rectangle()
                                .fill(gradient)
                                //.fill(Color.black).opacity(0.5)
                            Text("Seguir o bloco")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                //                            .overlay(
                                //                                RoundedRectangle(cornerRadius: 10)
                                //                                    .stroke(Color.brancoColor, lineWidth: 3.0)
                                //                            )
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.leading, 30)
                                .padding(.bottom, 50)
                                .rotationEffect(Angle.degrees(-25))
                        } else if self.swipeStatus == .dislike {
                            Rectangle()
                                .fill(gradient)
                                //.fill(Color.black).opacity(0.5)
                            Text("Beijar o boy")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .padding()
                                .foregroundColor(Color.brancoColor)
                                .background(Color.rosaColor)
                                .cornerRadius(10)
                                .frame(width: 170.0)
                                .shadow(radius: 5)
                                .padding(.trailing, 30)
                                .padding(.bottom, 50)
                                .rotationEffect(Angle.degrees(25))
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                } else if cardStatus == .back {
                    
                    ZStack {
                        CardArt(complete: false)
                        
                        VStack(alignment: .center, spacing: 0) {
//                            Image("teste")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(height: 176)
//                                .clipped()
//                                .cornerRadius(10)
//                                //.cornerRadius(10, corners: [.topLeft, .topRight])
//                                .padding([.top, .leading, .trailing])
//                                .padding([.top, .leading, .trailing], 10)
                            Spacer()
                            VStack(alignment: .center, spacing: 0){
                                Text("O boy magia")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10.0)
                                Text("Você pegou o boy mas perdeu seus amigos. Agora está inseguro.")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(.brancoColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 70.0)
                                    .padding(.bottom)
                            }
                            Spacer()
                        }
                    }.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    
                } else {
                    
                    ZStack {
                        CardArt(complete: true)
                    }
                    
                }
            
            }
            .background(Color.roxoColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: cardStatus == .front ? self.translation.width : -self.translation.width, y: 0)
            .rotationEffect(.degrees(Double((cardStatus == .front ? self.translation.width : -self.translation.width) / geometry.size.width) * 25), anchor: .bottom)
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if cardStatus == .front {
                            self.translation = value.translation
                            
                            if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                                self.swipeStatus = .like
                            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                                self.swipeStatus = .dislike
                            } else {
                                self.swipeStatus = .none
                            }
                        } else if cardStatus == .back {
                            self.translation = value.translation
                        } else {
                            //nao faz nada, nao se desloca
                        }
                        
                    }.onEnded { value in
                        if cardStatus == .back {
                            if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                self.onRemove(self.user)
                            } else {
                                self.translation = .zero
                            }
                        } else if cardStatus == .front {
                            
                            if swipeStatus == .like {
                                cardStatus = .back
                                withAnimation {
                                    self.degrees -= 180
                                }
                            } else if swipeStatus == .dislike {
                                cardStatus = .back
                                withAnimation {
                                    self.degrees += 180
                                    
                                }
                            } else {
                                self.translation = .zero
                            }
                            self.translation = .zero
//                            if self.flipped {
//                                self.flipped = false
//                                withAnimation {
//                                    self.degrees -= 180
//                                    //self.width = 200 // add other animated stuff here
//                                    //self.height = 300
//                                }
//                            } else {
//                                self.flipped = true
//                                withAnimation {
//                                    self.degrees += 180
//                                    //self.width = 300 // add other animated stuff here
//                                    //self.height = 500
//                                }
//                            }
                                //cardStatus = .back
                            
                        }
                        // determine snap distance > 0.5 aka half the width of the screen
//                            self.translation = .zero
//                            if self.flipped {
//                                self.flipped = false
//                                withAnimation {
//                                    self.degrees -= 180
//                                    //self.width = 200 // add other animated stuff here
//                                    //self.height = 300
//                                }
//                            } else {
//                                self.flipped = true
//                                withAnimation {
//                                    self.degrees += 180
//                                    //self.width = 300 // add other animated stuff here
//                                    //self.height = 500
//                                }
//                            }
                            
                    }
            )
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(user: User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, mutualFriends: 0, imageName: "person_1", occupation: "Insurance Agent"),
                 onRemove: { _ in
                    // do nothing
                 })
            .frame(height: 450)
            .padding()
    }
}

/// flip

/// codido da arte
struct CardArt: View {
    var complete: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.amareloColor, lineWidth: 4.0)
                )
            VStack {
                if complete {
                    HStack {
                        Circle()
                            .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.azulColor)
                            .padding(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.amareloColor, lineWidth: 4.0)
                            )
                        Spacer()
                        Circle()
                            .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.azulColor)
                            .padding(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.amareloColor, lineWidth: 4.0)
                            )
                    }
                }
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.azulColor)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.amareloColor, lineWidth: 4.0)
                        )
                    Spacer()
                    Circle()
                        .frame(width: 12, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.azulColor)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.amareloColor, lineWidth: 4.0)
                        )
                }
            }
        }.padding()
    }
}

/// codigo para selecao de qual borda arrendondar
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
