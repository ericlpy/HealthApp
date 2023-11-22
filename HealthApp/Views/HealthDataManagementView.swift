//
//  HealthDataManagementView.swift
//  HealthApp
//
//  Created by Eric Li on 14/11/2023.
//

import SwiftUI

struct HealthDataManagementView: View {
    private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text("Health Data Management")
                .font(.title2)
                .bold()
            Divider()
            ZStack {
                RoundedRectangle(cornerRadius:25)
                    .fill(LinearGradient(
                        gradient: .init(colors: [.green, .cyan, .cyan, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).shadow(.drop(color: .black, radius: 5)))
                    .frame(width: 350, height: 100)
                    .padding(.top)
                VStack {
                    Text("Hey, Eric!!")
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("How's your progress today?")
                        .foregroundStyle(.white)
                        .bold()
                    
                }
            }
            .padding([.leading, .bottom, .trailing])
            LazyVGrid(columns: twoColumnGrid) {
                ZStack {
                    RoundedRectangle(cornerRadius:25)
                        .fill(LinearGradient(
                            gradient: .init(colors: [.green, .cyan, .cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).shadow(.drop(color: .black, radius: 5)))
                        .frame(width: 170, height: 75)
                    .padding()
                    VStack {
                        Text("Current Height:")
                            .foregroundStyle(.white)
                            .bold()
                        Text("180 cm")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius:25)
                        .fill(LinearGradient(
                            gradient: .init(colors: [.green, .cyan, .cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).shadow(.drop(color: .black, radius: 5)))
                        .frame(width: 170, height: 75)
                    .padding()
                    VStack {
                        Text("Current Weight:")
                            .foregroundStyle(.white)
                            .bold()
                        Text("70 kg")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius:25)
                        .fill(LinearGradient(
                            gradient: .init(colors: [.green, .cyan, .cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).shadow(.drop(color: .black, radius: 5)))
                        .frame(width: 170, height: 75)
                    .padding()
                    VStack {
                        Text("Current Plan:")
                            .foregroundStyle(.white)
                            .bold()
                        Text("Workout for man")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius:25)
                        .fill(LinearGradient(
                            gradient: .init(colors: [.green, .cyan, .cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).shadow(.drop(color: .black, radius: 5)))
                        .frame(width: 170, height: 75)
                    .padding()
                    VStack {
                        Text("Target Weight:")
                            .foregroundStyle(.white)
                            .bold()
                        Text("65 kg")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
            }
            Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .infinity)
            Spacer()
        }
    }
}

#Preview {
    HealthDataManagementView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
