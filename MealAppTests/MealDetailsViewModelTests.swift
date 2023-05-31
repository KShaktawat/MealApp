//
//  MealDetailsViewModelTests.swift
//  MealAppTests
//
//  Created by Kshitija Shaktawat on 5/31/23.
//

import XCTest
import Combine
@testable import MealApp

class DetailsViewModelTests: XCTestCase {

    var viewModel: DetailsViewModel!
    var mockService: MockNetworkService!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        mockService = MockNetworkService()
        viewModel = DetailsViewModel(service: mockService)
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        viewModel = nil
        mockService = nil
    }

    func testFetchMealDetails_Success() throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch meal details")
        let mockResponse = Meals(meals: [Meal(idMeal: "1", strMeal: "Meal 1")])
        mockService.mockResponse = Result.success(mockResponse)

        // When
        viewModel.fetchMealDetails(mealId: "1")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.mealDetails?.count, 1)
            XCTAssertEqual(self.viewModel.mealDetails?[0].strMeal, "Meal 1")
            XCTAssertEqual(self.viewModel.viewState, .dataLoaded)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchMealDetails_Failure() throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch meal details")
        let mockError = URLError(.notConnectedToInternet)
        mockService.mockResponse = Result.failure(mockError)

        // When
        viewModel.fetchMealDetails(mealId: "1")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.mealDetails)
            XCTAssertEqual(self.viewModel.viewState, .error(message: Constants.somethingWentWrong))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
