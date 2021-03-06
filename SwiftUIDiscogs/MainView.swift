//  Copyright © 2020 Poikile Creations. All rights reserved.

import SwiftUI

struct MainView: View {

    @State private var searchTerms: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 20.0) {
            TextField("Search Discogs", text: $searchTerms)
            Text("Searching for \(searchTerms)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
