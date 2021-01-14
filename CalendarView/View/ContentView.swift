//
//  ContentView.swift
//  CalendarView
//
//  Created by Luis Aceredo on 14/01/21.
//

import SwiftUI

struct ContentView: View {
    var tap: (DateModel)-> Void
    public init(tap: @escaping (DateModel)-> Void ){
        self.tap = tap
    }
    @ObservedObject var date = DateModelController()
    @State var arrowDisabled: Bool = false
    public var body: some View {
        HStack {
            Button(action: {
                self.date.lastWeek(completed: {
                    self.arrowDisabled.toggle()
                })
            }, label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.green)
                    .frame(width: 25, height: 25, alignment: .center)
            }).disabled(arrowDisabled)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        
                        HStack(spacing: 10) {
                            ForEach(self.date.listOfDates, id: \.self) { item in
                                VStack(spacing: 6) {
                                    Text(item.nameDay)
                                        .foregroundColor(.black)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(item.isSelected ? .green : Color.clear)
                                            .frame(width: 28, height: 28)
                                        Text("\(item.day)")
                                            .foregroundColor(.black)
                                        
                                    }
                                }.onTapGesture {
                                    withAnimation {
                                        self.date.toggleIsSelected(date: item)
                                        self.tap(item)
                                    }
                                }
                            }
                        }.frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                        .padding(.top)
                        .padding(.bottom)
                        
                        
                    }).background(Color.white)
                    .frame(height: 80)
                    .cornerRadius(10)
                    Spacer()
                }
                
            }
            Button(action: {
                self.date.nextWeek()
                self.arrowDisabled = false
            }, label: {
                Image(systemName: "arrow.right")
                    .foregroundColor(.green)
                    .frame(width: 25, height: 25, alignment: .center)
                
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            ContentView(tap: {_ in })
        }
        
    }
}
