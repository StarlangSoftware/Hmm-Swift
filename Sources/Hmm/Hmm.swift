//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 26.08.2020.
//

import Foundation
import Math
import DataStructure

public class Hmm<State : Hashable, Symbol : Hashable>{
    
    var transitionProbabilities: Matrix = Matrix(size: 0)
    var stateIndexes: [State: Int] = [:]
    var states: [HmmState<State, Symbol>] = []
    var stateCount: Int = 0

    func calculatePi(observations: [[State]]) {
        preconditionFailure("This method must be overridden")
    }
    
    func calculateTransitionProbabilities(observations: [[State]]) {
        preconditionFailure("This method must be overridden")
    }
    /**
    A constructor of Hmm class which takes a Set of states, an array of observations (which also
    consists of an array of states) and an array of instances (which also consists of an array of emitted symbols).
    The constructor initializes the state array with the set of states and uses observations and emitted symbols
    to calculate the emission probabilities for those states.

    - Parameters:
        - states : A Set of states, consisting of all possible states for this problem.
        - observations : An array of instances, where each instance consists of an array of states.
        - emittedSymbols : An array of instances, where each instance consists of an array of symbols.
    */
    public init(states: Set<State>, observations: [[State]], emittedSymbols: [[Symbol]]){
        var i : Int = 0
        self.stateCount = states.count
        for state in states{
            self.stateIndexes[state] = i
            i = i + 1
        }
        self.calculatePi(observations: observations)
        for state in states{
            let emissionProbabilities : [Symbol: Double] = self.calculateEmissionProbabilities(state: state, observations: observations, emittedSymbols: emittedSymbols)
            self.states.append(HmmState(state: state, emissionProbabilities: emissionProbabilities))
        }
        self.calculateTransitionProbabilities(observations: observations)
    }

    /**
    calculateEmissionProbabilities calculates the emission probabilities for a specific state. The method takes the
    state, an array of observations (which also consists of an array of states) and an array of instances (which also
    consists of an array of emitted symbols).

    - Parameters:
        - states : A Set of states, consisting of all possible states for this problem.
        - observations : An array of instances, where each instance consists of an array of states.
        - emittedSymbols : An array of instances, where each instance consists of an array of symbols.

    - Returns: A HashMap. Emission probabilities for a single state. Contains a probability for each symbol emitted.
    */
    public func calculateEmissionProbabilities(state: State, observations: [[State]], emittedSymbols: [[Symbol]]) -> [Symbol: Double]{
        let counts : CounterHashMap<Symbol> = CounterHashMap()
        var emissionProbabilities : [Symbol: Double] = [:]
        for i in 0..<observations.count{
            for j in 0..<observations[i].count{
                let currentState : State = observations[i][j]
                let currentSymbol : Symbol = emittedSymbols[i][j]
                if currentState == state{
                    counts.put(key: currentSymbol)
                }
            }
        }
        let total : Double = Double(counts.sumOfCounts())
        for symbol in counts.keys(){
            emissionProbabilities[symbol] = Double(counts.count(key: symbol)) / total
        }
        return emissionProbabilities
    }
        

    /**
    safeLog calculates the logarithm of a number. If the number is less than 0, the logarithm is not defined, therefore
    the function returns -Infinity.

    - Parameter x : Input number

    - Returns: The logarithm of x. If x < 0 return -infinity.
    */
    func safeLog(x: Double) -> Double{
        if x <= 0{
            return -1000
        } else{
            return log(x)
        }
    }

}
