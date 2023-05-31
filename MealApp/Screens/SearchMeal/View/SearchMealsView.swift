//
//  SearchMealsView.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import SwiftUI

struct SearchMealsView: View {
    
    @State private var searchedText: String = Constants.emptyString
    @StateObject private var viewModel = SearchViewModel()
    @State var showSearchResult = false
    
    private var filteredMeals: [Meal] {
        let lowercasedSearchText = searchedText.lowercased()
        if searchedText.count > 1 {
            var matchingMeals: [Meal] = []
            self.viewModel.allMeals?.forEach { meal in
                let searchContent = meal.strMeal
                if searchContent?.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                    matchingMeals.append(meal)
                }
            }
            return matchingMeals
            
        } else {
            return self.viewModel.allMeals ?? self.viewModel.placeholders
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    VStack(spacing: 5) {
                        Text(Constants.heading)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text(Constants.subHeading)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }.padding(.bottom)
                    
                    HStack(spacing: 15) {
                        Image(systemName: Constants.magnifyingImage)
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(.gray)
                        
                        TextField(Constants.placeholder,
                                  text: $searchedText,
                                  onCommit: {
                            showSearchResult = true
                        })
                        .font(.system(size: 21))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
                    .padding(.top)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        if filteredMeals.count > 0 {
                            Text(Constants.desserts)
                                .font(.system(size: 27, weight: .bold))
                            
                            VStack {
                                ForEach(filteredMeals.indices, id: \.self) { index in
                                    NavigationLink(
                                        destination: MealDetailsView(item: filteredMeals[index]),
                                        label: {
                                            MealView(item: filteredMeals[index])
                                        })
                                }
                            }
                        } else {
                            Text(Constants.noMealsFound)
                                .padding(.top)
                        }
                    }
                    .padding(.horizontal)
                }.padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.secondarySystemBackground))
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                })
        .onAppear {
            viewModel.fetchAllMealsWithDessertCategory(query: Constants.dessertQuery)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchMealsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMealsView()
    }
}
