//
//  SearchView.swift
//  ReleaseDate
//
//  Created by Pete Connor on 3/25/20.
//  Copyright © 2020 Pete Connor. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var services = Services()
    
    var body: some View {
        NavigationView {
                VStack {
                TextField("", text: $services.query, onCommit: services.load)
                List(services.shows) { show in
                    VStack (alignment: .leading) {
                        NavigationLink(destination: DetailView(detailServices: DetailServices(showID: show.id, poster_path: show.poster_path, vote_average: show.vote_average), name: show.name ?? "")) {
                        Text(show.name ?? "")
                            Text(show.overview ?? "")
                            Text("Rating: \(show.vote_average, specifier: "%.1f")")
                            
                        }.onAppear()
                    }
                }
            }
            .navigationBarTitle("Search Shows")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
