//
//  AddNewRecordView.swift
//  HealthApp
//
//  Created by Eric Li on 18/11/2023.
//

import SwiftUI

struct AddNewRecordView: View {
    var body: some View {
        ZStack{
            Color.gray
                .opacity(0.2)
                .frame(height: 150)
                .cornerRadius(30)
            Image(systemName: "plus.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    AddNewRecordView()
}
