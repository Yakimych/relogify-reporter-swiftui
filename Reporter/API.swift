// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AddResultMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation addResult($communityName: String!, $player1Name: String!, $player2Name: String!, $date: timestamptz!, $player1Goals: Int!, $player2Goals: Int!, $extraTime: Boolean!) {
      insert_results(objects: [{community: {data: {name: $communityName}, on_conflict: {constraint: communities_name_key, update_columns: [name]}}, date: $date, player1: {data: {name: $player1Name, community: {data: {name: $communityName}, on_conflict: {constraint: communities_name_key, update_columns: [name]}}}, on_conflict: {constraint: players_name_communityId_key, update_columns: [name]}}, player2: {data: {name: $player2Name, community: {data: {name: $communityName}, on_conflict: {constraint: communities_name_key, update_columns: [name]}}}, on_conflict: {constraint: players_name_communityId_key, update_columns: [name]}}, player2goals: $player2Goals, player1goals: $player1Goals, extratime: $extraTime}]) {
        __typename
        returning {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "addResult"

  public var communityName: String
  public var player1Name: String
  public var player2Name: String
  public var date: String
  public var player1Goals: Int
  public var player2Goals: Int
  public var extraTime: Bool

  public init(communityName: String, player1Name: String, player2Name: String, date: String, player1Goals: Int, player2Goals: Int, extraTime: Bool) {
    self.communityName = communityName
    self.player1Name = player1Name
    self.player2Name = player2Name
    self.date = date
    self.player1Goals = player1Goals
    self.player2Goals = player2Goals
    self.extraTime = extraTime
  }

  public var variables: GraphQLMap? {
    return ["communityName": communityName, "player1Name": player1Name, "player2Name": player2Name, "date": date, "player1Goals": player1Goals, "player2Goals": player2Goals, "extraTime": extraTime]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("insert_results", arguments: ["objects": [["community": ["data": ["name": GraphQLVariable("communityName")], "on_conflict": ["constraint": "communities_name_key", "update_columns": ["name"]]], "date": GraphQLVariable("date"), "player1": ["data": ["name": GraphQLVariable("player1Name"), "community": ["data": ["name": GraphQLVariable("communityName")], "on_conflict": ["constraint": "communities_name_key", "update_columns": ["name"]]]], "on_conflict": ["constraint": "players_name_communityId_key", "update_columns": ["name"]]], "player2": ["data": ["name": GraphQLVariable("player2Name"), "community": ["data": ["name": GraphQLVariable("communityName")], "on_conflict": ["constraint": "communities_name_key", "update_columns": ["name"]]]], "on_conflict": ["constraint": "players_name_communityId_key", "update_columns": ["name"]]], "player2goals": GraphQLVariable("player2Goals"), "player1goals": GraphQLVariable("player1Goals"), "extratime": GraphQLVariable("extraTime")]]], type: .object(InsertResult.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(insertResults: InsertResult? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "insert_results": insertResults.flatMap { (value: InsertResult) -> ResultMap in value.resultMap }])
    }

    /// insert data into the table: "results"
    public var insertResults: InsertResult? {
      get {
        return (resultMap["insert_results"] as? ResultMap).flatMap { InsertResult(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "insert_results")
      }
    }

    public struct InsertResult: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["results_mutation_response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("returning", type: .nonNull(.list(.nonNull(.object(Returning.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(returning: [Returning]) {
        self.init(unsafeResultMap: ["__typename": "results_mutation_response", "returning": returning.map { (value: Returning) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// data of the affected rows by the mutation
      public var returning: [Returning] {
        get {
          return (resultMap["returning"] as! [ResultMap]).map { (value: ResultMap) -> Returning in Returning(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Returning) -> ResultMap in value.resultMap }, forKey: "returning")
        }
      }

      public struct Returning: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["results"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int) {
          self.init(unsafeResultMap: ["__typename": "results", "id": id])
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
      }
    }
  }
}

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

public final class GetPlayersForCommunitiesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getPlayersForCommunities($communityNames: [String!]!) {
      players(where: {community: {name: {_in: $communityNames}}}) {
        __typename
        id
        name
        community {
          __typename
          id
          name
        }
      }
    }
    """

  public let operationName: String = "getPlayersForCommunities"

  public var communityNames: [String]

  public init(communityNames: [String]) {
    self.communityNames = communityNames
  }

  public var variables: GraphQLMap? {
    return ["communityNames": communityNames]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("players", arguments: ["where": ["community": ["name": ["_in": GraphQLVariable("communityNames")]]]], type: .nonNull(.list(.nonNull(.object(Player.selections))))),
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
          GraphQLField("community", type: .nonNull(.object(Community.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String, community: Community) {
        self.init(unsafeResultMap: ["__typename": "players", "id": id, "name": name, "community": community.resultMap])
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

      /// An object relationship
      public var community: Community {
        get {
          return Community(unsafeResultMap: resultMap["community"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "community")
        }
      }

      public struct Community: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["communities"]

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
          self.init(unsafeResultMap: ["__typename": "communities", "id": id, "name": name])
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
}
