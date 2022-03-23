//
//  FaceIDViewController.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import SwiftUI

struct FaceIDViewController: View {
    @StateObject private var viewModel = FaceIDViewModel()
    
    var body: some View {
        Button {
            viewModel.doCheckFaceIDFunction()
        } label: {
            Text(viewModel.buttonText).bold()
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }        
}

struct FaceIDViewController_Previews: PreviewProvider {
    static var previews: some View {
        FaceIDViewController()
    }
}
