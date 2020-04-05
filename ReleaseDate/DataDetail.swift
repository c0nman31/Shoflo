//
//  DataDetail.swift
//  ReleaseDate
//
//  Created by Pete Connor on 4/1/20.
//  Copyright © 2020 Pete Connor. All rights reserved.
//

import SwiftUI

struct DetailResponse: Decodable {
    //backdrop_path to make it look good?
    let first_air_date: String
    let id: Int
    let in_production: Bool
    let name: String
    let next_episode_to_air: Next_Episode_To_Air //todo - this might not be a list
    let networks: [Networks]
    let number_of_seasons: Int
    var origin_country: [String]
    let overview: String
    let popularity: Float
    let status: String
    let poster_path: String?
}

struct Next_Episode_To_Air: Decodable {
    let air_date: String
    let episode_number: Int
    let season_number: Int
}

struct Networks: Decodable {
    let name: String //todo - this might have more than one name, list of networks. need to test/find a show that has multiple.
}

class DetailServices: ObservableObject {
    @Published var showDetail: DetailResponse?
    @Published var showImage = UIImage()
    var showID: Int
    var poster_path: String?

    init(showID: Int, poster_path: String?) {
        self.showID = showID
        self.poster_path = poster_path
        load()
        getImage(path: poster_path ?? "placeholder")
    }
    
    func load() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            guard let url = URL(string: "https://api.themoviedb.org/3/tv/100757?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    if let d = data {
                        let response = try JSONDecoder().decode(DetailResponse.self, from: d)
                        DispatchQueue.main.async {
                            self.showDetail = response
                            
                            }
                    } else {
                    print("No Data")
                    }
                } catch {
                    print(error)
                }

            }
            .resume()
        }
    
    func getImage(path: String) {
        if let imagePath = path as? String {
            print(1)
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w500" + imagePath)
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL!) {
                    print(2)
                    if let image = UIImage(data: data) {
                        print(3)
                        DispatchQueue.main.async {
                            print(4)
                            self?.showImage = image
                        }
                    }
                }
            }
            print(5)
            //I've tried returning a UIImage, which doesn't work.
        }
    }
}