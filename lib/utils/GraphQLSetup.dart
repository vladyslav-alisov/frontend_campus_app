import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLSetup{

  static final GraphQLSetup _setup = GraphQLSetup._internal();

  factory GraphQLSetup() {
    return _setup;
  }

  GraphQLSetup._internal();

  static const String str_uriGraphQL = 'https://campusapplication.herokuapp.com/graphql';
  static HttpLink link = HttpLink(str_uriGraphQL);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }
}