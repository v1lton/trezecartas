//
//  ContentView2.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 06/02/21.
//
import SwiftUI

struct User: Hashable, CustomStringConvertible {
    var id: Int
    
    let firstName: String
    let lastName: String
    let age: Int
    let mutualFriends: Int
    let imageName: String
    let occupation: String
    
    var description: String {
        return "\(firstName), id: \(id)"
    }
}

struct ContentView2: View {
    
    // 1
    /// List of users
    @State var users: [User] = [
        User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, mutualFriends: 4, imageName: "person_1", occupation: "Coach"),
        User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, mutualFriends: 0, imageName: "person_2", occupation: "Insurance Agent"),
        User(id: 2, firstName: "Clayton", lastName: "Delaney", age: 20, mutualFriends: 1, imageName: "person_3", occupation: "Food Scientist"),
        User(id: 3, firstName: "Brittni", lastName: "Watson", age: 19, mutualFriends: 4, imageName: "person_4", occupation: "Historian"),
        User(id: 4, firstName: "Archie", lastName: "Prater", age: 22, mutualFriends:18, imageName: "person_5", occupation: "Substance Abuse Counselor"),
        User(id: 5, firstName: "James", lastName: "Braun", age: 24, mutualFriends: 3, imageName: "person_6", occupation: "Marketing Manager"),
        User(id: 6, firstName: "Danny", lastName: "Savage", age: 25, mutualFriends: 16, imageName: "person_7", occupation: "Dentist"),
        User(id: 7, firstName: "Chi", lastName: "Pollack", age: 29, mutualFriends: 9, imageName: "person_8", occupation: "Recreational Therapist"),
        User(id: 8, firstName: "Josue", lastName: "Strange", age: 23, mutualFriends: 5, imageName: "person_9", occupation: "HR Specialist"),
        User(id: 9, firstName: "Debra", lastName: "Weber", age: 28, mutualFriends: 13, imageName: "person_10", occupation: "Judge")
    ]
    
    // 2
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(users.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    // 3
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(users.count - 1 - id) * 10
    }
    
    // Compute what the max ID in the given users array is.
    private var maxID: Int {
        return self.users.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            // 4
            GeometryReader { geometry in
                // 5
                VStack {
                    // aqui entra os status
                    Spacer()
                        .frame(height: 155)
                    
                    // 6
                    ZStack {
                        
                        // 7
                        ForEach(self.users, id: \.self) { user in
                            
                            /// Using the pattern-match operator ~=, we can determine if our
                            /// user.id falls within the range of 6...9
                            if (self.maxID - 3)...self.maxID ~= user.id {
                                // Normal Card View being rendered here.
                                //CardView()
                                
                                CardView(user: user, onRemove: { removedUser in
                                    // Remove that user from our array
                                    self.users.removeAll { $0.id == removedUser.id }
                                })
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: user.id), height: 450)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: user.id))
                                //.opacity(Double(self.getCardOffset(geometry, id: user.id))/20)
                                
                                
                            }
                        }
                    }
                    
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            // acao do botao
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Primeira escolha")
                                    //.font(.custom("Raleway-Bold", size: 18))
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding()
                                Spacer()
                            }
                            
                        }).frame(height: 80)
                        .clipped()
                        .background(Color.gray)
                        .cornerRadius(10)
                        //.shadow(radius: 5)
                        
                        Spacer()
                            .frame(width: 7)
                        
                        Button(action: {
                            // acao do botao
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Segunda escolha")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding()
                                Spacer()
                            }
                            
                        }).frame(height: 80)
                        .clipped()
                        .background(Color.gray)
                        .cornerRadius(10)
                        //.shadow(radius: 5)
                    }
                    
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }.padding()
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
