import SwiftUI


struct KeyWordView: View {
    
    @State private var showPopoverKeyWord: Bool = false
    @State private var keyWord: String = ""
    @Binding var question: Question
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
 
        VStack {
            HStack {
                Button("취소") {
                    
                    dismiss()
                }.padding(.trailing)
                    .foregroundColor(.red)
                    .padding()
                
                
                Button("저장") {
                    if keyWord.trimmingCharacters(in: .whitespaces).isEmpty {
                        
                    } else {
                        question.subject.append(keyWord.trimmingCharacters(in: .whitespaces))
                    }
                    dismiss()
                }.padding(.trailing)
                    .foregroundColor(.blue)
                    .padding()
                Spacer()
            }
            HStack {
                Image(systemName: "key.horizontal")
                    .padding(.leading, 20.0)
                TextField("키워드", text: $keyWord)
                    .autocorrectionDisabled(true)
                    .padding(8)
                    .presentationDetents([.medium])
            }}
        }
}
 

