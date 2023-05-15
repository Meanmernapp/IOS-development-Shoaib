//
//  EarthQuackModel.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import Foundation

struct EarthQuacks : Codable {

    let id : Int?
    let provider_name : String?
    let created : String?
    let updated : String?
    let type : String?
    let net : String?
    let external_id : String?
    let title : String?
    let mag : Double?
    let magtype : String?
    let depth : Double?
    let longitude : Double?
    let latitude : Double?
    let location : String?
    let country_code : String?
    let country : String?
    let region : String?
    let city : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case provider_name = "provider_name"
        case created = "created"
        case updated = "updated"
        case type = "type"
        case net = "net"
        case external_id = "external_id"
        case title = "title"
        case mag = "mag"
        case magtype = "magtype"
        case depth = "depth"
        case longitude = "longitude"
        case latitude = "latitude"
        case location = "location"
        case country_code = "country_code"
        case country = "country"
        case region = "region"
        case city = "city"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        provider_name = try values.decodeIfPresent(String.self, forKey: .provider_name)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        net = try values.decodeIfPresent(String.self, forKey: .net)
        external_id = try values.decodeIfPresent(String.self, forKey: .external_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        mag = try values.decodeIfPresent(Double.self, forKey: .mag)
        magtype = try values.decodeIfPresent(String.self, forKey: .magtype)
        depth = try values.decodeIfPresent(Double.self, forKey: .depth)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        city = try values.decodeIfPresent(String.self, forKey: .city)
    }

}

struct EarthQuackModel : Codable {
    let code : Int?
    let content : EarthQuackContentData?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        content = try values.decodeIfPresent(EarthQuackContentData.self, forKey: .content)
    }

}

struct EarthQuackContentData : Codable {
    let earthquakes : [EarthquakesData]?
    let pagination : PaginationData?

    enum CodingKeys: String, CodingKey {

        case earthquakes = "earthquakes"
        case pagination = "pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        earthquakes = try values.decodeIfPresent([EarthquakesData].self, forKey: .earthquakes)
        pagination = try values.decodeIfPresent(PaginationData.self, forKey: .pagination)
    }

}


struct EarthquakesData : Codable {
    let id : Int?
    let created : String?
    let type : String?
    let title : String?
    let mag : Double?
    let magtype : String?
    let depth : Double?
    let longitude : Double?
    let latitude : Double?
    let country_code : String?
    let country : String?
    let region : String?
    let city : String?
    var distance : Double?
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case created = "created"
        case type = "type"
        case title = "title"
        case mag = "mag"
        case magtype = "magtype"
        case depth = "depth"
        case longitude = "longitude"
        case latitude = "latitude"
        case country_code = "country_code"
        case country = "country"
        case region = "region"
        case city = "city"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        mag = try values.decodeIfPresent(Double.self, forKey: .mag)
        magtype = try values.decodeIfPresent(String.self, forKey: .magtype)
        depth = try values.decodeIfPresent(Double.self, forKey: .depth)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        city = try values.decodeIfPresent(String.self, forKey: .city)
    }

}

struct PaginationData : Codable {
    let page : Int?
    let pageSize : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case pageSize = "pageSize"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
