//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 26.08.2020.
//

import Foundation

class HmmState<State, Symbol : Hashable>{
    
    var emissionProbabilities: [Symbol: Double]
    var state: State

    /**
    A constructor of HmmState class which takes a State and emission probabilities as inputs and
    initializes corresponding class variable with these inputs.

    - Parameters:
        - state : Data for this state.
        - emissionProbabilities : Emission probabilities for this state
    */
    public init(state: State, emissionProbabilities: [Symbol: Double]){
        self.state = state
        self.emissionProbabilities = emissionProbabilities
    }

    /**
    Accessor method for the state variable.

    - Returns: state variable.
    */
    public func getState() -> State{
        return self.state
    }

    /**
    getEmitProb method returns the emission probability for a specific symbol.

    - Parameter symbol : Symbol for which the emission probability will be get.

    - Returns: Emission probability for a specific symbol.
    */
    public func getEmitProb(symbol: Symbol) -> Double{
        if self.emissionProbabilities[symbol] != nil{
            return self.emissionProbabilities[symbol]!
        } else {
            return 0.0
        }
    }

}
