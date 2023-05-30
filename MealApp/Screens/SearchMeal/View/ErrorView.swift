//
//  ErrorView.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import SwiftUI

struct ErrorView: View {

    let message: String
    var onRetry: (() -> Void)?

    init(_ message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Constants.exclamationImage)
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text(message)
            if let onRetry {
                Button(action: onRetry) {
                    HStack {
                        Image(systemName: Constants.backwardImage)
                        Text(Constants.retry)
                    }
                }.buttonStyle(.bordered)
            }

        }.padding(20)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(Constants.somethingWentWrong)
    }
}
