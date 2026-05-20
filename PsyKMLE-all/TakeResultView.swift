import SwiftUI

struct TakeResultView:  View {
    @ObservationIgnored    var allQuestions : [Question] = []
    @Binding  var answerListOfQuestion : [Question]
    @Binding var resultListOfQuestion : [Question]
    @Binding var stared : Bool
    // @Binding var memoText : String
    
    
    var body: some View {
        
        
        VStack{
            
            /*  Text("모아풀기  문제수: \(QuestionView.numberOfSelectedProblems(arrayInUsing:  allQuestions))").multilineTextAlignment(.center)
             .padding(.top, 5) */
            
            Text (percentInString())
            
            List(allQuestions) { question in
                if  let i = allQuestions.firstIndex(of: question)   {    ResultView(question: question,  stared: $stared, sequenceOfProblem: i+1)
                }
            } .scrollIndicators(.hidden)
            
        }
    }
    
    
    
    func percentInString() -> String {
        
        let total = numberOfSelected()
        if total != 0 {
            let wrong = numberOfWrong()
            let  correct = numberOfCorrect()
            //  let unsolved = numberOfUnsolved()
            let  ratioCorrect = Double(correct)/Double(total) * 100
            let  ratioWrong = Double(wrong)/Double(total) * 100
            let  formatedCorrectRatio = String(format: "%.0f", ratioCorrect)
            let  formatedWrongRatio = String(format: "%.0f", ratioWrong)
            let  message =  "총문제수:\(numberOfSelected()) 정답:\(numberOfCorrect())(\(formatedCorrectRatio)%) 오답:\(numberOfWrong())(\(formatedWrongRatio)% 미제출:\(numberOfUnsolved()))  "
            return message
        }
        else {
            return ""
        }
    }
    
    
    
    func numberOfCorrect() -> Int {
        var   i = 0
        for question in allQuestions {
            if question.choice == question.answer {
                i += 1
            }
        }
        return i
    }
    
    func numberOfWrong() -> Int {
        var   i = 0
        for question in allQuestions {
            if question.choice != question.answer {
                i += 1
            }
        }
        return i
    }
    
    func numberOfSelected() -> Int {
        return allQuestions.count
        
    }
    func numberOfUnsolved() -> Int {
        var   i = 0
        for question in allQuestions {
            if question.solved == 0 {
                i += 1
            }
        }
        return i
    }
    
    
    
}
