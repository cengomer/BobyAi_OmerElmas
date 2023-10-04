

import Foundation
import Alamofire
import SwiftUI

class OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/images/generations"
    @AppStorage("openai_api_key") var apiKey = ""

    func generateImage(prompt: String) async throws -> OpenAIImageResponse {
        let body = OpenAIImageRequestBody(prompt: prompt, size: "512x512")
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(apiKey)"]
        
        return try await AF.request(endpointUrl , method: .post, parameters: body , encoder:.json , headers: headers).serializingDecodable(OpenAIImageResponse.self).value
    }
}

struct OpenAIImageResponse: Decodable {
    let data: [OpenAIImageURL]
    
}
struct OpenAIImageURL : Decodable {
    let url: String
}

struct OpenAIImageRequestBody: Encodable {
    let prompt: String
    let size: String
}
