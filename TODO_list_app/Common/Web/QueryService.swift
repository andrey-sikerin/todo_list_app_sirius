import UIKit
import RxSwift

class QueryService {
    enum APIError: Int, Error {
        case notFound = 404
        case badRequest = 400
        case notAuthorized = 403
        case conflict = 409
        case unrecognized
    }

    enum Errors: Error {
        case invalidArguments
    }

    enum Method: String {
        case POST
        case GET
        case PUT
        case DELETE
    }

    enum Handle: String {
        case tasks
    }

    private let baseUrl: String
    private let token: String

    init(baseUrl: String, token: String) {
        self.baseUrl = baseUrl
        self.token = token
    }

    private func getRequest(handle: Handle, method: Method, id: String? = nil) -> URLRequest {
        var url = baseUrl + handle.rawValue
        if let id = id {
            url += "/\(id)"
        }
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method.rawValue
        return request
    }

    public func addTodo(payload: TodoItem) throws -> Single<TodoItem> {
        var request = getRequest(handle: Handle.tasks, method: Method.POST)
        if let body = try? JSONEncoder().encode(payload) {
            request.httpBody = body
            return handleRequest(request: request)
        }
        throw Errors.invalidArguments
    }

    public func deleteTodo(itemId: String) throws -> Single<TodoItem> {
        return handleRequest(request: getRequest(handle: Handle.tasks, method: Method.DELETE, id: itemId))
    }

    public func changeTodo(payload: TodoItem) throws -> Single<TodoItem> {
        guard payload.updatedAt != nil else {
            throw Errors.invalidArguments
        }

        var request = getRequest(handle: Handle.tasks, method: Method.PUT, id: payload.id)
        if let body = try? JSONEncoder().encode(payload) {
            request.httpBody = body
            return handleRequest(request: request)
        }
        throw Errors.invalidArguments
    }

    public func getTodoList() -> Single<[TodoItem]> {
        return handleRequest(request: getRequest(handle: Handle.tasks, method: Method.GET))
    }

    private func handleRequest<T: Decodable>(request: URLRequest) -> Single<T> {
        return Single<T>.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, response, requestError in
                guard let response = response as? HTTPURLResponse else {
                    single(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }

                guard let data = data else {
                    single(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
                    return
                }

                switch response.statusCode {
                case 200:
                    do {
                        let items = try JSONDecoder().decode(T.self, from: data)
                        single(.success(items))
                    } catch {
                        single(.failure(error))
                    }
                default:
                    if let error = APIError(rawValue: response.statusCode) {
                        single(.failure(error))
                    } else {
                        single(.failure(APIError.unrecognized))
                    }
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
