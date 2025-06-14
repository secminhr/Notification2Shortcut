//
//  N2SPredicates.swift
//  N2SPredicates
//
//  Created by secminhr on 2025/6/15.
//

import Foundation


nonisolated public func Equals<T>(keyPath: KeyPath<T, String>, str: String) -> Predicate<T> {
    Predicate {
        PredicateExpressions.Equal(
            lhs: PredicateExpressions.KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: keyPath),
            rhs: PredicateExpressions.Value(str)
        )
    }
}
