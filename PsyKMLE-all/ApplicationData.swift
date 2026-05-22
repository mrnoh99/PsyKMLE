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
    
    /// 앱에 포함된 최신 문제 내용을 반영한다. 사용자 진행 데이터는 유지한다.
    func applySeedContent(from seed: Question) {
        year = seed.year
        intro = seed.intro
        main = seed.main
        q = seed.q.map { Q(id: $0.id, q: $0.q) }
        answer = seed.answer
        subject = seed.subject
        classifi = seed.classifi
        comment1 = seed.comment1
        comment2 = seed.comment2
        isOnSet = seed.isOnSet
    }
    
}

enum QuestionSeedSync {
    @MainActor
    static func merge(into context: ModelContext, seeds: Set<Question>) throws {
        let existing = try context.fetch(FetchDescriptor<Question>())
        let existingByID = Dictionary(existing.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        
        var didChange = false
        for seed in seeds {
            if let stored = existingByID[seed.id] {
                stored.applySeedContent(from: seed)
                didChange = true
            } else {
                context.insert(seed)
                didChange = true
            }
        }
        
        if didChange {
            try context.save()
        }
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

