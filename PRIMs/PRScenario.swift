//
//  PRScenario.swift
//  PRIMs
//
//  Created by Niels Taatgen on 5/12/15.
//  Copyright (c) 2015 Niels Taatgen. All rights reserved.
//

import Foundation

class PRScenario {
    /// What are the possible screens in the scenario?
    var screens: [String:PRScreen] = [:]
    /// What are the different inputs (variable bindings for objects)
    var inputs: [String:[String:String]] = [:]
    /// What is the current queue of inputs
    var trials: [String] = []
    /// What is the current screen?
    var currentScreen: PRScreen? = nil
    /// What is the start screen at the beginning of the scenario?
    var startScreen: PRScreen! = nil
    /// When is the next event due?
    var nextEventTime: Double? = nil
    /// Current inputs
    var currentInput: [String:String] = [:]
    var inputMappingForTrace: [String] {
        get {
            var mapping = ["Void","Void","Void","Void","Void"]
            for i in 0..<min(5,currentInput.count) {
                let index = "?\(i)"
                mapping[i] = self.currentInput[index]!
            }
            return mapping
        }
    }
    func goStart(model: Model) {
        if !inputs.isEmpty && trials.isEmpty {
            for (name,_) in inputs {
                trials.append(name)
            }
            for i in 0..<trials.count {
                let randomPos = Int(arc4random_uniform(UInt32(trials.count)))
                let tmp = trials[randomPos]
                trials[randomPos] = trials[i]
                trials[i] = tmp
            }
        }
        if !inputs.isEmpty {
            currentInput = inputs[trials.removeAtIndex(0)]!
        } else {
            currentInput = [:]
        }
        currentScreen = startScreen
        currentScreen!.start()
        if currentScreen!.timeTransition != nil {
            if currentScreen!.timeAbsolute {
                nextEventTime =  model.startTime + currentScreen!.timeTransition!
            } else {
                nextEventTime = model.time + currentScreen!.timeTransition!
            }
        }
    }
    
    func makeSubstitutions(chunk: Chunk) -> Chunk {
        for (slot,value) in chunk.slotvals {
            if let substitution = currentInput[value.description] {
                chunk.setSlot(slot, value: substitution)
            }
        }
        return chunk
    }
    
    func current(model: Model) -> Chunk {
        return makeSubstitutions(currentScreen!.current(model))
    }
    
    func doAction(model: Model, action: String?, par1: String?) -> Chunk? {
        if action == nil { return nil }
        if let transition = currentScreen!.transitions[action!] {
            currentScreen = transition
            currentScreen!.start()
            if currentScreen!.timeTransition != nil {
                if currentScreen!.timeAbsolute {
                    nextEventTime = model.startTime + currentScreen!.timeTransition!
                } else {
                    nextEventTime = model.time + currentScreen!.timeTransition!
                }
            } else {
                nextEventTime = nil
            }
        } else {
            switch action! {
            case "focusfirst":
                currentScreen!.focusFirst()
            case "focusnext":
                currentScreen!.focusNext()
            case "focusdown":
                currentScreen!.focusDown()
            case "focusup":
                currentScreen!.focusUp()
            default: return nil
            }
        }
        let chunk = makeSubstitutions(currentScreen!.current(model))
        //        println("Doing action \(action) resulting in \(chunk)")
        return chunk
    }

    func makeTimeTransition(model: Model) {
        currentScreen = currentScreen!.timeTarget!
        currentScreen!.start()
        if currentScreen!.timeTransition != nil {
            if currentScreen!.timeAbsolute {
                nextEventTime = model.startTime + currentScreen!.timeTransition!
            } else {
                nextEventTime = model.time + currentScreen!.timeTransition!
            }
        } else {
            nextEventTime = nil
        }
        let chunk = currentScreen!.current(model)
        model.buffers["input"] = chunk
        model.addToTrace("Switching to screen \(currentScreen!.name), next switch is \(nextEventTime)")
        
    }
    
}