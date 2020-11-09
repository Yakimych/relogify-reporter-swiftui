// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetPlayersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getPlayers($communityName: String!) {
      players(where: {community: {name: {_eq: $communityName}}}) {
        __typename
        id
        name
      }
    }
    """

  public let operationName: String = "getPlayers"

  public var communityName: String

  public init(communityName: String) {
    self.communityName = communityName
  }

  public var variables: GraphQLMap? {
    return ["communityName": communityName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("players", arguments: ["where": ["community": ["name": ["_eq": GraphQLVariable("communityName")]]]], type: .nonNull(.list(.nonNull(.object(Player.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(players: [Player]) {
      self.init(unsafeResultMap: ["__typename": "query_root", "players": players.map { (value: Player) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "players"
    public var players: [Player] {
      get {
        return (resultMap["players"] as! [ResultMap]).map { (value: ResultMap) -> Player in Player(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Player) -> ResultMap in value.resultMap }, forKey: "players")
      }
    }

    public struct Player: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["players"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String) {
        self.init(unsafeResultMap: ["__typename": "players", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}
