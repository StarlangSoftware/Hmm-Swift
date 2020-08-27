//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 27.08.2020.
//

import Foundation
import Math

public class Hmm1<State : Hashable, Symbol : Hashable> : Hmm<State, Symbol>{
    
    private var __pi: Vector = Vector(size: 0, x: 0)

    /**
    A constructor of Hmm1 class which takes a Set of states, an array of observations (which also
    consists of an array of states) and an array of instances (which also consists of an array of emitted symbols).
    The constructor calls its super method to calculate the emission probabilities for those states.

    - Parameters:
        - states : A Set of states, consisting of all possible states for this problem.
        - observations : An array of instances, where each instance consists of an array of states.
        - emittedSymbols : An array of instances, where each instance consists of an array of symbols.
    */
    public override init(states: Set<State>, observations: [[State]], emittedSymbols: [[Symbol]]){
        super.init(states: states, observations: observations, emittedSymbols: emittedSymbols)
    }

    /**
    calculatePi calculates the prior probability vector (initial probabilities for each state) from a set of
    observations. For each observation, the function extracts the first state in that observation. Normalizing the
    counts of the states returns us the prior probabilities for each state.

    - Parameter observations : A set of observations used to calculate the prior probabilities.
    */
    override func calculatePi(observations: [[State]]) {
        self.__pi = Vector(size: self.stateCount, x: 0.0)
        for observation in observations{
            let indexOfState : Int = self.stateIndexes[observation[0]]!
            self.__pi.addValue(index: indexOfState, value: 1.0)
        }
        self.__pi.l1Normalize()
    }

    /**
    calculateTransitionProbabilities calculates the transition probabilities matrix from each state to another
    state. For each observation and for each transition in each observation, the function gets the states.
    Normalizing the counts of the pair of states returns us the transition probabilities.

    - Parameter observations : A set of observations used to calculate the transition probabilities.
    */
    override func calculateTransitionProbabilities(observations: [[State]]) {
        self.transitionProbabilities = Matrix(row: self.stateCount, col: self.stateCount)
        for current in observations{
            for j in 0..<current.count - 1{
                let fromIndex : Int = self.stateIndexes[current[j]]!
                let toIndex : Int = self.stateIndexes[current[j + 1]]!
                self.transitionProbabilities.increment(rowNo: fromIndex, colNo: toIndex)
            }
        }
        self.transitionProbabilities.columnWiseNormalize()
    }

    /**
    logOfColumn calculates the logarithm of each value in a specific column in the transition probability matrix.

    - Parameter column : Column index of the transition probability matrix.

    - Returns: A vector consisting of the logarithm of each value in the column in the transition probability matrix.
    */
    func __logOfColumn(column: Int) -> Vector{
        let result : Vector = Vector(size: 0, x: 0)
        for i in 0..<self.stateCount{
            result.add(x: self.safeLog(x: self.transitionProbabilities.getValue(rowNo: i, colNo: column)))
        }
        return result
    }

    /**
    viterbi calculates the most probable state sequence for a set of observed symbols.

    - Parameter s : A set of observed symbols.

    - Returns: The most probable state sequence as an {@link ArrayList}.
    */
    public func viterbi(s: [Symbol]) -> [State]{
        var result : [State] = []
        let sequenceLength : Int = s.count
        let gamma : Matrix = Matrix(row: sequenceLength, col: self.stateCount)
        let phi : Matrix = Matrix(row: sequenceLength, col: self.stateCount)
        let qs : Vector = Vector(size: sequenceLength, x: 0)
        var emission : Symbol = s[0]
        for i in 0..<self.stateCount{
            let observationLikelihood : Double = self.states[i].getEmitProb(symbol: emission)
            gamma.setValue(rowNo: 0, colNo: i, value: self.safeLog(x: self.__pi.getValue(index: i)) + self.safeLog(x: observationLikelihood))
        }
        for t in 1..<sequenceLength{
            emission = s[t]
            for j in 0..<self.stateCount{
                let tempArray : Vector = self.__logOfColumn(column: j)
                tempArray.addVector(v: gamma.getRowVector(row: t - 1))
                let maxIndex : Int = tempArray.maxIndex()
                let observationLikelihood : Double = self.states[j].getEmitProb(symbol: emission)
                gamma.setValue(rowNo: t, colNo: j, value: tempArray.getValue(index: maxIndex) + self.safeLog(x: observationLikelihood))
                phi.setValue(rowNo: t, colNo: j, value: Double(maxIndex))
            }
        }
        qs.setValue(index: sequenceLength - 1, value: Double(gamma.getRowVector(row: sequenceLength - 1).maxIndex()))
        result.insert(self.states[Int(qs.getValue(index: sequenceLength - 1))].getState(), at: 0)
        var i : Int = sequenceLength - 2
        while i >= 0{
            qs.setValue(index: i, value: phi.getValue(rowNo: i + 1, colNo: Int(qs.getValue(index: i + 1))))
            result.insert(self.states[Int(qs.getValue(index: i))].getState(), at: 0)
            i = i - 1
        }
        return result
    }
    
}
