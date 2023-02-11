//
//  ErrorViewState.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation

protocol ErrorViewState: ViewState {
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
}

struct DefaultErrorViewState: ErrorViewState {
    var title = "Error"
    var description = "An Error occured fetching the data"
    var buttonTitle: String = "Try again"
}
