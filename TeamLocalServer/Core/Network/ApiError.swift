//
//  ApiError.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

struct ApiErrorDTO: Codable {
    let code: String?
    let message: String?
    let errorItems: [String: String]?
}

enum ApiError: Error {
    case custom(ApiErrorDTO)
    case requestFailed
    case basicError(Error)
    case emptyErrorWithStatusCode(String)
    
    var description: String {
        switch self {
        case .custom(let apiErrorDTO):
            var errorItems: String?
            if let errorItemsDTO = apiErrorDTO.errorItems {
                errorItems = ""
                errorItemsDTO.forEach {
                    errorItems?.append("\($0.key) \($0.value)\n")
                }
            }
            let code = apiErrorDTO.code
            let message = apiErrorDTO.message
            if errorItems == nil, code == nil, message == nil {
                errorItems = "Internal error!"
            }
            return String(format: "%@ %@ \n %@", code ?? "", message ?? "", errorItems ?? "")
        case .requestFailed:
            return "Request Failed."
        case .basicError(let error):
            return error.localizedDescription
        case .emptyErrorWithStatusCode(let status):
            return status
        }
    }
}
