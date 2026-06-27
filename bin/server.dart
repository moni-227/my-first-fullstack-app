// // // import 'dart:convert';

// // // import 'package:postgres/postgres.dart';
// // // import 'package:shelf/shelf.dart';
// // // import 'package:shelf/shelf_io.dart' as io;
// // // import 'package:shelf_router/shelf_router.dart';
// // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // late Connection conn;

// // // Future<void> connectDB() async {
// // //   conn = await Connection.open(
// // //     Endpoint(
// // //       host: 'localhost',
// // //       port: 5432,
// // //       database: 'Input_Logs',
// // //       username: 'postgres',
// // //       password: 'postgres123',
// // //     ),
// // //     settings: ConnectionSettings(
// // //       sslMode: SslMode.disable,
// // //     ),
// // //   );

// // //   print("Connected to PostgreSQL");
// // // }

// // // Future<Map<String, dynamic>> loginUser(
// // //   String username,
// // //   String password,
// // // ) async {
// // //   final result = await conn.execute(
// // //     Sql.named(
// // //       '''
// // //       SELECT *
// // //       FROM users
// // //       WHERE username=@username
// // //       ''',
// // //     ),
// // //     parameters: {
// // //       'username': username.trim(),
// // //     },
// // //   );

// // //   if (result.isNotEmpty) {
// // //     final row = result.first;

// // //     String dbPassword = row[2].toString();

// // //     if (dbPassword == password) {
// // //       return {
// // //         "success": true,
// // //         "message": "Login successful",
// // //         "username": username,
// // //       };
// // //     }
// // //   }

// // //   return {
// // //     "success": false,
// // //     "message": "Invalid username or password",
// // //   };
// // // }

// // // Future<Map<String, dynamic>> insertMachineData(
// // //   String motorType,
// // //   String machineId,
// // //   String testId,
// // //   String operationName,
// // // ) async {
// // //   final result = await conn.execute(
// // //     Sql.named(
// // //       '''
// // //       INSERT INTO machine_data
// // //       (
// // //         motor_type,
// // //         machine_id,
// // //         test_id,
// // //         operation_name
// // //       )
// // //       VALUES
// // //       (
// // //         @motor_type,
// // //         @machine_id,
// // //         @test_id,
// // //         @operation_name
// // //       )
// // //       RETURNING *
// // //       '''
// // //     ),
// // //     parameters: {
// // //       "motor_type": motorType,
// // //       "machine_id": machineId,
// // //       "test_id": testId,
// // //       "operation_name": operationName,
// // //     },
// // //   );

// // //   return {
// // //     "success": true,
// // //     "record": result.first.toString(),
// // //   };
// // // }

// // // Future<void> main() async {
// // //   await connectDB();

// // //   final router = Router();

// // //   router.post('/login', (Request request) async {
// // //     try {
// // //       final body =
// // //           jsonDecode(await request.readAsString());

// // //       String username =
// // //           body['username']?.toString() ?? '';

// // //       String password =
// // //           body['password']?.toString() ?? '';

// // //       if (username.isEmpty || password.isEmpty) {
// // //         return Response(
// // //           400,
// // //           body: jsonEncode({
// // //             "message":
// // //                 "Username and Password required"
// // //           }),
// // //           headers: {
// // //             "Content-Type": "application/json"
// // //           },
// // //         );
// // //       }

// // //       final result =
// // //           await loginUser(username, password);

// // //       if (result["success"]) {
// // //         return Response.ok(
// // //           jsonEncode(result),
// // //           headers: {
// // //             "Content-Type": "application/json"
// // //           },
// // //         );
// // //       }

// // //       return Response(
// // //         401,
// // //         body: jsonEncode(result),
// // //         headers: {
// // //           "Content-Type": "application/json"
// // //         },
// // //       );
// // //     } catch (e) {
// // //       return Response.internalServerError(
// // //         body: jsonEncode({
// // //           "message": e.toString()
// // //         }),
// // //       );
// // //     }
// // //   });

// // //   router.post('/add-machine-data',
// // //       (Request request) async {
// // //     try {
// // //       final body =
// // //           jsonDecode(await request.readAsString());

// // //       String motorType =
// // //           body['motor_type']?.toString() ?? '';

// // //       String machineId =
// // //           body['machine_id']?.toString() ?? '';

// // //       String testId =
// // //           body['test_id']?.toString() ?? '';

// // //       String operationName =
// // //           body['operation_name']?.toString() ?? '';

// // //       if (motorType.isEmpty ||
// // //           machineId.isEmpty ||
// // //           testId.isEmpty ||
// // //           operationName.isEmpty) {
// // //         return Response(
// // //           400,
// // //           body: jsonEncode({
// // //             "message":
// // //                 "All fields are required"
// // //           }),
// // //           headers: {
// // //             "Content-Type": "application/json"
// // //           },
// // //         );
// // //       }

// // //       final result = await insertMachineData(
// // //         motorType,
// // //         machineId,
// // //         testId,
// // //         operationName,
// // //       );

// // //       return Response(
// // //         201,
// // //         body: jsonEncode(result),
// // //         headers: {
// // //           "Content-Type": "application/json"
// // //         },
// // //       );
// // //     } catch (e) {
// // //       return Response.internalServerError(
// // //         body: jsonEncode({
// // //           "message": e.toString()
// // //         }),
// // //       );
// // //     }
// // //   });

// // //   final handler = Pipeline()
// // //       .addMiddleware(corsHeaders())
// // //       .addMiddleware(logRequests())
// // //       .addHandler(router.call);

// // //   await io.serve(
// // //     handler,
// // //     '0.0.0.0',
// // //     3000,
// // //   );

// // //   print(
// // //     "Server running on http://localhost:3000",
// // //   );
// // // }




// // import 'dart:convert';

// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // late Connection conn;

// // Future<void> connectDB() async {
// //   conn = await Connection.open(
// //     Endpoint(
// //       host: 'localhost',
// //       port: 5432,
// //       database: 'Input_Logs',
// //       username: 'postgres',
// //       password: 'postgres123',
// //     ),
// //     settings: ConnectionSettings(
// //       sslMode: SslMode.disable,
// //     ),
// //   );

// //   print("Connected to PostgreSQL");
// // }

// // Future<Map<String, dynamic>> loginUser(
// //   String username,
// //   String password,
// // ) async {
// //   final result = await conn.execute(
// //     Sql.named(
// //       '''
// //       SELECT *
// //       FROM users
// //       WHERE username=@username
// //       ''',
// //     ),
// //     parameters: {
// //       'username': username.trim(),
// //     },
// //   );

// //   if (result.isNotEmpty) {
// //     final row = result.first;

// //     String dbPassword = row[2].toString();

// //     if (dbPassword == password) {
// //       return {
// //         "success": true,
// //         "message": "Login successful",
// //         "username": username,
// //       };
// //     }
// //   }

// //   return {
// //     "success": false,
// //     "message": "Invalid username or password",
// //   };
// // }

// // // Updated handler function signature to accept field1 and field2 parameters
// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType,
// //   String machineId,
// //   String testId,
// //   String operationName,
// //   String field1,
// //   String field2,
// // ) async {
// //   final result = await conn.execute(
// //     Sql.named(
// //       '''
// //       INSERT INTO machine_data
// //       (
// //         motor_type,
// //         machine_id,
// //         test_id,
// //         operation_name,
// //         field_1,
// //         field_2
// //       )
// //       VALUES
// //       (
// //         @motor_type,
// //         @machine_id,
// //         @test_id,
// //         @operation_name,
// //         @field_1,
// //         @field_2
// //       )
// //       RETURNING *
// //       '''
// //     ),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //     },
// //   );

// //   return {
// //     "success": true,
// //     "record": result.first.toString(),
// //   };
// // }

// // Future<void> main() async {
// //   await connectDB();

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(
// //           400,
// //           body: jsonEncode({"message": "Username and Password required"}),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       final result = await loginUser(username, password);

// //       if (result["success"]) {
// //         return Response.ok(
// //           jsonEncode(result),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       return Response(
// //         401,
// //         body: jsonEncode(result),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     } catch (e) {
// //       return Response.internalServerError(
// //         body: jsonEncode({"message": e.toString()}),
// //       );
// //     }
// //   });

// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? ''; // Captured Field 1
// //       String field2 = body['field_2']?.toString() ?? ''; // Captured Field 2

// //       if (motorType.isEmpty ||
// //           machineId.isEmpty ||
// //           testId.isEmpty ||
// //           operationName.isEmpty ||
// //           field1.isEmpty ||
// //           field2.isEmpty) {
// //         return Response(
// //           400,
// //           body: jsonEncode({"message": "All fields are required"}),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       final result = await insertMachineData(
// //         motorType,
// //         machineId,
// //         testId,
// //         operationName,
// //         field1,
// //         field2,
// //       );

// //       return Response(
// //         201,
// //         body: jsonEncode(result),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     } catch (e) {
// //       return Response.internalServerError(
// //         body: jsonEncode({"message": e.toString()}),
// //       );
// //     }
// //   });

// //   final handler = Pipeline()
// //       .addMiddleware(corsHeaders())
// //       .addMiddleware(logRequests())
// //       .addHandler(router.call);

// //   await io.serve(handler, '0.0.0.0', 3000);

// //   print("Server running on http://localhost:3000");
// // }





// // direct mqtt

// // import 'dart:convert';
// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Connection conn;
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. POSTGRESQL CONNECTION & OPERATIONS
// // // ==========================================
// // Future<void> connectDB() async {
// //   conn = await Connection.open(
// //     Endpoint(
// //       host: 'localhost',
// //       port: 5432,
// //       database: 'Input_Logs',
// //       username: 'postgres',
// //       password: 'postgres123',
// //     ),
// //     settings: ConnectionSettings(
// //       sslMode: SslMode.disable,
// //     ),
// //   );

// //   print("Connected to PostgreSQL");
// // }

// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final result = await conn.execute(
// //     Sql.named(
// //       '''
// //       SELECT *
// //       FROM users
// //       WHERE username=@username
// //       ''',
// //     ),
// //     parameters: {
// //       'username': username.trim(),
// //     },
// //   );

// //   if (result.isNotEmpty) {
// //     final row = result.first;
// //     String dbPassword = row[2].toString();

// //     if (dbPassword == password) {
// //       return {
// //         "success": true,
// //         "message": "Login successful",
// //         "username": username,
// //       };
// //     }
// //   }

// //   return {
// //     "success": false,
// //     "message": "Invalid username or password",
// //   };
// // }

// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType,
// //   String machineId,
// //   String testId,
// //   String operationName,
// //   String field1,
// //   String field2,
// // ) async {
// //   final result = await conn.execute(
// //     Sql.named(
// //       '''
// //       INSERT INTO machine_data
// //       (
// //         motor_type,
// //         machine_id,
// //         test_id,
// //         operation_name,
// //         field_1,
// //         field_2
// //       )
// //       VALUES
// //       (
// //         @motor_type,
// //         @machine_id,
// //         @test_id,
// //         @operation_name,
// //         @field_1,
// //         @field_2
// //       )
// //       RETURNING *
// //       '''
// //     ),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //     },
// //   );

// //   return {
// //     "success": true,
// //     "record": result.first.toString(),
// //   };
// // }

// // // ==========================================
// // // 2. MQTT BROKER PUBLISHER CONNECTION
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'dart_backend_publisher');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection exception: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // void publishMachineData(Map<String, dynamic> data) {
// //   const String topic = 'machine/metrics';
// //   final builder = MqttClientPayloadBuilder();
// //   builder.addString(jsonEncode(data));

// //   if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //     mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
// //     print('Published data to MQTT topic: $topic');
// //   } else {
// //     print('MQTT client not connected, skipping publish.');
// //   }
// // }

// // // ==========================================
// // // 3. MAIN SERVER ROUTING ENTRYPOINT
// // // ==========================================
// // Future<void> main() async {
// //   await connectDB();   // This will now resolve perfectly
// //   await connectMQTT(); // This will now resolve perfectly

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(
// //           400,
// //           body: jsonEncode({"message": "Username and Password required"}),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       final result = await loginUser(username, password);

// //       if (result["success"]) {
// //         return Response.ok(
// //           jsonEncode(result),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       return Response(
// //         401,
// //         body: jsonEncode(result),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     } catch (e) {
// //       return Response.internalServerError(
// //         body: jsonEncode({"message": e.toString()}),
// //       );
// //     }
// //   });

// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? ''; 
// //       String field2 = body['field_2']?.toString() ?? ''; 

// //       if (motorType.isEmpty ||
// //           machineId.isEmpty ||
// //           testId.isEmpty ||
// //           operationName.isEmpty ||
// //           field1.isEmpty ||
// //           field2.isEmpty) {
// //         return Response(
// //           400,
// //           body: jsonEncode({"message": "All fields are required"}),
// //           headers: {"Content-Type": "application/json"},
// //         );
// //       }

// //       // 1. Insert directly into Postgres 
// //       final result = await insertMachineData(
// //         motorType,
// //         machineId,
// //         testId,
// //         operationName,
// //         field1,
// //         field2,
// //       );

// //       // 2. Publish to MQTT Broker for MongoDB Ingestion
// //       publishMachineData({
// //         "motor_type": motorType,
// //         "machine_id": machineId,
// //         "test_id": testId,
// //         "operation_name": operationName,
// //         "field_1": field1,
// //         "field_2": field2,
// //         "timestamp": DateTime.now().toIso8601String()
// //       });

// //       return Response(
// //         201,
// //         body: jsonEncode(result),
// //         headers: {"Content-Type": "application/json"},
// //       );
// //     } catch (e) {
// //       return Response.internalServerError(
// //         body: jsonEncode({"message": e.toString()}),
// //       );
// //     }
// //   });

// //   final handler = Pipeline()
// //       .addMiddleware(corsHeaders())
// //       .addMiddleware(logRequests())
// //       .addHandler(router.call);

// //   await io.serve(handler, '0.0.0.0', 3000);

// //   print("Server running on http://localhost:3000");
// // }





// import 'dart:convert';
// import 'package:postgres/postgres.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';

// late Connection conn;
// late Connection listenConn; // Separate connection dedicated solely to LISTEN
// late MqttServerClient mqttClient;

// // ==========================================
// // 1. DATABASE CONNECTIVITY
// // ==========================================
// Future<void> connectDB() async {
//   // final endpoint = Endpoint(
//   //   host: 'localhost',
//   //   port: 5432,
//   //   database: 'Input_Logs',
//   //   username: 'postgres',
//   //   password: 'postgres123',
//   // );
  
//   final endpoint = Endpoint(
//   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
//   port: 5432,
//   database: 'neondb',
//   username: 'neondb_owner',
//   password: 'npg_mT9C4KeOaJVN',
// );

//   final settings = ConnectionSettings(sslMode: SslMode.require);

//   // Connection for executing normal queries
//   conn = await Connection.open(endpoint, settings: settings);
//   print("Connected to PostgreSQL (Query Client)");

//   // Persistent connection dedicated to receiving LISTEN events
//   listenConn = await Connection.open(endpoint, settings: settings);
//   print("Connected to PostgreSQL (Listen Client)");
// }

// // ==========================================
// // 2. MQTT CLIENT PUBLISHER
// // ==========================================
// Future<void> connectMQTT() async {
//   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
//   mqttClient.port = 1883;
//   mqttClient.logging(on: false);
//   mqttClient.keepAlivePeriod = 20;

//   try {
//     print('Connecting to MQTT Broker...');
//     await mqttClient.connect();
//     print('Connected to MQTT Broker successfully!');
//   } catch (e) {
//     print('MQTT Connection failure: $e');
//     mqttClient.disconnect();
//   }
// }

// // ==========================================
// // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // ==========================================
// // Future<void> startPostgresListenBridge() async {
// //   // Instruct Postgres to begin listening on our custom channel
// //   await listenConn.execute('LISTEN machine_channel');
// //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// //   // Stream listener that captures broadcasts continuously
// //   listenConn.channels['machine_channel'].listen((notification) {
// //     final String? payload = notification.payload;
    
// //     if (payload != null) {
// //       print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// //       // Forward directly over MQTT
// //       if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //         final builder = MqttClientPayloadBuilder();
// //         builder.addString(payload);

// //         mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //         print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //       } else {
// //         print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //       }
// //     }
// //   });
// // }


// // ==========================================
// // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // ==========================================
// Future<void> startPostgresListenBridge() async {
//   // Instruct Postgres to begin listening on our custom channel
//   await listenConn.execute('LISTEN machine_channel');
//   print("PostgreSQL background loop actively listening to channel: machine_channel");

//   // In postgres v3+, the notification stream yields String directly
//   listenConn.channels['machine_channel'].listen((String payload) {
//     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

//     // Forward directly over MQTT
//     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//       final builder = MqttClientPayloadBuilder();
//       builder.addString(payload);

//       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
//       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
//     } else {
//       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
//     }
//   });
// }

// // ==========================================
// // 4. BUSINESS LOGIC DATABASE QUERIES
// // ==========================================
// Future<Map<String, dynamic>> loginUser(String username, String password) async {
//   final result = await conn.execute(
//     Sql.named('SELECT * FROM users WHERE username=@username'),
//     parameters: {'username': username.trim()},
//   );

//   if (result.isNotEmpty) {
//     final row = result.first;
//     String dbPassword = row[2].toString();

//     if (dbPassword == password) {
//       return {"success": true, "message": "Login successful", "username": username};
//     }
//   }
//   return {"success": false, "message": "Invalid username or password"};
// }

// Future<Map<String, dynamic>> insertMachineData(
//   String motorType, String machineId, String testId, String operationName, String field1, String field2
// ) async {
//   final result = await conn.execute(
//     Sql.named('''
//       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
//       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
//       RETURNING *
//     '''),
//     parameters: {
//       "motor_type": motorType,
//       "machine_id": machineId,
//       "test_id": testId,
//       "operation_name": operationName,
//       "field_1": field1,
//       "field_2": field2,
//     },
//   );

//   return {"success": true, "record": result.first.toString()};
// }

// // ==========================================
// // 5. MAIN SERVICE DRIVER Entrypoint
// // ==========================================
// Future<void> main() async {
//   await connectDB();
//   await connectMQTT();
  
//   // Launch the asynchronous Listen -> Publish loop runner
//   startPostgresListenBridge(); 

//   final router = Router();

//   router.post('/login', (Request request) async {
//     try {
//       final body = jsonDecode(await request.readAsString());
//       String username = body['username']?.toString() ?? '';
//       String password = body['password']?.toString() ?? '';

//       if (username.isEmpty || password.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await loginUser(username, password);
//       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   router.post('/add-machine-data', (Request request) async {
//     try {
//       final body = jsonDecode(await request.readAsString());

//       String motorType = body['motor_type']?.toString() ?? '';
//       String machineId = body['machine_id']?.toString() ?? '';
//       String testId = body['test_id']?.toString() ?? '';
//       String operationName = body['operation_name']?.toString() ?? '';
//       String field1 = body['field_1']?.toString() ?? '';
//       String field2 = body['field_2']?.toString() ?? '';

//       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
//       }

//       // Perform standard SQL insert. The DB trigger executes the broadcast pipeline.
//       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);

//       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
//   await io.serve(handler, '0.0.0.0', 3000);
//   print("Server engine operational on http://localhost:3000");
// }



import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

late Connection conn;
late Connection listenConn; 
late MqttServerClient mqttClient;

// ==========================================
// 1. DATABASE CONNECTIVITY
// ==========================================
// Future<void> connectDB() async {
//   final endpoint = Endpoint(
//     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
//     port: 5432,
//     database: 'neondb',
//     username: 'neondb_owner',
//     password: 'npg_mT9C4KeOaJVN',
//   );

//   final settings = ConnectionSettings(sslMode: SslMode.require);

//   conn = await Connection.open(endpoint, settings: settings);
//   print("Connected to PostgreSQL (Query Client)");

//   listenConn = await Connection.open(endpoint, settings: settings);
//   print("Connected to PostgreSQL (Listen Client)");
// }

Future<void> connectDB() async {
  final endpoint = Endpoint(
    host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
    port: 5432,
    database: 'neondb',
    username: 'neondb_owner',
    password: 'npg_mT9C4KeOaJVN',
  );

  final settings = ConnectionSettings(sslMode: SslMode.require);

  bool connected = false;
  while (!connected) {
    try {
      conn = await Connection.open(endpoint, settings: settings);
      listenConn = await Connection.open(endpoint, settings: settings);
      print("Connected to PostgreSQL");
      connected = true;
    } catch (e) {
      print("DB connection failed, retrying in 3s: $e");
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}

// ==========================================
// 2. MQTT CLIENT PUBLISHER
// ==========================================
Future<void> connectMQTT() async {
  mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
  mqttClient.port = 1883;
  mqttClient.logging(on: false);
  mqttClient.keepAlivePeriod = 20;

  try {
    print('Connecting to MQTT Broker...');
    await mqttClient.connect();
    print('Connected to MQTT Broker successfully!');
  } catch (e) {
    print('MQTT Connection failure: $e');
    mqttClient.disconnect();
  }
}

// ==========================================
// 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// ==========================================
Future<void> startPostgresListenBridge() async {
  await listenConn.execute('LISTEN machine_channel');
  print("PostgreSQL background loop actively listening to channel: machine_channel");

  listenConn.channels['machine_channel'].listen((String payload) {
    print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);

      mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
      print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
    } else {
      print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
    }
  });
}

// ==========================================
// 4. BUSINESS LOGIC DATABASE QUERIES
// ==========================================
Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final result = await conn.execute(
    Sql.named('SELECT * FROM users WHERE username=@username'),
    parameters: {'username': username.trim()},
  );

  if (result.isNotEmpty) {
    final row = result.first;
    String dbPassword = row[2].toString();

    if (dbPassword == password) {
      return {"success": true, "message": "Login successful", "username": username};
    }
  }
  return {"success": false, "message": "Invalid username or password"};
}

Future<Map<String, dynamic>> insertMachineData(
  String motorType, String machineId, String testId, String operationName, String field1, String field2
) async {
  final result = await conn.execute(
    Sql.named('''
      INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
      VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
      RETURNING *
    '''),
    parameters: {
      "motor_type": motorType,
      "machine_id": machineId,
      "test_id": testId,
      "operation_name": operationName,
      "field_1": double.tryParse(field1) ?? 0.0,
      "field_2": double.tryParse(field2) ?? 0.0,
    },
  );

  return {"success": true, "record": result.first.toColumnMap().toString()};
}

// Query Function to select all logs from target table data_lsit
Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
  final result = await conn.execute(
    'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM data_lsit ORDER BY id ASC'
  );
  
  return result.map((row) {
    final map = row.toColumnMap();
    return {
      "id": map["id"],
      "motor_type": map["motor_type"],
      "machine_id": map["machine_id"],
      "test_id": map["test_id"],
      "operation_name": map["operation_name"],
      "field_1": map["field_1"],
      "field_2": map["field_2"],
      "created_at": map["created_at"]?.toString(),
    };
  }).toList();
}

// ==========================================
// 5. MAIN SERVICE DRIVER Entrypoint
// ==========================================
Future<void> main() async {
  await connectDB();
  await connectMQTT();
  
  startPostgresListenBridge(); 

  final router = Router();

  router.post('/login', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      String username = body['username']?.toString() ?? '';
      String password = body['password']?.toString() ?? '';

      if (username.isEmpty || password.isEmpty) {
        return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await loginUser(username, password);
      return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  router.post('/add-machine-data', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());

      String motorType = body['motor_type']?.toString() ?? '';
      String machineId = body['machine_id']?.toString() ?? '';
      String testId = body['test_id']?.toString() ?? '';
      String operationName = body['operation_name']?.toString() ?? '';
      String field1 = body['field_1']?.toString() ?? '';
      String field2 = body['field_2']?.toString() ?? '';

      if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
        return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
      return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  // GET Endpoint targeting data_lsit 
  router.get('/get-machine-data', (Request request) async {
    try {
      final logs = await fetchLogsFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
  await io.serve(handler, '0.0.0.0', 3000);
  print("Server engine operational on http://localhost:3000");
}