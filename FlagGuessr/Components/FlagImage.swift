//
//  FlagImage.swift
//  FlagGuessr
//
//  Created by Lorenzo Ilardi on 07/04/25.
//

import SwiftUI

struct FlagImage: View {
    let resourceName: String
    
    var body: some View {
        Image(resourceName)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 20)
    }
}

#Preview {
    FlagImage(resourceName: "Italy")
}
