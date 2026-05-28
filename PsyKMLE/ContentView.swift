//  ContentView.swift
//  DrLicesingExamPsy
//
//  Created by NohJaisung on 11/17/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @Environment(\.modelContext) var dbContext
 
    
    var body: some View {
       
        let endDate = endDateReturn(year: 2050, month: 12 , day: 1)
        
        if Date() < endDate  {
         
            QuestionView()
        } else {
            
            EndView()
        }
       
        }
    }

func endDateReturn (year: Int, month: Int, day: Int) -> Date {
    let myDateComponents = DateComponents(year: year, month: month, day: day)
    if  let date =    Calendar.current.date(from: myDateComponents)  {
      return date
        
  } else {
      
          
      return Date()
      
  }
}



#Preview {
    QuestionView()
}


