//
//  DetailView.swift
//  ReleaseDate
//
//  Created by Pete Connor on 3/31/20.
//  Copyright © 2020 Pete Connor. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var detailServices: DetailServices
    @Environment(\.managedObjectContext) var managedObjectContext

    var name: String
    
    var body: some View {
        VStack {
            Text("Detail View")
            Image(uiImage: detailServices.showImage)
                .resizable()
            Text(name)
            Text("\(detailServices.showID)")
            Text("Rating: \(detailServices.vote_average, specifier: "%.1f")")
            Button(action: {
                let show = MyShow(context: self.managedObjectContext)
                show.name = self.name
                show.id = Int32(self.detailServices.showID)
                do {
                    try self.managedObjectContext.save()
                    print("save successful")
                } catch {
                    "error saving managedObjectContext in detail view"
                }
            }) { Text("Insert example show")
            }

        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailServices: DetailServices(showID: 55555, poster_path: "jjj", vote_average: 0.0), name: "Name")
    }
}
