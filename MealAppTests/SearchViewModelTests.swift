//
//  SearchViewModelTests.swift
//  MealAppTests
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import XCTest
import Combine
@testable import MealApp

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var mockService: MockNetworkService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        mockService = MockNetworkService()
        viewModel = SearchViewModel(service: mockService)
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        viewModel = nil
        mockService = nil
    }
    
    func testFetchAllMealsWithDessertCategory_Success() throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch meals with dessert category")
        let mockResponse = Meals(meals: [Meal(idMeal: "1", strMeal: "Dessert 1"),
                                         Meal(idMeal: "2", strMeal: "Dessert 2")])
        mockService.mockResponse = Result.success(mockResponse)
        
        // When
        viewModel.fetchAllMealsWithDessertCategory(query: "dessert")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.allMeals?.count, 2)
            XCTAssertEqual(self.viewModel.allMeals?[0].strMeal, "Dessert 1")
            XCTAssertEqual(self.viewModel.allMeals?[1].strMeal, "Dessert 2")
            XCTAssertEqual(self.viewModel.viewState, .dataLoaded)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchAllMealsWithDessertCategory_Failure() throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch meals with dessert category")
        let mockError = URLError(.notConnectedToInternet)
        mockService.mockResponse = Result.failure(mockError)
        
        // When
        viewModel.fetchAllMealsWithDessertCategory(query: "dessert")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.allMeals)
            XCTAssertEqual(self.viewModel.viewState, .error(message: Constants.somethingWentWrong))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// Mock implementation of NetworkServiceProtocol for testing
class MockNetworkService: NetworkServiceProtocol {
    var mockResponse: Result<Decodable, Error>?
    
    func request<T>(url: URL?, decodeType: T.Type) -> Future<T, Error> where T: Decodable {
        return Future<T, Error> { promise in
            guard let mockResponse = self.mockResponse else {
                promise(.failure(NSError(domain: "MockNetworkService", code: 0, userInfo: nil)))
                return
            }
            
            switch mockResponse {
            case .success(let data):
                guard let decodedData = data as? T else {
                    promise(.failure(NSError(domain: "MockNetworkService", code: 0, userInfo: nil)))
                    return
                }
                promise(.success(decodedData))
                
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
