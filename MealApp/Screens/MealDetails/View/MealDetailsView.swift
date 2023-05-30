//
//  MealDetailsView.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import SwiftUI

struct MealDetailsView: View {
    var item: Meal
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel = DetailsViewModel()
    
    var body: some View {
        if let errorMessage = viewModel.errorMessage {
            ErrorView(errorMessage)
        } else {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    ZStack {
                        AsyncImage(
                            url: URL(string: item.strMealThumb ?? Constants.defaultValue),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        .redacted(reason: item.strMealThumb == nil ? .placeholder : .init())
                        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width)
                        .overlay(
                            ZStack {
                                VStack {
                                    HStack {
                                        Button(action: {
                                            presentation.wrappedValue.dismiss()
                                        }, label: {
                                            Image(systemName: Constants.chevronImage)
                                                .foregroundColor(.black)
                                                .fontWeight(.bold)
                                                .padding()
                                                .background(.white)
                                        })
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    Spacer()
                                }
                                .padding(.top, UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .first?
                                    .windows
                                    .first?
                                    .safeAreaInsets.top
                                )
                            }
                        )
                    }
                    
                    VStack {
                        VStack {
                            Capsule()
                                .frame(width: 80, height: 4)
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.top)
                            
                            HStack {
                                Text(viewModel.mealDetails?.first?.strCategory ?? Constants.desserts)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(.pink)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.pink.opacity(0.15))
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            
                            HStack {
                                Text(item.strMeal ?? Constants.defaultValue)
                                    .font(.system(size: 27, weight: .bold))
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                VStack {
                                    Text(Constants.instructions)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.pink)
                                    
                                    Spacer()
                                    Text(viewModel.mealDetails?.first?.strInstructions ?? Constants.defaultValue)
                                        .font(.system(size: 14, weight: .bold))
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                        }
                        .background(Color.white)
                        
                        VStack {
                            HStack {
                                Text(Constants.ingredients)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.pink)
                                Spacer()
                            }
                            .padding(.vertical)
                            .padding(.horizontal)
                            
                            ForEach(0..<10) { i in
                                if viewModel.mealDetails?.first?["strIngredient\(i)"] != nil && viewModel.mealDetails?.first?["strIngredient\(i)"] != "" {
                                    VStack {
                                        HStack {
                                            Text(viewModel.mealDetails?.first?["strIngredient\(i)"] ?? Constants.defaultValue)
                                            
                                            Spacer()
                                            
                                            Text(viewModel.mealDetails?.first?["strMeasure\(i)"] ?? Constants.defaultValue)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.vertical)
                                        
                                        Divider()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .background(Color.white)
                    }
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(30)
                    .offset(y: -30)
                }
            })
            .navigationBarHidden(true)
            .ignoresSafeArea(.all, edges: .all)
            .onAppear {
                if let mealId = item.idMeal {
                    viewModel.fetchMealDetails(mealId: mealId)
                } else {
                    _ = ErrorView(Constants.noRecordsFound, onRetry: nil)
                }
            }
        }
    }
}

struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailsView(item: items[0])
    }
}
