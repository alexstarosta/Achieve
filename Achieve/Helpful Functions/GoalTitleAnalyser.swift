//
//  GoalTitleAnalyser.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import Foundation

let numbers = "1234567890"

enum PSchedule {
    case daily
    case weekly
    case monthly
    case none
}

enum PTimeframe {
    case minutes
    case hours
    case days
    case weeks
    case months
    case none
}

struct phraseToPScheduleRelation {
    
    var phrase: String
    var relation: PSchedule
    
}

struct phraseToPTimeframeRelation {
    
    var phrase: String
    var relation: PTimeframe
    
}

let scheduleArray: [phraseToPScheduleRelation] = [
    phraseToPScheduleRelation(phrase: "daily", relation: .daily),
    phraseToPScheduleRelation(phrase: "every day", relation: .daily),
    phraseToPScheduleRelation(phrase: "everyday", relation: .daily),
    phraseToPScheduleRelation(phrase: "per day", relation: .daily),
    phraseToPScheduleRelation(phrase: "a day", relation: .daily),
    
    phraseToPScheduleRelation(phrase: "weekly", relation: .weekly),
    phraseToPScheduleRelation(phrase: "every week", relation: .weekly),
    phraseToPScheduleRelation(phrase: "per week", relation: .weekly),
    phraseToPScheduleRelation(phrase: "a week", relation: .weekly),
    
    phraseToPScheduleRelation(phrase: "monthly", relation: .monthly),
    phraseToPScheduleRelation(phrase: "every month", relation: .monthly),
    phraseToPScheduleRelation(phrase: "per month", relation: .monthly),
    phraseToPScheduleRelation(phrase: "a month", relation: .monthly)
]

let timeframeArray: [phraseToPTimeframeRelation] = [
    phraseToPTimeframeRelation(phrase: "minutes", relation: .minutes),
    phraseToPTimeframeRelation(phrase: "minute", relation: .minutes),
    phraseToPTimeframeRelation(phrase: "min", relation: .minutes),
    
    phraseToPTimeframeRelation(phrase: "hours", relation: .hours),
    phraseToPTimeframeRelation(phrase: "hour", relation: .hours),
    phraseToPTimeframeRelation(phrase: "hr", relation: .hours),
    
    phraseToPTimeframeRelation(phrase: "days", relation: .days),
    phraseToPTimeframeRelation(phrase: "day", relation: .days),
    
    phraseToPTimeframeRelation(phrase: "weeks", relation: .weeks),
    phraseToPTimeframeRelation(phrase: "week", relation: .weeks),
    phraseToPTimeframeRelation(phrase: "wk", relation: .weeks),
    
    phraseToPTimeframeRelation(phrase: "months", relation: .months),
    phraseToPTimeframeRelation(phrase: "month", relation: .months),
    phraseToPTimeframeRelation(phrase: "mnth", relation: .months),
]

let nextSyn: [String] = [
"next", "following", "upcoming",
]

struct possibleValues {
    
    var pReps: Int
    var pTimeframeAmount: Int
    var pTimeframeType: PTimeframe
    var pSchedule: PSchedule
    
}

struct numberAndIndex{
    
    var foundNumber: Int
    var relatedIndex: Int
    
}

func onlyNumbers (_ string:String) -> Bool {
    
    let userString = string
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userString))
    
}

func containNum (_ string:String) -> Bool {

    let decimalCharacters = CharacterSet.decimalDigits

    let decimalRange = string.rangeOfCharacter(from: decimalCharacters)

    if decimalRange != nil {
        return true
    }
    return false
}

func stringContainsNext (_ title:String) -> Bool {
    
    for syn in nextSyn {
        if title.contains(syn) {
            return true
        } else {
            return false
        }
    }
    return false
}

func findNumbers (_ titleArray:[String]) -> [numberAndIndex] {
    
    var titleArray = titleArray
    
    var foundNumbers: [numberAndIndex] = []
    
    for word in 0...titleArray.count-1 {
        if titleArray[word].hasSuffix("k") && containNum(titleArray[word]) {
            titleArray[word].removeLast()
            if onlyNumbers(titleArray[word]) {
                let newNum = Int(titleArray[word])! * 1000
                titleArray[word] = "\(newNum)"
            }
        }
    }
    
    for word in 0...titleArray.count-1 {
        if titleArray[word].hasSuffix("pm") || titleArray[word].hasSuffix("am") && containNum(titleArray[word]) {
            titleArray[word].removeLast()
            titleArray[word].removeLast()
            if onlyNumbers(titleArray[word]) {
                let newNum = Int(titleArray[word])!
                titleArray[word] = "\(newNum)"
            }
        }
    }
    
    for word in 0...titleArray.count-1 {
        for number in numbers {
            if titleArray[word].contains(number) {
                if onlyNumbers(titleArray[word]) {
                    foundNumbers.append(numberAndIndex(foundNumber: Int(titleArray[word])! , relatedIndex: word))
                    break
                }
            }
        }
    }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
        
    for word in 0...titleArray.count-1 {
        let number = formatter.number(from: titleArray[word])
        if number == nil {
            continue
        }
        foundNumbers.append(numberAndIndex(foundNumber: number as! Int, relatedIndex: word))
    }
    
    if !foundNumbers.isEmpty {
        for number in 0...foundNumbers.count - 1 {
            if titleArray[titleArray.count - 1] != "\(foundNumbers[number].foundNumber)" {
                if titleArray.count > 3 && foundNumbers[number].relatedIndex + 1 < titleArray.count-1 {
                    if titleArray[foundNumbers[number].relatedIndex + 1] == "hundred" {
                        foundNumbers[number].foundNumber = foundNumbers[number].foundNumber * 100
                    } else if titleArray[foundNumbers[number].relatedIndex + 1] == "thousand" {
                        foundNumbers[number].foundNumber = foundNumbers[number].foundNumber * 1000
                    }
                }
            }
        }
    }
    
    if foundNumbers.count > 2 {
        foundNumbers.removeAll()
    }
    
    return foundNumbers
}

func findValuesInTitle (_ title: String) -> possibleValues {
    
    var values = possibleValues(pReps: 0, pTimeframeAmount: 0, pTimeframeType: .none, pSchedule: .none)
    
    let lowercasetitle = title.lowercased()
    let titleArray: [String] = lowercasetitle.components(separatedBy: " ")
    let numbersInTitle = findNumbers(titleArray)
    
    var usedIndex = -1
    
    if stringContainsNext(lowercasetitle) {
        
        for number in numbersInTitle {
            for possibleTimeframe in timeframeArray {
                for syn in nextSyn {
                    if titleArray[titleArray.count - 1] != "\(number.foundNumber)" && titleArray[0] != "\(number.foundNumber)" {
                        if titleArray[number.relatedIndex - 1] == syn && titleArray[number.relatedIndex + 1] == possibleTimeframe.phrase {
                            values.pTimeframeAmount = number.foundNumber
                            values.pTimeframeType = possibleTimeframe.relation
                            usedIndex = number.relatedIndex
                        }
                    }
                }
            }
        }
        
    } else {
        
        for number in numbersInTitle {
            for possibleTimeframe in timeframeArray {
                if titleArray[titleArray.count - 1] != "\(number.foundNumber)" {
                    if titleArray.count > 3 && number.relatedIndex + 1 < titleArray.count-1 {
                        if titleArray[number.relatedIndex + 1] == possibleTimeframe.phrase {
                            values.pTimeframeAmount = number.foundNumber
                            values.pTimeframeType = possibleTimeframe.relation
                            usedIndex = number.relatedIndex
                        }
                    }
                }
            }
        }
        
    }
    
    
    for number in numbersInTitle {
        if number.relatedIndex != usedIndex {
            values.pReps = number.foundNumber
        }
    }
    
    for possibleSchedule in scheduleArray {
        if lowercasetitle.contains(possibleSchedule.phrase) {
            values.pSchedule = possibleSchedule.relation
        }
    }
    
    return values
    
}
