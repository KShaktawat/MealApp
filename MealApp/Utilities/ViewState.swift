//
//  ViewState.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case error(message: String)
    case dataLoaded
}
