//
//  DetailsViewModel.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import Foundation

class DetailsViewModel: ObservableObject {
    
    @Published var mealDetails: [Meal]?
    @Published var errorMessage: String?
    public var placeholders = Array(repeating: Meal(), count: 10)
    
    func fetchMealDetails(mealId: String) {
        let urlString = "\(Constants.baseURl)/lookup.php?i=\(mealId)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = Constants.invalidURL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.method
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if let data = data {
                do {
                    let details = try JSONDecoder().decode(Meals.self, from: data)
                    DispatchQueue.main.async {
                        self.mealDetails = details.meals
                    }
                } catch {
                    self.errorMessage = Constants.parsingError
                    return
                }
            }
        }.resume()
    }
}
