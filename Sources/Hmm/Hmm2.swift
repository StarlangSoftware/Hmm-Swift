//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 27.08.2020.
//

import Foundation
import Math

public class Hmm2<State : Hashable, Symbol : Hashable> : Hmm<State, Symbol>{
    
    var __pi: Matrix = Matrix(row: 0, col: 0)

    /**
    A constructor of Hmm2 class which takes a Set of states, an array of observations (which also
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
    calculatePi calculates the prior probability matrix (initial probabilities for each state combinations)
    from a set of observations. For each observation, the function extracts the first and second states in
    that observation.  Normalizing the counts of the pair of states returns us the prior probabilities for each
    pair of states.

    - Parameter observations : A set of observations used to calculate the prior probabilities.
    */
    override func calculatePi(observations: [[State]]) {
        self.__pi = Matrix(row: self.stateCount, col: self.stateCount)
        for observation in observations{
            let first : Int = self.stateIndexes[observation[0]]!
            let second : Int = self.stateIndexes[observation[1]]!
            self.__pi.increment(rowNo: first, colNo: second)
        }
        self.__pi.columnWiseNormalize()
    }

    /**
    calculateTransitionProbabilities calculates the transition probabilities matrix from each state to another
    state. For each observation and for each transition in each observation, the function gets the states.
    Normalizing the counts of the three of states returns us the transition probabilities.

    - Parameter observations : A set of observations used to calculate the transition probabilities.
    */
    override func calculateTransitionProbabilities(observations: [[State]]) {
        self.transitionProbabilities = Matrix(row: self.stateCount * self.stateCount, col: self.stateCount)
        for current in observations{
            for j in 0..<current.count - 2{
                let fromIndex1 : Int = self.stateIndexes[current[j]]!
                let fromIndex2 : Int = self.stateIndexes[current[j + 1]]!
                let toIndex : Int = self.stateIndexes[current[j + 2]]!
                self.transitionProbabilities.increment(rowNo: fromIndex1 * self.stateCount + fromIndex2, colNo: toIndex)
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
            result.add(x: self.safeLog(x: self.transitionProbabilities.getValue(rowNo: i * self.stateCount + column
                / self.stateCount, colNo: column % self.stateCount)))
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
        let gamma : Matrix = Matrix(row: sequenceLength, col: self.stateCount * self.stateCount)
        let phi : Matrix = Matrix(row: sequenceLength, col: self.stateCount * self.stateCount)
        let qs : Vector = Vector(size: sequenceLength, x: 0)
        let emission1 : Symbol = s[0]
        let emission2 : Symbol = s[1]
        for i in 0..<self.stateCount{
            for j in 0..<self.stateCount{
                let observationLikelihood : Double = self.states[i].getEmitProb(symbol: emission1) * self.states[j].getEmitProb(symbol: emission2)
                gamma.setValue(rowNo: 1, colNo: i * self.stateCount + j, value: self.safeLog(x: self.__pi.getValue(rowNo: i, colNo: j)) +
                    self.safeLog(x: observationLikelihood))
            }
        }
        for t in 2..<sequenceLength{
            let emission : Symbol = s[t]
            for j in 0..<self.stateCount * self.stateCount{
                let current : Vector = self.__logOfColumn(column: j)
                let previous : Vector = gamma.getRowVector(row: t - 1).skipVector(mod: self.stateCount, value: j / self.stateCount)
                current.addVector(v: previous)
                let maxIndex : Int = current.maxIndex()
                let observationLikelihood : Double = self.states[j % self.stateCount].getEmitProb(symbol: emission)
                gamma.setValue(rowNo: t, colNo: j, value: current.getValue(index: maxIndex) + self.safeLog(x: observationLikelihood))
                phi.setValue(rowNo: t, colNo: j, value: Double(maxIndex * self.stateCount + j / self.stateCount))
            }
        }
        qs.setValue(index: sequenceLength - 1, value: Double(gamma.getRowVector(row: sequenceLength - 1).maxIndex()))
        result.insert(self.states[Int(qs.getValue(index: sequenceLength - 1)) % self.stateCount].getState(), at: 0)
        var i : Int = sequenceLength - 2
        while i >= 1{
            qs.setValue(index: i, value: phi.getValue(rowNo: i + 1, colNo: Int(qs.getValue(index: i + 1))))
            result.insert(self.states[Int(qs.getValue(index: i)) % self.stateCount].getState(), at: 0)
            i = i - 1
        }
        result.insert(self.states[Int(qs.getValue(index: 1)) / self.stateCount].getState(), at: 0)
        return result
    }

}
