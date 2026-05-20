import SwiftUI
import Observation
import SwiftData

@Model
class Question: Identifiable, Comparable, Equatable {
    var  id : String =     ""
    var year: String = ""
    var intro: String = ""
    var main: String = ""
    var q: [Q] = []
    var answer: [String] = []
    var subject: [String] = []
    var classifi: String = ""
    var choice:[String] = []
    var solved: Int = 0
    var memo: String = ""
    var stared : Bool = false
    var comment1: String = ""
    var comment2 : String = ""
    var isOnSet : Bool  = false
    
    
    init( id: String, year: String, intro: String, main: String, q:[Q] , answer:[String], subject: [String], classifi: String, choice: [String], solved: Int, memo: String, stared: Bool, comment1: String, comment2: String, isOnSet: Bool){
        self.id = id
        self.year = year
        self.intro = intro
        self.main = main
        self.q = q
        self.answer = answer
        self.subject = subject
        self.classifi = classifi
        self.choice = choice
        self.solved = solved
        self.memo = memo
        self.stared = stared
        self.comment1 = comment1
        self.comment2 = comment2
        self.isOnSet = isOnSet
       
    }
    
    static func <(lhs: Question, rhs: Question) -> Bool {
        return lhs.id < rhs.id
    }
    static func >(lhs: Question, rhs: Question) -> Bool {
        return lhs.id > rhs.id
    }
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
    
}

@Model
class Q: Identifiable, Comparable {
    
    var  id : String =     ""
    var q = ""
    init(id: String, q: String){
        self.id = id
        self.q = q
    }
    static func <(lhs: Q, rhs: Q) -> Bool {
        return lhs.id < rhs.id
    }
    
}

