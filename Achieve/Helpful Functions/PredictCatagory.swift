//
//  predictCatagory.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import Foundation

struct titleToCatagoryRelation {
    
    let relationWords: [String]
    let goal: GoalCatagory
    var score = 0
    
}

let healthWords: [String] = [
"fit", "fitness", "active", "run", "walk", "exercise", "gym", "healthy", "meal", "meals", "sleep", "bed", "steps", "weight", "rest", "diet"
]

let educationWords: [String] = [
"learn", "career", "test", "mark", "marks", "school", "university", "collage", "education", "study", "math", "coding", "studies"
]

let financialWords: [String] = [
"financial", "money", "cash", "savings", "save", "bank", "funds", "stock", "invest", "investing", "dollars"
]

let relationsWords: [String] = [
"friends", "friend", "family", "mom", "dad", "brother", "sister", "love", "help", "understand", "partner", "girlfriend", "boyfriend", "wife", "husband"
]

let personalWords: [String] = [
"mental", "stress", "self", "inner", "within", "improve", "better", "find"
]

let socialWords: [String] = [
"friendly", "friends", "friend", "listen", "confident", "talk", "meet", "people"
]

let lifestyleWords: [String] = [
"plan", "trip", "vacation", "interest", "hobbies", "hobby", "passions", "passion", "lifestyle", "life"
]

var catagoryWordArray: [titleToCatagoryRelation] = [
    titleToCatagoryRelation(relationWords: healthWords, goal: .health),
    titleToCatagoryRelation(relationWords: educationWords, goal: .education),
    titleToCatagoryRelation(relationWords: financialWords, goal: .financial),
    titleToCatagoryRelation(relationWords: relationsWords, goal: .relations),
    titleToCatagoryRelation(relationWords: personalWords, goal: .personal),
    titleToCatagoryRelation(relationWords: socialWords, goal: .social),
    titleToCatagoryRelation(relationWords: lifestyleWords, goal: .lifestyle)
]

func predictCatagory (_ title:String) -> [GoalCatagory] {
    
    let lowercasetitle = title.lowercased()
    
    for relation in 0...catagoryWordArray.count-1 {
        catagoryWordArray[relation].score = 0
    }
    
    var catagoryRanking: [GoalCatagory] = []
    var totalscore = 0
    
    for relation in 0...catagoryWordArray.count-1 {
        for relatedWord in catagoryWordArray[relation].relationWords {
            if lowercasetitle.contains(relatedWord) {
                catagoryWordArray[relation].score += 1
                totalscore += 1
            }
        }
    }
    
    if totalscore != 0 {
        for relation in 0...catagoryWordArray.count-1 {
            if catagoryWordArray[relation].score > 0 {
                catagoryRanking.append(catagoryWordArray[relation].goal)
            }
        }
    }
    
    for relation in 0...catagoryWordArray.count-1 {
        if catagoryWordArray[relation].score == 0 {
            catagoryRanking.append(catagoryWordArray[relation].goal)
        }
    }
    
    catagoryRanking.append(.othercat)
    return catagoryRanking
}
