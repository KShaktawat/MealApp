//
//  SearchViewModel.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var viewState: ViewState = .loading
    @Published var allMeals: [Meal]?
    public var placeholders = Array(repeating: Meal(), count: 10)

    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }

    func fetchAllMealsWithDessertCategory(query: String) {
        self.viewState = .loading
        service.request(url:"\(Constants.baseURl)/filter.php?c=\(query)", decodeType: Meals.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? URLError,
                       error.code == .timedOut {
                        self.viewState = .error(message: Constants.requestTimeout)
                    } else {
                        self.viewState = .error(message: Constants.somethingWentWrong)
                    }
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] responseData in
                self?.allMeals = responseData.meals
                self?.viewState = .dataLoaded
            }
            .store(in: &cancellables)
    }
}
