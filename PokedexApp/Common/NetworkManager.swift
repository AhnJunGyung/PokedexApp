//
//  NetworkManager.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}//싱글톤 패턴 적용
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                //응답 검증
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                do {//try : 에러를 catch로 보냄
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()//요청을 실제로 시작
            
            return Disposables.create()
        }
    }
}
