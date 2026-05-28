
//  DetailView.swift
//  DrLicesingExamPsy
//
//  Created by NohJaisung on 11/17/23.
//

import SwiftUI
import Observation

struct DetailView: View {
    
    @State var question: Question //변경 하지 마시오
    @State private var showQuestions: EditMode = .active
    @State  var showDetails = false
    @State var selectedRows   = Set<Q.ID>()
    @State var memoText: String = ""
    @Binding var stared: Bool
    @Binding  var presentInspector: Bool
    
    //   @Environment(ApplicationData.self) private var appData
    @Environment(\.modelContext) var dbContext
    //    @Binding var rootIsActive : Bool
    
    
    var body: some View {
        
        //  let choicedBefore = question.choice
        //  let answerMessage = isCorrect ? "맞았습니다" : "틀렸습니다"
        NavigationStack{
            
            VStack {
                ScrollView {
                    //  Text(question.year)
                    Text("\(question.year)년(\(question.id)) \n \(question.main)")
                    
                        .padding( )
                        .textSelection(.disabled)
                        .background(.background.secondary, in : .rect(cornerRadius: 20))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                }
                
                
                List(question.q.sorted(), selection: $selectedRows){
                    Text("\($0.q)")
                } .environment(\.editMode, $showQuestions)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(10)
                
                    .navigationDestination(isPresented: $showDetails ) {
                        List() {  ResultView(question: question,  stared: $stared, sequenceOfProblem: 1) }
                        
                        //    AnswerView(question: question, memoText: $memoText, stared: $stared,  selectedRows: $selectedRows)
                    
                
            
        }
        .background(.background.secondary, in : .rect(cornerRadius: 20))
        
    }
            
            
            .onAppear(perform: {
                presentInspector = false
                memoText = question.memo
                stared = question.stared
                for i in question.choice{
                    selectedRows.insert(i)}
            })
            
            
        }.navigationTitle("문제")
            .toolbar {
                Spacer()
                Button(action:  {
                    showDetails = true
                    
                //    answerListOfQuestion.removeAll()
                  //  resultListOfQuestion.append(question)
                    let selected  = selectedRows.sorted()
                    let isCorrect = selected == question.answer
                    question.choice = selected
                    
                 //   buttonDisabled =  selectedRows.isEmpty ? false : true
                    if selectedRows.isEmpty  {
                        question.solved = 0
                        //   question.choice = []
                    } else {
                        question.solved  =  isCorrect ? 1 : 2
                    }
                    
                    //  Image(systemName: "checkmark.circle.fill")
                }, label: {
                    Image(systemName: "mail")
                        .imageScale(.large)
                    Text("제출")
                }) .buttonStyle(.borderedProminent)
                    .sensoryFeedback(
                        .impact(weight: .heavy, intensity: 0.9), trigger: showDetails )
                
            }
    }
}





