enum PlaceType: CaseIterable, Codable {
    case all
    case paseos
    case resto
    case cafe
    case bar
    case pizzeria
    case exchange

    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "all": self = .all
        case "paseos": self = .paseos
        case "resto": self = .resto
        case "cafe", "café": self = .cafe
        case "bar": self = .bar
        case "pizzería", "pizzeria": self = .pizzeria
        case "exchange": self = .exchange
        default: return nil
        }
    }

    var rawValue: String {
        switch self {
        case .all: return "All"
        case .paseos: return "Paseos"
        case .resto: return "Resto"
        case .cafe: return "Cafe"
        case .bar: return "Bar"
        case .pizzeria: return "Pizzería"
        case .exchange: return "exchange"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = PlaceType(rawValue: value) ?? .all
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
