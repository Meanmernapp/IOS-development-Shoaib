//
//  NotificationModel.swift
//  Earth Quacks
//
//  Created by Shoaib on 14/04/2023.
//

import Foundation

struct NotificationModelData : Codable {
    let code : Int?
    let content : Content?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        content = try values.decodeIfPresent(Content.self, forKey: .content)
    }

}

struct Content : Codable {
    let point : Point?

    enum CodingKeys: String, CodingKey {

        case point = "point"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        point = try values.decodeIfPresent(Point.self, forKey: .point)
    }

}

struct Point : Codable {
    let id : Int?
    let account_id : Int?
    let account_device_id : Int?
    let point_latitude : String?
    let point_longitude : String?
    let point_radius : Int?
    let earthquake_magnitude_from : Int?
    let earthquake_magnitude_to : Int?
    let earthquake_depth_from : String?
    let earthquake_depth_to : String?
    let date_created : String?
    let date_updated : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case account_id = "account_id"
        case account_device_id = "account_device_id"
        case point_latitude = "point_latitude"
        case point_longitude = "point_longitude"
        case point_radius = "point_radius"
        case earthquake_magnitude_from = "earthquake_magnitude_from"
        case earthquake_magnitude_to = "earthquake_magnitude_to"
        case earthquake_depth_from = "earthquake_depth_from"
        case earthquake_depth_to = "earthquake_depth_to"
        case date_created = "date_created"
        case date_updated = "date_updated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        account_id = try values.decodeIfPresent(Int.self, forKey: .account_id)
        account_device_id = try values.decodeIfPresent(Int.self, forKey: .account_device_id)
        point_latitude = try values.decodeIfPresent(String.self, forKey: .point_latitude)
        point_longitude = try values.decodeIfPresent(String.self, forKey: .point_longitude)
        point_radius = try values.decodeIfPresent(Int.self, forKey: .point_radius)
        earthquake_magnitude_from = try values.decodeIfPresent(Int.self, forKey: .earthquake_magnitude_from)
        earthquake_magnitude_to = try values.decodeIfPresent(Int.self, forKey: .earthquake_magnitude_to)
        earthquake_depth_from = try values.decodeIfPresent(String.self, forKey: .earthquake_depth_from)
        earthquake_depth_to = try values.decodeIfPresent(String.self, forKey: .earthquake_depth_to)
        date_created = try values.decodeIfPresent(String.self, forKey: .date_created)
        date_updated = try values.decodeIfPresent(String.self, forKey: .date_updated)
    }

}

struct DeviceModelData : Codable {
    let code : Int?
    let content : ContentData?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        content = try values.decodeIfPresent(ContentData.self, forKey: .content)
    }

}

struct ContentData : Codable {
    let id : Int?
    let store_platform_id : Int?
    let device_id : String?
    let device_type : String?
    let device_model : String?
    let device_manufacturer : String?
    let device_locale : String?
    let device_timezone : String?
    let os_name : String?
    let os_version : String?
    let date_created : String?
    let date_updated : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case store_platform_id = "store_platform_id"
        case device_id = "device_id"
        case device_type = "device_type"
        case device_model = "device_model"
        case device_manufacturer = "device_manufacturer"
        case device_locale = "device_locale"
        case device_timezone = "device_timezone"
        case os_name = "os_name"
        case os_version = "os_version"
        case date_created = "date_created"
        case date_updated = "date_updated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        store_platform_id = try values.decodeIfPresent(Int.self, forKey: .store_platform_id)
        device_id = try values.decodeIfPresent(String.self, forKey: .device_id)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        device_model = try values.decodeIfPresent(String.self, forKey: .device_model)
        device_manufacturer = try values.decodeIfPresent(String.self, forKey: .device_manufacturer)
        device_locale = try values.decodeIfPresent(String.self, forKey: .device_locale)
        device_timezone = try values.decodeIfPresent(String.self, forKey: .device_timezone)
        os_name = try values.decodeIfPresent(String.self, forKey: .os_name)
        os_version = try values.decodeIfPresent(String.self, forKey: .os_version)
        date_created = try values.decodeIfPresent(String.self, forKey: .date_created)
        date_updated = try values.decodeIfPresent(String.self, forKey: .date_updated)
    }

}

//MARK: - Push Token

struct PushTokenData : Codable {
    let code : Int?
    let content : pushTokenContentData?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        content = try values.decodeIfPresent(pushTokenContentData.self, forKey: .content)
    }

}

struct pushTokenContentData : Codable {
    let account_device_id : Int?
    let push_token : String?
    let one_signal_player_id : String?
    let date_created : String?
    let date_updated : String?
    let id : Int?

    enum CodingKeys: String, CodingKey {

        case account_device_id = "account_device_id"
        case push_token = "push_token"
        case one_signal_player_id = "one_signal_player_id"
        case date_created = "date_created"
        case date_updated = "date_updated"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account_device_id = try values.decodeIfPresent(Int.self, forKey: .account_device_id)
        push_token = try values.decodeIfPresent(String.self, forKey: .push_token)
        one_signal_player_id = try values.decodeIfPresent(String.self, forKey: .one_signal_player_id)
        date_created = try values.decodeIfPresent(String.self, forKey: .date_created)
        date_updated = try values.decodeIfPresent(String.self, forKey: .date_updated)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}
