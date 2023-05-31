//
//  DetailsViewModel.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import Foundation
import Combine

// MARK: - DetailsViewModel to handle Details API response
final class DetailsViewModel: ObservableObject {
    
    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var mealDetails: [Meal]?
    @Published var viewState: ViewState = .loading
    public var placeholders = Array(repeating: Meal(), count: 10)
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    /**
      Fetches the details of a meal from the API for the specified meal ID.

      - Parameters:
        - mealId: The ID of the meal for which to fetch the details.

      ## Description

      The 'fetchMealDetails' function fetches the details of a meal from the API for the specified meal ID. It updates the view state to indicate the loading state and constructs the URL based on the provided meal ID.

      The function uses the 'NetworkServiceProtocol' to make the HTTP request and decode the response into a 'Meals' object. It handles success and failure cases using the 'sink' operator.
    */
    func fetchMealDetails(mealId: String) {
        self.viewState = .loading
        let urlString = "\(Constants.baseURl)/lookup.php?i=\(mealId)"
        guard let url = URL(string: urlString) else {
            self.viewState = .error(message: Constants.invalidURL)
            return
        }
        service.request(url: url, decodeType: Meals.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? URLError,
                       error.code == .timedOut {
                        DispatchQueue.main.async {
                            self.viewState = .error(message: Constants.requestTimeout)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.viewState = .error(message: Constants.somethingWentWrong)
                        }
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] responseData in
                DispatchQueue.main.async {
                    self?.mealDetails = responseData.meals
                    self?.viewState = .dataLoaded
                }
            }
            .store(in: &cancellables)
    }
}
