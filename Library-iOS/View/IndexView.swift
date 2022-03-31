//
//  IndexView.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import SwiftUI

struct IndexView: View {
    @StateObject private var viewModel: IndexViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: IndexViewModel())
    }
    
    var body: some View {
        List(self.viewModel.itemList, id: \.self) { content in
            switch content {
            case "ImageLoader":
                NavigationLink(destination: ImagePickerView()) {
                    Text(content)
                }
            case "FilePicker":
                NavigationLink(destination: FilePickerView()) {
                    Text(content)
                }
            case "FaceID":
                NavigationLink(destination: FaceIDView()) {
                    Text(content)
                }
            default:
                NavigationLink(destination: Text("Show Detail Here...")) {
                    Text(content)
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Library-iOS")
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}

extension IndexView {
    @MainActor class IndexViewModel: ObservableObject {
        @Published var itemList: Array<String> = [String]()

        init() {
            if let configDic = Bundle.main.getPlist(name: "config") {
                if let indexInfo = configDic["index_info"] as? [String] {
                    self.itemList = indexInfo
                }
            }
        }
    }
}
