//
//  MealView.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import SwiftUI

// MARK: - MealView for meals shown in dessert category
struct MealView: View {
    var item: Meal
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.strMeal ?? Constants.defaultValue)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.pink)
                    .redacted(reason: item.strMeal == nil ? .placeholder : .init())
            }
            .padding(.top)
            .padding(.leading)
            
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                AsyncImage(
                    url: URL(string: item.strMealThumb ?? Constants.emptyString),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                .frame(width: 100, height: 100)
                .onAppear {
                    ImageCache.shared.loadImage(from: URL(string: item.strMealThumb ?? Constants.emptyString)) { _ in }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView(item: items[0])
    }
}
