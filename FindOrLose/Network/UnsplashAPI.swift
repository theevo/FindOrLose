/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Combine

enum UnsplashAPI {
  static let accessToken = "Kk2iTjWX-RrMK6KVlPVv7Wa_PR2nT7L4Glat8xBcX4w"

  static func randomImage() -> AnyPublisher<RandomImageResponse, GameError> {
    let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(accessToken)")!

    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)

    var urlRequest = URLRequest(url: url)
    urlRequest.addValue("Accept-Version", forHTTPHeaderField: "v1")

    return session.dataTaskPublisher(for: urlRequest)
      .tryMap { (data: Data, response: URLResponse) in
        guard let httpURLResponse = response as? HTTPURLResponse else {
          throw GameError.badResponse
        }
        guard httpURLResponse.statusCode == 200
        else {
          throw GameError.statusCode(httpURLResponse.statusCode)
        }
        return data
        }
      .decode(type: RandomImageResponse.self, decoder: JSONDecoder())
      .mapError { GameError.map($0) }
      .eraseToAnyPublisher()
  }
}
