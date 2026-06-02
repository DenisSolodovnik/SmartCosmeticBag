//
//  EventPathBuilder.swift
//  LoggerModule
//
//  Created by Денис Солодовник on 01.06.2026.
//


public class EventPathBuilder {

    var eventsChain: [String] = []
    var configuration: [AnyHashable: Any] = [:]

    public init() {}

    public func create() -> Self {
        eventsChain.append("create")
        return self
    }
    public func open() -> Self {
        eventsChain.append("open")
        return self
    }
    public func delete() -> Self {
        eventsChain.append("delete")
        return self
    }
    public func tap() -> Self {
        eventsChain.append("tap")
        return self
    }

    public func screen(_ name: String) -> Self {
        eventsChain.append("screen")
        configuration["screen"] = name
        return self
    }
    public func button(_ name: String) -> Self {
        eventsChain.append("button")
        configuration["button"] = name
        return self
    }
    public func category(_ name: String, hasImage: Bool? = nil) -> Self {
        eventsChain.append("category")
        configuration["category_name"] = name
        configuration["category_image"] = hasImage
        return self
    }
    public func product(_ name: String, numberOfImages: Int? = nil) -> Self {
        eventsChain.append("product")
        configuration["product"] = name
        configuration["product_images"] = numberOfImages
        return self
    }

    func buildPath() -> String {
        eventsChain.joined(separator: "/")
    }
}
