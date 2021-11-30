//
//  Optional+Extensions.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import UIKit

// MARK: - EmptyValueRepresentable
protocol EmptyValueRepresentable {
    static var emptyValue: Self { get }
}

// MARK: - String+EmptyValueRepresentable
extension String: EmptyValueRepresentable {
    static var emptyValue: String { return "" }
}

// MARK: - Array+EmptyValueRepresentable
extension Array: EmptyValueRepresentable {
    static var emptyValue: [Element] { return [] }
}

// MARK: - ArraySlice+EmptyValueRepresentable
extension ArraySlice: EmptyValueRepresentable {
    static var emptyValue: ArraySlice { return [] }
}

// MARK: - Set+EmptyValueRepresentable
extension Set: EmptyValueRepresentable {
    static var emptyValue: Set<Element> { return Set() }
}

// MARK: - Dictionary+EmptyValueRepresentable
extension Dictionary: EmptyValueRepresentable {
    static var emptyValue: [Key: Value] { return [:] }
}

// MARK: - Optional+EmptyValueRepresentable
extension Optional where Wrapped: EmptyValueRepresentable {
    /// Returns unwrapped value if optional is not nil; returns predefined empty value otherwise.
    var orEmpty: Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.emptyValue
        }
    }
}

// MARK: - Optional+Bool
extension Optional where Wrapped == Bool {
    
    /// Returns unwrapped value if optional is not nil; returns true otherwise.
    var orTrue: Bool {
        guard let self = self else { return true }
        
        return self
    }
    
    /// Returns unwrapped value if optional is not nil; returns false otherwise.
    var orFalse: Bool {
        guard let self = self else { return false }
        
        return self
    }
    
    /// Checks whether unwrapped value is equal to given optional's unwrapped value.
    /// - Parameter bool: Bool? to compare
    /// - Returns: True if unwrapped Bool? value is equal to given Bool?'s unwrapped value; returns false otherwise.
    func isEqualTo(_ bool: Bool?) -> Bool {
        guard let self = self, let bool = bool else { return false }
        
        return self == bool
    }
}

// MARK: - Optional+Helpers
extension Optional {
    
    struct FoundNilWhileUnwrappingError: Error { }
    
    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw FoundNilWhileUnwrappingError()
        }
    }
}
