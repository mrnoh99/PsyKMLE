


import SwiftUI

struct IndividualExamView: View, Equatable {
    @Environment(\.dismiss) var dismiss
    @State var question: Question //변경 하지 마시오
    @State var selectedRows   = Set<Q.ID>()
    @Binding var answerListOfQuestion  : [Question]
    @Binding var resultListOfQuestion : [Question]
    @State private var buttonDisabled  = false
    @Binding var presentInspector : Bool
    var sequenceOfProblem: Int = 0
  //  @Binding var problemIsNotOnSet  : Bool
    
    var body:
    some View {
        
        
        @State var answerBranch = question.q.sorted()
        
            Text("\(sequenceOfProblem). \(question.main)")
                .multilineTextAlignment(.leading)
                .lineSpacing(10)
                .textSelection(.disabled)
                .background(.background.secondary, in : .rect(cornerRadius: 20))
            
            ForEach(answerBranch) { item in
                HStack {
                    Text(item.q)
                    Image(systemName: selectedRows.contains(item.id) ? "checkmark.circle.fill" : "circle")}
                .onTapGesture {
                    if selectedRows.contains(item.id){
                        selectedRows.remove(item.id)
                    } else {
                        selectedRows.insert(item.id)
                    }
                    
                }.disabled(buttonDisabled)
                    .multilineTextAlignment(.leading)
                // .lineSpacing(10)
            }
        
        
            VStack {
                Button(action: {
                    answerListOfQuestion.removeAll()
                    resultListOfQuestion.append(question)
                    let selected  = selectedRows.sorted()
                    let isCorrect = selected == question.answer
                    question.choice = selected
                    
                    buttonDisabled =  selectedRows.isEmpty ? false : true
                    if selectedRows.isEmpty  {
                        question.solved = 0
                        //   question.choice = []
                    } else {
                        question.solved  =  isCorrect ? 1 : 2
                    }
                    
                    //   print (question.answer.description)
                    
                }, label: {
                    Image(systemName:  "mail") .symbolRenderingMode(.multicolor)
                    HStack {
                        Text("제출")}
                }).disabled(buttonDisabled)
                    .sensoryFeedback(
                        .impact(weight: .heavy, intensity: 0.9), trigger: selectedRows )
                    .symbolEffect(.appear, isActive: buttonDisabled)
                    .buttonStyle(.borderedProminent)
                    .springLoadingBehavior(.enabled)
                    .sensoryFeedback(
                        .impact(weight: .heavy, intensity: 0.9), trigger: buttonDisabled )
                    .symbolEffect(.bounce, value: buttonDisabled)
                    .scaleEffect(1.0 )
                  .scrollIndicators(.hidden)
                
                
            }
              .scrollIndicators(.hidden)
        }
    
    static func == (lhs: IndividualExamView, rhs: IndividualExamView) -> Bool {
        return lhs.question.id == rhs.question.id
    }
}
        
        
    

