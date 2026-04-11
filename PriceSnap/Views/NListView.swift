//
//  NListView.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-05.
//

import SwiftUI

struct NListView: View {
    var body: some View {
        VStack() {
            Text("app_title")
                .font(.largeTitle)
            HStack{
                Text("product")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Spacer()
                Text("🔁")
                    .font(.headline)
                    .frame(width: 50, alignment: .center)
                Text("🕒")
                    .font(.headline)
                    .frame(width: 50, alignment: .center)
                Spacer()
                Text("Max")
                    .font(.headline)
                    .frame(width: 45, alignment: .center)
                Text("Min")
                    .font(.headline)
                    .frame(width: 45, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            List{
                
            }
        }
        .padding()
    }
}

#Preview {
    NListView()
}
