//  Copyright © 2021 Poikile Creations. All rights reserved.

import Combine
import Foundation

class DiscogsSearch: ObservableObject {

    @Published private(set) var results = [SearchResult]()

    private var discogsClient = DiscogsClient()

    func search(terms: String) -> Future<[SearchResult], Error> {
        discogsClient.search(for: terms) { (artists, error) in
            <#code#>
        }
    }

    struct SearchResult {

    }

}
