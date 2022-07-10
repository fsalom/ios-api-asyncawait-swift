import Foundation

enum AuthError: Error {
    case missingToken
    case missingExpiresIn
    case badRequest
    case tokenNotFound
}

actor AuthManager {
    private var refreshTask: Task<String, Error>?

    // MARK: - getAccesToken - return accessToken or error
    func getAccesToken() async throws -> String? {
        guard let accessToken = Cache.get(stringFor: .accessToken) else {
            throw AuthError.missingToken
        }
        return accessToken
    }

    // MARK: - isValid - return if access token is still valid or thrwo an error
    func isValid() async throws -> Bool {
        guard let expires = Calendar.current.date(byAdding: .second, value: Cache.get(intFor: .expiresIn), to: Date()) else {
            throw AuthError.missingExpiresIn
        }
        return expires > Date() ? true : false
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    func validToken() async throws -> String {
        if let handle = refreshTask {
            return try await handle.value
        }
        let isValid = try await isValid()
        if isValid {
            guard let accessToken = try await getAccesToken() else {
                throw AuthError.missingToken
            }
            return accessToken
        }
        return try await refreshToken()
    }

    // MARK: - refreshToken - create a task and call refreshToken if needed
    func refreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            guard let refreshToken = Cache.get(stringFor: .refreshToken) else {
                throw AuthError.tokenNotFound
            }
            return try await refresh(with: refreshToken)
        }
        self.refreshTask = task
        return try await task.value
    }

    // MARK: - authenticate - call to login service
    func authenticate(with parameters: [String: Any]) async throws -> String {
        do {
            let token = try await Network.shared.load(endpoint: AuthEndpoint.login(parameters).endpoint, of: TokenDTO.self)
            save(this: token)
            return token.accessToken
        } catch let error {
            Log.thisError(error)
            throw AuthError.badRequest
        }
    }

    // MARK: - save - save token data
    func save(this token: TokenDTO) {
        Cache.set(.accessToken, token.accessToken)
        Cache.set(.refreshToken, token.refreshToken)
        Cache.set(.expiresIn, token.expiresIn)
    }

    // MARK: - refresh - call API for refreshToken
    func refresh(with refreshToken: String) async throws -> String {
        do {
            let parameters: [String: Any] = [
                "refresh_token": refreshToken
            ]
            let token = try await Network.shared.load(endpoint: AuthEndpoint.refreshToken(parameters).endpoint, of: TokenDTO.self)
            save(this: token)
            return token.accessToken
        } catch let error {
            Log.thisError(error)
            Cache.clear()
            throw AuthError.badRequest
        }
    }
}
