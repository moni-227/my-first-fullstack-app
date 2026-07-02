// // // // // // // import 'dart:convert';

// // // // // // // import 'package:postgres/postgres.dart';
// // // // // // // import 'package:shelf/shelf.dart';
// // // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // // // // // late Connection conn;

// // // // // // // Future<void> connectDB() async {
// // // // // // //   conn = await Connection.open(
// // // // // // //     Endpoint(
// // // // // // //       host: 'localhost',
// // // // // // //       port: 5432,
// // // // // // //       database: 'Input_Logs',
// // // // // // //       username: 'postgres',
// // // // // // //       password: 'postgres123',
// // // // // // //     ),
// // // // // // //     settings: ConnectionSettings(
// // // // // // //       sslMode: SslMode.disable,
// // // // // // //     ),
// // // // // // //   );

// // // // // // //   print("Connected to PostgreSQL");
// // // // // // // }

// // // // // // // Future<Map<String, dynamic>> loginUser(
// // // // // // //   String username,
// // // // // // //   String password,
// // // // // // // ) async {
// // // // // // //   final result = await conn.execute(
// // // // // // //     Sql.named(
// // // // // // //       '''
// // // // // // //       SELECT *
// // // // // // //       FROM users
// // // // // // //       WHERE username=@username
// // // // // // //       ''',
// // // // // // //     ),
// // // // // // //     parameters: {
// // // // // // //       'username': username.trim(),
// // // // // // //     },
// // // // // // //   );

// // // // // // //   if (result.isNotEmpty) {
// // // // // // //     final row = result.first;

// // // // // // //     String dbPassword = row[2].toString();

// // // // // // //     if (dbPassword == password) {
// // // // // // //       return {
// // // // // // //         "success": true,
// // // // // // //         "message": "Login successful",
// // // // // // //         "username": username,
// // // // // // //       };
// // // // // // //     }
// // // // // // //   }

// // // // // // //   return {
// // // // // // //     "success": false,
// // // // // // //     "message": "Invalid username or password",
// // // // // // //   };
// // // // // // // }

// // // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // // //   String motorType,
// // // // // // //   String machineId,
// // // // // // //   String testId,
// // // // // // //   String operationName,
// // // // // // // ) async {
// // // // // // //   final result = await conn.execute(
// // // // // // //     Sql.named(
// // // // // // //       '''
// // // // // // //       INSERT INTO machine_data
// // // // // // //       (
// // // // // // //         motor_type,
// // // // // // //         machine_id,
// // // // // // //         test_id,
// // // // // // //         operation_name
// // // // // // //       )
// // // // // // //       VALUES
// // // // // // //       (
// // // // // // //         @motor_type,
// // // // // // //         @machine_id,
// // // // // // //         @test_id,
// // // // // // //         @operation_name
// // // // // // //       )
// // // // // // //       RETURNING *
// // // // // // //       '''
// // // // // // //     ),
// // // // // // //     parameters: {
// // // // // // //       "motor_type": motorType,
// // // // // // //       "machine_id": machineId,
// // // // // // //       "test_id": testId,
// // // // // // //       "operation_name": operationName,
// // // // // // //     },
// // // // // // //   );

// // // // // // //   return {
// // // // // // //     "success": true,
// // // // // // //     "record": result.first.toString(),
// // // // // // //   };
// // // // // // // }

// // // // // // // Future<void> main() async {
// // // // // // //   await connectDB();

// // // // // // //   final router = Router();

// // // // // // //   router.post('/login', (Request request) async {
// // // // // // //     try {
// // // // // // //       final body =
// // // // // // //           jsonDecode(await request.readAsString());

// // // // // // //       String username =
// // // // // // //           body['username']?.toString() ?? '';

// // // // // // //       String password =
// // // // // // //           body['password']?.toString() ?? '';

// // // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // // //         return Response(
// // // // // // //           400,
// // // // // // //           body: jsonEncode({
// // // // // // //             "message":
// // // // // // //                 "Username and Password required"
// // // // // // //           }),
// // // // // // //           headers: {
// // // // // // //             "Content-Type": "application/json"
// // // // // // //           },
// // // // // // //         );
// // // // // // //       }

// // // // // // //       final result =
// // // // // // //           await loginUser(username, password);

// // // // // // //       if (result["success"]) {
// // // // // // //         return Response.ok(
// // // // // // //           jsonEncode(result),
// // // // // // //           headers: {
// // // // // // //             "Content-Type": "application/json"
// // // // // // //           },
// // // // // // //         );
// // // // // // //       }

// // // // // // //       return Response(
// // // // // // //         401,
// // // // // // //         body: jsonEncode(result),
// // // // // // //         headers: {
// // // // // // //           "Content-Type": "application/json"
// // // // // // //         },
// // // // // // //       );
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(
// // // // // // //         body: jsonEncode({
// // // // // // //           "message": e.toString()
// // // // // // //         }),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   });

// // // // // // //   router.post('/add-machine-data',
// // // // // // //       (Request request) async {
// // // // // // //     try {
// // // // // // //       final body =
// // // // // // //           jsonDecode(await request.readAsString());

// // // // // // //       String motorType =
// // // // // // //           body['motor_type']?.toString() ?? '';

// // // // // // //       String machineId =
// // // // // // //           body['machine_id']?.toString() ?? '';

// // // // // // //       String testId =
// // // // // // //           body['test_id']?.toString() ?? '';

// // // // // // //       String operationName =
// // // // // // //           body['operation_name']?.toString() ?? '';

// // // // // // //       if (motorType.isEmpty ||
// // // // // // //           machineId.isEmpty ||
// // // // // // //           testId.isEmpty ||
// // // // // // //           operationName.isEmpty) {
// // // // // // //         return Response(
// // // // // // //           400,
// // // // // // //           body: jsonEncode({
// // // // // // //             "message":
// // // // // // //                 "All fields are required"
// // // // // // //           }),
// // // // // // //           headers: {
// // // // // // //             "Content-Type": "application/json"
// // // // // // //           },
// // // // // // //         );
// // // // // // //       }

// // // // // // //       final result = await insertMachineData(
// // // // // // //         motorType,
// // // // // // //         machineId,
// // // // // // //         testId,
// // // // // // //         operationName,
// // // // // // //       );

// // // // // // //       return Response(
// // // // // // //         201,
// // // // // // //         body: jsonEncode(result),
// // // // // // //         headers: {
// // // // // // //           "Content-Type": "application/json"
// // // // // // //         },
// // // // // // //       );
// // // // // // //     } catch (e) {
// // // // // // //       return Response.internalServerError(
// // // // // // //         body: jsonEncode({
// // // // // // //           "message": e.toString()
// // // // // // //         }),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   });

// // // // // // //   final handler = Pipeline()
// // // // // // //       .addMiddleware(corsHeaders())
// // // // // // //       .addMiddleware(logRequests())
// // // // // // //       .addHandler(router.call);

// // // // // // //   await io.serve(
// // // // // // //     handler,
// // // // // // //     '0.0.0.0',
// // // // // // //     3000,
// // // // // // //   );

// // // // // // //   print(
// // // // // // //     "Server running on http://localhost:3000",
// // // // // // //   );
// // // // // // // }




// // // // // // import 'dart:convert';

// // // // // // import 'package:postgres/postgres.dart';
// // // // // // import 'package:shelf/shelf.dart';
// // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// // // // // // late Connection conn;

// // // // // // Future<void> connectDB() async {
// // // // // //   conn = await Connection.open(
// // // // // //     Endpoint(
// // // // // //       host: 'localhost',
// // // // // //       port: 5432,
// // // // // //       database: 'Input_Logs',
// // // // // //       username: 'postgres',
// // // // // //       password: 'postgres123',
// // // // // //     ),
// // // // // //     settings: ConnectionSettings(
// // // // // //       sslMode: SslMode.disable,
// // // // // //     ),
// // // // // //   );

// // // // // //   print("Connected to PostgreSQL");
// // // // // // }

// // // // // // Future<Map<String, dynamic>> loginUser(
// // // // // //   String username,
// // // // // //   String password,
// // // // // // ) async {
// // // // // //   final result = await conn.execute(
// // // // // //     Sql.named(
// // // // // //       '''
// // // // // //       SELECT *
// // // // // //       FROM users
// // // // // //       WHERE username=@username
// // // // // //       ''',
// // // // // //     ),
// // // // // //     parameters: {
// // // // // //       'username': username.trim(),
// // // // // //     },
// // // // // //   );

// // // // // //   if (result.isNotEmpty) {
// // // // // //     final row = result.first;

// // // // // //     String dbPassword = row[2].toString();

// // // // // //     if (dbPassword == password) {
// // // // // //       return {
// // // // // //         "success": true,
// // // // // //         "message": "Login successful",
// // // // // //         "username": username,
// // // // // //       };
// // // // // //     }
// // // // // //   }

// // // // // //   return {
// // // // // //     "success": false,
// // // // // //     "message": "Invalid username or password",
// // // // // //   };
// // // // // // }

// // // // // // // Updated handler function signature to accept field1 and field2 parameters
// // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // //   String motorType,
// // // // // //   String machineId,
// // // // // //   String testId,
// // // // // //   String operationName,
// // // // // //   String field1,
// // // // // //   String field2,
// // // // // // ) async {
// // // // // //   final result = await conn.execute(
// // // // // //     Sql.named(
// // // // // //       '''
// // // // // //       INSERT INTO machine_data
// // // // // //       (
// // // // // //         motor_type,
// // // // // //         machine_id,
// // // // // //         test_id,
// // // // // //         operation_name,
// // // // // //         field_1,
// // // // // //         field_2
// // // // // //       )
// // // // // //       VALUES
// // // // // //       (
// // // // // //         @motor_type,
// // // // // //         @machine_id,
// // // // // //         @test_id,
// // // // // //         @operation_name,
// // // // // //         @field_1,
// // // // // //         @field_2
// // // // // //       )
// // // // // //       RETURNING *
// // // // // //       '''
// // // // // //     ),
// // // // // //     parameters: {
// // // // // //       "motor_type": motorType,
// // // // // //       "machine_id": machineId,
// // // // // //       "test_id": testId,
// // // // // //       "operation_name": operationName,
// // // // // //       "field_1": field1,
// // // // // //       "field_2": field2,
// // // // // //     },
// // // // // //   );

// // // // // //   return {
// // // // // //     "success": true,
// // // // // //     "record": result.first.toString(),
// // // // // //   };
// // // // // // }

// // // // // // Future<void> main() async {
// // // // // //   await connectDB();

// // // // // //   final router = Router();

// // // // // //   router.post('/login', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // //       String username = body['username']?.toString() ?? '';
// // // // // //       String password = body['password']?.toString() ?? '';

// // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // //         return Response(
// // // // // //           400,
// // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       final result = await loginUser(username, password);

// // // // // //       if (result["success"]) {
// // // // // //         return Response.ok(
// // // // // //           jsonEncode(result),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       return Response(
// // // // // //         401,
// // // // // //         body: jsonEncode(result),
// // // // // //         headers: {"Content-Type": "application/json"},
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(
// // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // //       );
// // // // // //     }
// // // // // //   });

// // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // //       String field1 = body['field_1']?.toString() ?? ''; // Captured Field 1
// // // // // //       String field2 = body['field_2']?.toString() ?? ''; // Captured Field 2

// // // // // //       if (motorType.isEmpty ||
// // // // // //           machineId.isEmpty ||
// // // // // //           testId.isEmpty ||
// // // // // //           operationName.isEmpty ||
// // // // // //           field1.isEmpty ||
// // // // // //           field2.isEmpty) {
// // // // // //         return Response(
// // // // // //           400,
// // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       final result = await insertMachineData(
// // // // // //         motorType,
// // // // // //         machineId,
// // // // // //         testId,
// // // // // //         operationName,
// // // // // //         field1,
// // // // // //         field2,
// // // // // //       );

// // // // // //       return Response(
// // // // // //         201,
// // // // // //         body: jsonEncode(result),
// // // // // //         headers: {"Content-Type": "application/json"},
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(
// // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // //       );
// // // // // //     }
// // // // // //   });

// // // // // //   final handler = Pipeline()
// // // // // //       .addMiddleware(corsHeaders())
// // // // // //       .addMiddleware(logRequests())
// // // // // //       .addHandler(router.call);

// // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // //   print("Server running on http://localhost:3000");
// // // // // // }





// // // // // // direct mqtt

// // // // // // import 'dart:convert';
// // // // // // import 'package:postgres/postgres.dart';
// // // // // // import 'package:shelf/shelf.dart';
// // // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // // late Connection conn;
// // // // // // late MqttServerClient mqttClient;

// // // // // // // ==========================================
// // // // // // // 1. POSTGRESQL CONNECTION & OPERATIONS
// // // // // // // ==========================================
// // // // // // Future<void> connectDB() async {
// // // // // //   conn = await Connection.open(
// // // // // //     Endpoint(
// // // // // //       host: 'localhost',
// // // // // //       port: 5432,
// // // // // //       database: 'Input_Logs',
// // // // // //       username: 'postgres',
// // // // // //       password: 'postgres123',
// // // // // //     ),
// // // // // //     settings: ConnectionSettings(
// // // // // //       sslMode: SslMode.disable,
// // // // // //     ),
// // // // // //   );

// // // // // //   print("Connected to PostgreSQL");
// // // // // // }

// // // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // // //   final result = await conn.execute(
// // // // // //     Sql.named(
// // // // // //       '''
// // // // // //       SELECT *
// // // // // //       FROM users
// // // // // //       WHERE username=@username
// // // // // //       ''',
// // // // // //     ),
// // // // // //     parameters: {
// // // // // //       'username': username.trim(),
// // // // // //     },
// // // // // //   );

// // // // // //   if (result.isNotEmpty) {
// // // // // //     final row = result.first;
// // // // // //     String dbPassword = row[2].toString();

// // // // // //     if (dbPassword == password) {
// // // // // //       return {
// // // // // //         "success": true,
// // // // // //         "message": "Login successful",
// // // // // //         "username": username,
// // // // // //       };
// // // // // //     }
// // // // // //   }

// // // // // //   return {
// // // // // //     "success": false,
// // // // // //     "message": "Invalid username or password",
// // // // // //   };
// // // // // // }

// // // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // // //   String motorType,
// // // // // //   String machineId,
// // // // // //   String testId,
// // // // // //   String operationName,
// // // // // //   String field1,
// // // // // //   String field2,
// // // // // // ) async {
// // // // // //   final result = await conn.execute(
// // // // // //     Sql.named(
// // // // // //       '''
// // // // // //       INSERT INTO machine_data
// // // // // //       (
// // // // // //         motor_type,
// // // // // //         machine_id,
// // // // // //         test_id,
// // // // // //         operation_name,
// // // // // //         field_1,
// // // // // //         field_2
// // // // // //       )
// // // // // //       VALUES
// // // // // //       (
// // // // // //         @motor_type,
// // // // // //         @machine_id,
// // // // // //         @test_id,
// // // // // //         @operation_name,
// // // // // //         @field_1,
// // // // // //         @field_2
// // // // // //       )
// // // // // //       RETURNING *
// // // // // //       '''
// // // // // //     ),
// // // // // //     parameters: {
// // // // // //       "motor_type": motorType,
// // // // // //       "machine_id": machineId,
// // // // // //       "test_id": testId,
// // // // // //       "operation_name": operationName,
// // // // // //       "field_1": field1,
// // // // // //       "field_2": field2,
// // // // // //     },
// // // // // //   );

// // // // // //   return {
// // // // // //     "success": true,
// // // // // //     "record": result.first.toString(),
// // // // // //   };
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 2. MQTT BROKER PUBLISHER CONNECTION
// // // // // // // ==========================================
// // // // // // Future<void> connectMQTT() async {
// // // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'dart_backend_publisher');
// // // // // //   mqttClient.port = 1883;
// // // // // //   mqttClient.logging(on: false);
// // // // // //   mqttClient.keepAlivePeriod = 20;

// // // // // //   try {
// // // // // //     print('Connecting to MQTT Broker...');
// // // // // //     await mqttClient.connect();
// // // // // //     print('Connected to MQTT Broker successfully!');
// // // // // //   } catch (e) {
// // // // // //     print('MQTT Connection exception: $e');
// // // // // //     mqttClient.disconnect();
// // // // // //   }
// // // // // // }

// // // // // // void publishMachineData(Map<String, dynamic> data) {
// // // // // //   const String topic = 'machine/metrics';
// // // // // //   final builder = MqttClientPayloadBuilder();
// // // // // //   builder.addString(jsonEncode(data));

// // // // // //   if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //     mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
// // // // // //     print('Published data to MQTT topic: $topic');
// // // // // //   } else {
// // // // // //     print('MQTT client not connected, skipping publish.');
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 3. MAIN SERVER ROUTING ENTRYPOINT
// // // // // // // ==========================================
// // // // // // Future<void> main() async {
// // // // // //   await connectDB();   // This will now resolve perfectly
// // // // // //   await connectMQTT(); // This will now resolve perfectly

// // // // // //   final router = Router();

// // // // // //   router.post('/login', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());
// // // // // //       String username = body['username']?.toString() ?? '';
// // // // // //       String password = body['password']?.toString() ?? '';

// // // // // //       if (username.isEmpty || password.isEmpty) {
// // // // // //         return Response(
// // // // // //           400,
// // // // // //           body: jsonEncode({"message": "Username and Password required"}),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       final result = await loginUser(username, password);

// // // // // //       if (result["success"]) {
// // // // // //         return Response.ok(
// // // // // //           jsonEncode(result),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       return Response(
// // // // // //         401,
// // // // // //         body: jsonEncode(result),
// // // // // //         headers: {"Content-Type": "application/json"},
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(
// // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // //       );
// // // // // //     }
// // // // // //   });

// // // // // //   router.post('/add-machine-data', (Request request) async {
// // // // // //     try {
// // // // // //       final body = jsonDecode(await request.readAsString());

// // // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // // //       String field1 = body['field_1']?.toString() ?? ''; 
// // // // // //       String field2 = body['field_2']?.toString() ?? ''; 

// // // // // //       if (motorType.isEmpty ||
// // // // // //           machineId.isEmpty ||
// // // // // //           testId.isEmpty ||
// // // // // //           operationName.isEmpty ||
// // // // // //           field1.isEmpty ||
// // // // // //           field2.isEmpty) {
// // // // // //         return Response(
// // // // // //           400,
// // // // // //           body: jsonEncode({"message": "All fields are required"}),
// // // // // //           headers: {"Content-Type": "application/json"},
// // // // // //         );
// // // // // //       }

// // // // // //       // 1. Insert directly into Postgres 
// // // // // //       final result = await insertMachineData(
// // // // // //         motorType,
// // // // // //         machineId,
// // // // // //         testId,
// // // // // //         operationName,
// // // // // //         field1,
// // // // // //         field2,
// // // // // //       );

// // // // // //       // 2. Publish to MQTT Broker for MongoDB Ingestion
// // // // // //       publishMachineData({
// // // // // //         "motor_type": motorType,
// // // // // //         "machine_id": machineId,
// // // // // //         "test_id": testId,
// // // // // //         "operation_name": operationName,
// // // // // //         "field_1": field1,
// // // // // //         "field_2": field2,
// // // // // //         "timestamp": DateTime.now().toIso8601String()
// // // // // //       });

// // // // // //       return Response(
// // // // // //         201,
// // // // // //         body: jsonEncode(result),
// // // // // //         headers: {"Content-Type": "application/json"},
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       return Response.internalServerError(
// // // // // //         body: jsonEncode({"message": e.toString()}),
// // // // // //       );
// // // // // //     }
// // // // // //   });

// // // // // //   final handler = Pipeline()
// // // // // //       .addMiddleware(corsHeaders())
// // // // // //       .addMiddleware(logRequests())
// // // // // //       .addHandler(router.call);

// // // // // //   await io.serve(handler, '0.0.0.0', 3000);

// // // // // //   print("Server running on http://localhost:3000");
// // // // // // }





// // // // // import 'dart:convert';
// // // // // import 'package:postgres/postgres.dart';
// // // // // import 'package:shelf/shelf.dart';
// // // // // import 'package:shelf/shelf_io.dart' as io;
// // // // // import 'package:shelf_router/shelf_router.dart';
// // // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // // late Connection conn;
// // // // // late Connection listenConn; // Separate connection dedicated solely to LISTEN
// // // // // late MqttServerClient mqttClient;

// // // // // // ==========================================
// // // // // // 1. DATABASE CONNECTIVITY
// // // // // // ==========================================
// // // // // Future<void> connectDB() async {
// // // // //   // final endpoint = Endpoint(
// // // // //   //   host: 'localhost',
// // // // //   //   port: 5432,
// // // // //   //   database: 'Input_Logs',
// // // // //   //   username: 'postgres',
// // // // //   //   password: 'postgres123',
// // // // //   // );
  
// // // // //   final endpoint = Endpoint(
// // // // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // //   port: 5432,
// // // // //   database: 'neondb',
// // // // //   username: 'neondb_owner',
// // // // //   password: 'npg_mT9C4KeOaJVN',
// // // // // );

// // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // //   // Connection for executing normal queries
// // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // //   // Persistent connection dedicated to receiving LISTEN events
// // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // }

// // // // // // ==========================================
// // // // // // 2. MQTT CLIENT PUBLISHER
// // // // // // ==========================================
// // // // // Future<void> connectMQTT() async {
// // // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // // //   mqttClient.port = 1883;
// // // // //   mqttClient.logging(on: false);
// // // // //   mqttClient.keepAlivePeriod = 20;

// // // // //   try {
// // // // //     print('Connecting to MQTT Broker...');
// // // // //     await mqttClient.connect();
// // // // //     print('Connected to MQTT Broker successfully!');
// // // // //   } catch (e) {
// // // // //     print('MQTT Connection failure: $e');
// // // // //     mqttClient.disconnect();
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // ==========================================
// // // // // // Future<void> startPostgresListenBridge() async {
// // // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // // //   // Stream listener that captures broadcasts continuously
// // // // // //   listenConn.channels['machine_channel'].listen((notification) {
// // // // // //     final String? payload = notification.payload;
    
// // // // // //     if (payload != null) {
// // // // // //       print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // // //       // Forward directly over MQTT
// // // // // //       if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // // //         final builder = MqttClientPayloadBuilder();
// // // // // //         builder.addString(payload);

// // // // // //         mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // // //         print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // // //       } else {
// // // // // //         print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // // //       }
// // // // // //     }
// // // // // //   });
// // // // // // }


// // // // // // ==========================================
// // // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // // ==========================================
// // // // // Future<void> startPostgresListenBridge() async {
// // // // //   // Instruct Postgres to begin listening on our custom channel
// // // // //   await listenConn.execute('LISTEN machine_channel');
// // // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // // //   // In postgres v3+, the notification stream yields String directly
// // // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // // //     // Forward directly over MQTT
// // // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // // //       final builder = MqttClientPayloadBuilder();
// // // // //       builder.addString(payload);

// // // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // // //     } else {
// // // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // // //     }
// // // // //   });
// // // // // }

// // // // // // ==========================================
// // // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // // ==========================================
// // // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // // //   final result = await conn.execute(
// // // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // // //     parameters: {'username': username.trim()},
// // // // //   );

// // // // //   if (result.isNotEmpty) {
// // // // //     final row = result.first;
// // // // //     String dbPassword = row[2].toString();

// // // // //     if (dbPassword == password) {
// // // // //       return {"success": true, "message": "Login successful", "username": username};
// // // // //     }
// // // // //   }
// // // // //   return {"success": false, "message": "Invalid username or password"};
// // // // // }

// // // // // Future<Map<String, dynamic>> insertMachineData(
// // // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // // ) async {
// // // // //   final result = await conn.execute(
// // // // //     Sql.named('''
// // // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // // //       RETURNING *
// // // // //     '''),
// // // // //     parameters: {
// // // // //       "motor_type": motorType,
// // // // //       "machine_id": machineId,
// // // // //       "test_id": testId,
// // // // //       "operation_name": operationName,
// // // // //       "field_1": field1,
// // // // //       "field_2": field2,
// // // // //     },
// // // // //   );

// // // // //   return {"success": true, "record": result.first.toString()};
// // // // // }

// // // // // // ==========================================
// // // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // // ==========================================
// // // // // Future<void> main() async {
// // // // //   await connectDB();
// // // // //   await connectMQTT();
  
// // // // //   // Launch the asynchronous Listen -> Publish loop runner
// // // // //   startPostgresListenBridge(); 

// // // // //   final router = Router();

// // // // //   router.post('/login', (Request request) async {
// // // // //     try {
// // // // //       final body = jsonDecode(await request.readAsString());
// // // // //       String username = body['username']?.toString() ?? '';
// // // // //       String password = body['password']?.toString() ?? '';

// // // // //       if (username.isEmpty || password.isEmpty) {
// // // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // // //       }

// // // // //       final result = await loginUser(username, password);
// // // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   router.post('/add-machine-data', (Request request) async {
// // // // //     try {
// // // // //       final body = jsonDecode(await request.readAsString());

// // // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // // //       String testId = body['test_id']?.toString() ?? '';
// // // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // // //       String field1 = body['field_1']?.toString() ?? '';
// // // // //       String field2 = body['field_2']?.toString() ?? '';

// // // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // // //       }

// // // // //       // Perform standard SQL insert. The DB trigger executes the broadcast pipeline.
// // // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);

// // // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // // //     } catch (e) {
// // // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // // //     }
// // // // //   });

// // // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // // //   print("Server engine operational on http://localhost:3000");
// // // // // }



// // // // import 'dart:convert';
// // // // import 'package:postgres/postgres.dart';
// // // // import 'package:shelf/shelf.dart';
// // // // import 'package:shelf/shelf_io.dart' as io;
// // // // import 'package:shelf_router/shelf_router.dart';
// // // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // // import 'package:mqtt_client/mqtt_client.dart';

// // // // late Connection conn;
// // // // late Connection listenConn; 
// // // // late MqttServerClient mqttClient;

// // // // // ==========================================
// // // // // 1. DATABASE CONNECTIVITY
// // // // // ==========================================
// // // // // Future<void> connectDB() async {
// // // // //   final endpoint = Endpoint(
// // // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // // //     port: 5432,
// // // // //     database: 'neondb',
// // // // //     username: 'neondb_owner',
// // // // //     password: 'npg_mT9C4KeOaJVN',
// // // // //   );

// // // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // // //   conn = await Connection.open(endpoint, settings: settings);
// // // // //   print("Connected to PostgreSQL (Query Client)");

// // // // //   listenConn = await Connection.open(endpoint, settings: settings);
// // // // //   print("Connected to PostgreSQL (Listen Client)");
// // // // // }

// // // // Future<void> connectDB() async {
// // // //   final endpoint = Endpoint(
// // // //     host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // // //     port: 5432,
// // // //     database: 'neondb',
// // // //     username: 'neondb_owner',
// // // //     password: 'npg_mT9C4KeOaJVN',
// // // //   );

// // // //   final settings = ConnectionSettings(sslMode: SslMode.require);

// // // //   bool connected = false;
// // // //   while (!connected) {
// // // //     try {
// // // //       conn = await Connection.open(endpoint, settings: settings);
// // // //       listenConn = await Connection.open(endpoint, settings: settings);
// // // //       print("Connected to PostgreSQL");
// // // //       connected = true;
// // // //     } catch (e) {
// // // //       print("DB connection failed, retrying in 3s: $e");
// // // //       await Future.delayed(const Duration(seconds: 3));
// // // //     }
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 2. MQTT CLIENT PUBLISHER
// // // // // ==========================================
// // // // Future<void> connectMQTT() async {
// // // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // // //   mqttClient.port = 1883;
// // // //   mqttClient.logging(on: false);
// // // //   mqttClient.keepAlivePeriod = 20;

// // // //   try {
// // // //     print('Connecting to MQTT Broker...');
// // // //     await mqttClient.connect();
// // // //     print('Connected to MQTT Broker successfully!');
// // // //   } catch (e) {
// // // //     print('MQTT Connection failure: $e');
// // // //     mqttClient.disconnect();
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // // ==========================================
// // // // Future<void> startPostgresListenBridge() async {
// // // //   await listenConn.execute('LISTEN machine_channel');
// // // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // // //   listenConn.channels['machine_channel'].listen((String payload) {
// // // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // // //       final builder = MqttClientPayloadBuilder();
// // // //       builder.addString(payload);

// // // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // // //     } else {
// // // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // // //     }
// // // //   });
// // // // }

// // // // // ==========================================
// // // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // // ==========================================
// // // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // // //   final result = await conn.execute(
// // // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // // //     parameters: {'username': username.trim()},
// // // //   );

// // // //   if (result.isNotEmpty) {
// // // //     final row = result.first;
// // // //     String dbPassword = row[2].toString();

// // // //     if (dbPassword == password) {
// // // //       return {"success": true, "message": "Login successful", "username": username};
// // // //     }
// // // //   }
// // // //   return {"success": false, "message": "Invalid username or password"};
// // // // }

// // // // Future<Map<String, dynamic>> insertMachineData(
// // // //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // // // ) async {
// // // //   final result = await conn.execute(
// // // //     Sql.named('''
// // // //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// // // //       RETURNING *
// // // //     '''),
// // // //     parameters: {
// // // //       "motor_type": motorType,
// // // //       "machine_id": machineId,
// // // //       "test_id": testId,
// // // //       "operation_name": operationName,
// // // //       "field_1": double.tryParse(field1) ?? 0.0,
// // // //       "field_2": double.tryParse(field2) ?? 0.0,
// // // //     },
// // // //   );

// // // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // // }

// // // // // Query Function to select all logs from target table data_lsit
// // // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // // //   final result = await conn.execute(
// // // //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM data_lsit ORDER BY id ASC'
// // // //   );
  
// // // //   return result.map((row) {
// // // //     final map = row.toColumnMap();
// // // //     return {
// // // //       "id": map["id"],
// // // //       "motor_type": map["motor_type"],
// // // //       "machine_id": map["machine_id"],
// // // //       "test_id": map["test_id"],
// // // //       "operation_name": map["operation_name"],
// // // //       "field_1": map["field_1"],
// // // //       "field_2": map["field_2"],
// // // //       "created_at": map["created_at"]?.toString(),
// // // //     };
// // // //   }).toList();
// // // // }

// // // // // ==========================================
// // // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // // ==========================================
// // // // Future<void> main() async {
// // // //   await connectDB();
// // // //   await connectMQTT();
  
// // // //   startPostgresListenBridge(); 

// // // //   final router = Router();

// // // //   router.post('/login', (Request request) async {
// // // //     try {
// // // //       final body = jsonDecode(await request.readAsString());
// // // //       String username = body['username']?.toString() ?? '';
// // // //       String password = body['password']?.toString() ?? '';

// // // //       if (username.isEmpty || password.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await loginUser(username, password);
// // // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   router.post('/add-machine-data', (Request request) async {
// // // //     try {
// // // //       final body = jsonDecode(await request.readAsString());

// // // //       String motorType = body['motor_type']?.toString() ?? '';
// // // //       String machineId = body['machine_id']?.toString() ?? '';
// // // //       String testId = body['test_id']?.toString() ?? '';
// // // //       String operationName = body['operation_name']?.toString() ?? '';
// // // //       String field1 = body['field_1']?.toString() ?? '';
// // // //       String field2 = body['field_2']?.toString() ?? '';

// // // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// // // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // // //       }

// // // //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// // // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   // GET Endpoint targeting data_lsit 
// // // //   router.get('/get-machine-data', (Request request) async {
// // // //     try {
// // // //       final logs = await fetchLogsFromDB();
// // // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // // //     } catch (e) {
// // // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // // //     }
// // // //   });

// // // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // // //   await io.serve(handler, '0.0.0.0', 3000);
// // // //   print("Server engine operational on http://localhost:3000");
// // // // }


// // // import 'dart:convert';
// // // import 'package:postgres/postgres.dart';
// // // import 'package:shelf/shelf.dart';
// // // import 'package:shelf/shelf_io.dart' as io;
// // // import 'package:shelf_router/shelf_router.dart';
// // // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // // import 'package:mqtt_client/mqtt_server_client.dart';
// // // import 'package:mqtt_client/mqtt_client.dart';

// // // late Connection conn;
// // // late Connection listenConn; 
// // // late MqttServerClient mqttClient;

// // // // ==========================================
// // // // 1. DATABASE CONNECTIVITY
// // // // ==========================================
// // // final _pgEndpoint = Endpoint(
// // //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// // //   port: 5432,
// // //   database: 'neondb',
// // //   username: 'neondb_owner',
// // //   password: 'npg_mT9C4KeOaJVN',
// // // );

// // // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // // Opens a single connection, retrying every 3s until it succeeds.
// // // // Neon's free-tier compute auto-suspends after a period of inactivity,
// // // // which silently drops any open connection — this helper is what lets
// // // // us open a fresh one again on demand, instead of only at server startup.
// // // Future<Connection> _openConnection() async {
// // //   while (true) {
// // //     try {
// // //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// // //     } catch (e) {
// // //       print("DB connection failed, retrying in 3s: $e");
// // //       await Future.delayed(const Duration(seconds: 3));
// // //     }
// // //   }
// // // }

// // // Future<void> connectDB() async {
// // //   conn = await _openConnection();
// // //   print("Connected to PostgreSQL (Query Client)");
// // //   listenConn = await _openConnection();
// // //   print("Connected to PostgreSQL (Listen Client)");
// // // }

// // // // Runs a query; if it fails because the connection has gone stale
// // // // (e.g. Neon suspended the compute and dropped it), reopens just the
// // // // query connection and retries the action once before giving up.
// // // Future<T> _withRetry<T>(Future<T> Function() action) async {
// // //   try {
// // //     return await action();
// // //   } catch (e) {
// // //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// // //     conn = await _openConnection();
// // //     return await action();
// // //   }
// // // }

// // // // ==========================================
// // // // 2. MQTT CLIENT PUBLISHER
// // // // ==========================================
// // // Future<void> connectMQTT() async {
// // //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// // //   mqttClient.port = 1883;
// // //   mqttClient.logging(on: false);
// // //   mqttClient.keepAlivePeriod = 20;

// // //   try {
// // //     print('Connecting to MQTT Broker...');
// // //     await mqttClient.connect();
// // //     print('Connected to MQTT Broker successfully!');
// // //   } catch (e) {
// // //     print('MQTT Connection failure: $e');
// // //     mqttClient.disconnect();
// // //   }
// // // }

// // // // ==========================================
// // // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // // ==========================================
// // // Future<void> startPostgresListenBridge() async {
// // //   await listenConn.execute('LISTEN machine_channel');
// // //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// // //   listenConn.channels['machine_channel'].listen((String payload) {
// // //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// // //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// // //       final builder = MqttClientPayloadBuilder();
// // //       builder.addString(payload);

// // //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// // //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// // //     } else {
// // //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// // //     }
// // //   });
// // // }

// // // // ==========================================
// // // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // // ==========================================
// // // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// // //   final result = await _withRetry(() => conn.execute(
// // //     Sql.named('SELECT * FROM users WHERE username=@username'),
// // //     parameters: {'username': username.trim()},
// // //   ));

// // //   if (result.isNotEmpty) {
// // //     final row = result.first;
// // //     String dbPassword = row[2].toString();

// // //     if (dbPassword == password) {
// // //       return {"success": true, "message": "Login successful", "username": username};
// // //     }
// // //   }
// // //   return {"success": false, "message": "Invalid username or password"};
// // // }

// // // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // // Future<Map<String, dynamic>> insertMachineData(
// // //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // // ) async {
// // //   final result = await _withRetry(() => conn.execute(
// // //     Sql.named('''
// // //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// // //       RETURNING *
// // //     '''),
// // //     parameters: {
// // //       "motor_type": motorType,
// // //       "machine_id": machineId,
// // //       "test_id": testId,
// // //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// // //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// // //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// // //     },
// // //   ));

// // //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // // }

// // // // Query Function to select all logs from target table data_list
// // // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// // //   final result = await _withRetry(() => conn.execute(
// // //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// // //   ));
  
// // //   return result.map((row) {
// // //     final map = row.toColumnMap();
// // //     return {
// // //       "id": map["id"],
// // //       "motor_type": map["motor_type"],
// // //       "machine_id": map["machine_id"],
// // //       "test_id": map["test_id"],
// // //       "temprature1": map["temprature1"],
// // //       "temprature2": map["temprature2"],
// // //       "temprature3": map["temprature3"],
// // //       "created_at": map["created_at"]?.toString(),
// // //     };
// // //   }).toList();
// // // }

// // // // ==========================================
// // // // 5. MAIN SERVICE DRIVER Entrypoint
// // // // ==========================================
// // // Future<void> main() async {
// // //   await connectDB();
// // //   await connectMQTT();
  
// // //   startPostgresListenBridge(); 

// // //   final router = Router();

// // //   router.post('/login', (Request request) async {
// // //     try {
// // //       final body = jsonDecode(await request.readAsString());
// // //       String username = body['username']?.toString() ?? '';
// // //       String password = body['password']?.toString() ?? '';

// // //       if (username.isEmpty || password.isEmpty) {
// // //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// // //       }

// // //       final result = await loginUser(username, password);
// // //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   router.post('/add-machine-data', (Request request) async {
// // //     try {
// // //       final body = jsonDecode(await request.readAsString());

// // //       String motorType = body['motor_type']?.toString() ?? '';
// // //       String machineId = body['machine_id']?.toString() ?? '';
// // //       String testId = body['test_id']?.toString() ?? '';
// // //       String temprature1 = body['temprature1']?.toString() ?? '';
// // //       String temprature2 = body['temprature2']?.toString() ?? '';
// // //       String temprature3 = body['temprature3']?.toString() ?? '';

// // //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// // //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// // //       }

// // //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// // //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   // GET Endpoint targeting data_list
// // //   router.get('/get-machine-data', (Request request) async {
// // //     try {
// // //       final logs = await fetchLogsFromDB();
// // //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// // //     } catch (e) {
// // //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// // //     }
// // //   });

// // //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// // //   await io.serve(handler, '0.0.0.0', 3000);
// // //   print("Server engine operational on http://localhost:3000");
// // // }



// // import 'dart:convert';
// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Connection conn;
// // late Connection listenConn;
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. DATABASE CONNECTIVITY
// // // ==========================================
// // final _pgEndpoint = Endpoint(
// //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// //   port: 5432,
// //   database: 'neondb',
// //   username: 'neondb_owner',
// //   password: 'npg_mT9C4KeOaJVN',
// // );

// // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // Future<Connection> _openConnection() async {
// //   while (true) {
// //     try {
// //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// //     } catch (e) {
// //       print("DB connection failed, retrying in 3s: $e");
// //       await Future.delayed(const Duration(seconds: 3));
// //     }
// //   }
// // }

// // Future<void> connectDB() async {
// //   conn = await _openConnection();
// //   print("Connected to PostgreSQL (Query Client)");
// //   listenConn = await _openConnection();
// //   print("Connected to PostgreSQL (Listen Client)");
// // }

// // Future<T> _withRetry<T>(Future<T> Function() action) async {
// //   try {
// //     return await action();
// //   } catch (e) {
// //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// //     conn = await _openConnection();
// //     return await action();
// //   }
// // }

// // // ==========================================
// // // 2. MQTT CLIENT PUBLISHER
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection failure: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // // ==========================================
// // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // ==========================================
// // Future<void> startPostgresListenBridge() async {
// //   await listenConn.execute('LISTEN machine_channel');
// //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// //   listenConn.channels['machine_channel'].listen((String payload) {
// //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       final builder = MqttClientPayloadBuilder();
// //       builder.addString(payload);

// //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //     } else {
// //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //     }
// //   });
// // }

// // // ==========================================
// // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // ==========================================
// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('SELECT * FROM users WHERE username=@username'),
// //     parameters: {'username': username.trim()},
// //   ));

// //   if (result.isNotEmpty) {
// //     final row = result.first;
// //     String dbPassword = row[2].toString();
// //     if (dbPassword == password) {
// //       return {"success": true, "message": "Login successful", "username": username};
// //     }
// //   }
// //   return {"success": false, "message": "Invalid username or password"};
// // }

// // // Inserts a new row into machine_data
// // // Columns: motor_type, machine_id, test_id, operation_name, field_1, field_2
// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType,
// //   String machineId,
// //   String testId,
// //   String operationName,
// //   double field1,
// //   double field2,
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query all logs from machine_data
// // Future<List<Map<String, dynamic>>> fetchMachineData() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC',
// //   ));

// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "operation_name": map["operation_name"],
// //       "field_1": map["field_1"],
// //       "field_2": map["field_2"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ==========================================
// // // 5. MAIN SERVICE DRIVER Entrypoint
// // // ==========================================
// // Future<void> main() async {
// //   await connectDB();
// //   await connectMQTT();

// //   startPostgresListenBridge();

// //   final router = Router();

// //   // POST /login
// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(400,
// //             body: jsonEncode({"message": "Username/Password required"}),
// //             headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await loginUser(username, password);
// //       return Response(result["success"] ? 200 : 401,
// //           body: jsonEncode(result),
// //           headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // POST /add-machine-data — inserts into machine_data table
// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType     = body['motor_type']?.toString() ?? '';
// //       String machineId     = body['machine_id']?.toString() ?? '';
// //       String testId        = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       double field1        = double.tryParse(body['field_1']?.toString() ?? '') ?? 0.0;
// //       double field2        = double.tryParse(body['field_2']?.toString() ?? '') ?? 0.0;

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty) {
// //         return Response(400,
// //             body: jsonEncode({"message": "motor_type, machine_id, test_id, and operation_name are required"}),
// //             headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineData(motorType, machineId, testId, operationName, field1, field2);
// //       return Response(201,
// //           body: jsonEncode(result),
// //           headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET /get-machine-data — fetches all rows from machine_data
// //   router.get('/get-machine-data', (Request request) async {
// //     try {
// //       final logs = await fetchMachineData();
// //       return Response.ok(jsonEncode(logs),
// //           headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   final handler = Pipeline()
// //       .addMiddleware(corsHeaders())
// //       .addMiddleware(logRequests())
// //       .addHandler(router.call);

// //   await io.serve(handler, '0.0.0.0', 3000);
// //   print("Server engine operational on http://localhost:3000");
// // }









// // import 'dart:convert';
// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Connection conn;
// // late Connection listenConn;  
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. DATABASE CONNECTIVITY
// // // ==========================================
// // final _pgEndpoint = Endpoint(
// //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// //   port: 5432,
// //   database: 'neondb',
// //   username: 'neondb_owner',
// //   password: 'npg_mT9C4KeOaJVN',
// // );

// // final _pgSettings = ConnectionSettings(sslMode: SslMode.require);

// // // Opens a single connection, retrying every 3s until it succeeds.
// // // Neon's free-tier compute auto-suspends after a period of inactivity,
// // // which silently drops any open connection — this helper is what lets
// // // us open a fresh one again on demand, instead of only at server startup.
// // Future<Connection> _openConnection() async {
// //   while (true) {
// //     try {
// //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// //     } catch (e) {
// //       print("DB connection failed, retrying in 3s: $e");
// //       await Future.delayed(const Duration(seconds: 3));
// //     }
// //   }
// // }

// // Future<void> connectDB() async {
// //   conn = await _openConnection();
// //   print("Connected to PostgreSQL (Query Client)");
// //   listenConn = await _openConnection();
// //   print("Connected to PostgreSQL (Listen Client)");
// // }

// // // Runs a query; if it fails because the connection has gone stale
// // // (e.g. Neon suspended the compute and dropped it), reopens just the
// // // query connection and retries the action once before giving up.
// // Future<T> _withRetry<T>(Future<T> Function() action) async {
// //   try {
// //     return await action();
// //   } catch (e) {
// //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// //     conn = await _openConnection();
// //     return await action();
// //   }
// // }

// // // ==========================================
// // // 2. MQTT CLIENT PUBLISHER
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection failure: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // // ==========================================
// // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // ==========================================
// // Future<void> startPostgresListenBridge() async {
// //   await listenConn.execute('LISTEN machine_channel');
// //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// //   listenConn.channels['machine_channel'].listen((String payload) {
// //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       final builder = MqttClientPayloadBuilder();
// //       builder.addString(payload);

// //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //     } else {
// //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //     }
// //   });
// // }

// // // ==========================================
// // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // ==========================================
// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('SELECT * FROM users WHERE username=@username'),
// //     parameters: {'username': username.trim()},
// //   ));

// //   if (result.isNotEmpty) {
// //     final row = result.first;
// //     String dbPassword = row[2].toString();

// //     if (dbPassword == password) {
// //       return {"success": true, "message": "Login successful", "username": username};
// //     }
// //   }
// //   return {"success": false, "message": "Invalid username or password"};
// // }

// // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all logs from target table data_list
// // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// //   ));
  
// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "temprature1": map["temprature1"],
// //       "temprature2": map["temprature2"],
// //       "temprature3": map["temprature3"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ------------------------------------------
// // // SEPARATE TABLE: machine_data
// // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // This is a completely independent table/endpoint pair from data_list above —
// // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // ------------------------------------------

// // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // Future<Map<String, dynamic>> insertMachineRecord(
// //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all rows from target table machine_data
// // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
// //   ));

// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "operation_name": map["operation_name"],
// //       "field_1": map["field_1"],
// //       "field_2": map["field_2"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ==========================================
// // // 5. MAIN SERVICE DRIVER Entrypoint
// // // ==========================================
// // Future<void> main() async {
// //   await connectDB();
// //   await connectMQTT();
  
// //   startPostgresListenBridge(); 

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await loginUser(username, password);
// //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String temprature1 = body['temprature1']?.toString() ?? '';
// //       String temprature2 = body['temprature2']?.toString() ?? '';
// //       String temprature3 = body['temprature3']?.toString() ?? '';

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting data_list
// //   router.get('/get-machine-data', (Request request) async {
// //     try {
// //       final logs = await fetchLogsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // ------------------------------------------
// //   // SEPARATE TABLE ROUTES: machine_data
// //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// //   // ------------------------------------------
// //   router.post('/add-machine-record', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? '';
// //       String field2 = body['field_2']?.toString() ?? '';

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting machine_data
// //   router.get('/get-machine-records', (Request request) async {
// //     try {
// //       final logs = await fetchMachineRecordsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// //   await io.serve(handler, '0.0.0.0', 3000);
// //   print("Server engine operational on http://localhost:3000");
// // }



// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Connection conn;
// // late Connection listenConn; 
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. DATABASE CONNECTIVITY (fully local — no cloud)
// // // ==========================================
// // final _pgEndpoint = Endpoint(
// //   host: '192.168.50.167',
// //   port: 5432,
// //   database: 'Railway',
// //   username: 'postgres',
// //   password: 'postgres123',
// // );

// // final _pgSettings = ConnectionSettings(sslMode: SslMode.disable, connectTimeout: const Duration(seconds: 5));

// // // Opens a single connection, retrying every 3s until it succeeds.
// // // On localhost the most common reason this fails is simply that the
// // // PostgreSQL Windows service hasn't started yet — this keeps retrying
// // // until it's up, so you don't have to manually restart the Dart server.
// // Future<Connection> _openConnection() async {
// //   while (true) {
// //     try {
// //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// //     } catch (e) {
// //       print("DB connection failed, retrying in 3s: $e");
// //       print("  (Is the local PostgreSQL service running? Check services.msc → postgresql-x64-...)");
// //       await Future.delayed(const Duration(seconds: 3));
// //     }
// //   }
// // }

// // Future<void> connectDB() async {
// //   conn = await _openConnection();
// //   print("Connected to PostgreSQL (Query Client)");
// //   listenConn = await _openConnection();
// //   print("Connected to PostgreSQL (Listen Client)");
// // }

// // // Runs a query; if it fails because the connection has gone stale,
// // // reopens just the query connection and retries the action once before giving up.
// // Future<T> _withRetry<T>(Future<T> Function() action) async {
// //   try {
// //     return await action();
// //   } catch (e) {
// //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// //     conn = await _openConnection();
// //     return await action();
// //   }
// // }

// // // ==========================================
// // // 2. MQTT CLIENT PUBLISHER
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;
// //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection failure: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // // ==========================================
// // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // ==========================================
// // Future<void> startPostgresListenBridge() async {
// //   await listenConn.execute('LISTEN machine_channel');
// //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// //   listenConn.channels['machine_channel'].listen((String payload) {
// //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       final builder = MqttClientPayloadBuilder();
// //       builder.addString(payload);

// //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //     } else {
// //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //     }
// //   });
// // }

// // // ==========================================
// // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // ==========================================
// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('SELECT * FROM users WHERE username=@username'),
// //     parameters: {'username': username.trim()},
// //   ));

// //   if (result.isNotEmpty) {
// //     final row = result.first;
// //     String dbPassword = row[2].toString();

// //     if (dbPassword == password) {
// //       return {"success": true, "message": "Login successful", "username": username};
// //     }
// //   }
// //   return {"success": false, "message": "Invalid username or password"};
// // }

// // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all logs from target table data_list
// // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// //   ));
  
// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "temprature1": map["temprature1"],
// //       "temprature2": map["temprature2"],
// //       "temprature3": map["temprature3"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ------------------------------------------
// // // SEPARATE TABLE: machine_data
// // // (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // // This is a completely independent table/endpoint pair from data_list above —
// // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // ------------------------------------------

// // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// // Future<Map<String, dynamic>> insertMachineRecord(
// //   String motorType, String machineId, String testId, String operationName, String field1, String field2
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2)
// //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all rows from target table machine_data
// // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, created_at FROM machine_data ORDER BY id ASC'
// //   ));

// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "operation_name": map["operation_name"],
// //       "field_1": map["field_1"],
// //       "field_2": map["field_2"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ==========================================
// // // 5. MAIN SERVICE DRIVER Entrypoint
// // // ==========================================
// // Future<void> main() async {
// //   // Only Postgres is required for login/dashboard/form routes to work,
// //   // so that's the only thing we block server startup on.
// //   await connectDB();

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await loginUser(username, password);
// //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String temprature1 = body['temprature1']?.toString() ?? '';
// //       String temprature2 = body['temprature2']?.toString() ?? '';
// //       String temprature3 = body['temprature3']?.toString() ?? '';

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting data_list
// //   router.get('/get-machine-data', (Request request) async {
// //     try {
// //       final logs = await fetchLogsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // ------------------------------------------
// //   // SEPARATE TABLE ROUTES: machine_data
// //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// //   // ------------------------------------------
// //   router.post('/add-machine-record', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? '';
// //       String field2 = body['field_2']?.toString() ?? '';

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting machine_data
// //   router.get('/get-machine-records', (Request request) async {
// //     try {
// //       final logs = await fetchMachineRecordsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// //   await io.serve(handler, '0.0.0.0', 3000);
// //   print("Server engine operational on http://localhost:3000");

// //   // Login, the form, and the dashboard never depend on this — it's purely
// //   // for the live MQTT telemetry bridge, so it runs in the background and
// //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// //   unawaited(_startRealtimeBridgeInBackground());
// // }

// // Future<void> _startRealtimeBridgeInBackground() async {
// //   try {
// //     await connectMQTT();
// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       await startPostgresListenBridge();
// //     } else {
// //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
// //     }
// //   } catch (e) {
// //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// //   }
// // }




// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:postgres/postgres.dart';
// // import 'package:shelf/shelf.dart';
// // import 'package:shelf/shelf_io.dart' as io;
// // import 'package:shelf_router/shelf_router.dart';
// // import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// // import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'package:mqtt_client/mqtt_client.dart';

// // late Connection conn;
// // late Connection listenConn; 
// // late MqttServerClient mqttClient;

// // // ==========================================
// // // 1. DATABASE CONNECTIVITY (Neon — cloud Postgres)
// // // ==========================================
// // final _pgEndpoint = Endpoint(
// //   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
// //   port: 5432,
// //   database: 'neondb',
// //   username: 'neondb_owner',
// //   password: 'npg_mT9C4KeOaJVN',
// // );

// // // Neon requires SSL — connections without it are rejected outright, unlike
// // // the local setup this replaces.
// // final _pgSettings = ConnectionSettings(sslMode: SslMode.require, connectTimeout: const Duration(seconds: 10));

// // // Opens a single connection, retrying every 3s until it succeeds.
// // // Neon's free tier auto-suspends the database after a period of
// // // inactivity — the first connection after a quiet spell can take a few
// // // seconds while it wakes back up, so this keeps retrying instead of
// // // giving up after one failed attempt.
// // Future<Connection> _openConnection() async {
// //   while (true) {
// //     try {
// //       return await Connection.open(_pgEndpoint, settings: _pgSettings);
// //     } catch (e) {
// //       print("DB connection failed, retrying in 3s: $e");
// //       print("  (If this persists, check your internet connection and the project status on the Neon dashboard.)");
// //       await Future.delayed(const Duration(seconds: 3));
// //     }
// //   }
// // }

// // Future<void> connectDB() async {
// //   conn = await _openConnection();
// //   print("Connected to PostgreSQL (Query Client)");
// //   listenConn = await _openConnection();
// //   print("Connected to PostgreSQL (Listen Client)");
// // }

// // // Runs a query; if it fails because the connection has gone stale,
// // // reopens just the query connection and retries the action once before giving up.
// // Future<T> _withRetry<T>(Future<T> Function() action) async {
// //   try {
// //     return await action();
// //   } catch (e) {
// //     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
// //     conn = await _openConnection();
// //     return await action();
// //   }
// // }

// // // ==========================================
// // // 2. MQTT CLIENT PUBLISHER
// // // ==========================================
// // Future<void> connectMQTT() async {
// //   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
// //   mqttClient.port = 1883;
// //   mqttClient.logging(on: false);
// //   mqttClient.keepAlivePeriod = 20;
// //   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

// //   try {
// //     print('Connecting to MQTT Broker...');
// //     await mqttClient.connect();
// //     print('Connected to MQTT Broker successfully!');
// //   } catch (e) {
// //     print('MQTT Connection failure: $e');
// //     mqttClient.disconnect();
// //   }
// // }

// // // ==========================================
// // // 3. POSTGRES LISTEN -> MQTT BRIDGE WORKER
// // // ==========================================
// // Future<void> startPostgresListenBridge() async {
// //   await listenConn.execute('LISTEN machine_channel');
// //   print("PostgreSQL background loop actively listening to channel: machine_channel");

// //   listenConn.channels['machine_channel'].listen((String payload) {
// //     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       final builder = MqttClientPayloadBuilder();
// //       builder.addString(payload);

// //       mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
// //       print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
// //     } else {
// //       print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
// //     }
// //   });
// // }

// // // ==========================================
// // // 4. BUSINESS LOGIC DATABASE QUERIES
// // // ==========================================
// // Future<Map<String, dynamic>> loginUser(String username, String password) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('SELECT * FROM users WHERE username=@username'),
// //     parameters: {'username': username.trim()},
// //   ));

// //   if (result.isNotEmpty) {
// //     final row = result.first;
// //     String dbPassword = row[2].toString();

// //     if (dbPassword == password) {
// //       return {"success": true, "message": "Login successful", "username": username};
// //     }
// //   }
// //   return {"success": false, "message": "Invalid username or password"};
// // }

// // // Inserts a new row into data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// // Future<Map<String, dynamic>> insertMachineData(
// //   String motorType, String machineId, String testId, String temprature1, String temprature2, String temprature3
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO data_list (motor_type, machine_id, test_id, temprature1, temprature2, temprature3)
// //       VALUES (@motor_type, @machine_id, @test_id, @temprature1, @temprature2, @temprature3)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "temprature1": double.tryParse(temprature1) ?? 0.0,
// //       "temprature2": double.tryParse(temprature2) ?? 0.0,
// //       "temprature3": double.tryParse(temprature3) ?? 0.0,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all logs from target table data_list
// // Future<List<Map<String, dynamic>>> fetchLogsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, temprature1, temprature2, temprature3, created_at FROM data_list ORDER BY id ASC'
// //   ));
  
// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "temprature1": map["temprature1"],
// //       "temprature2": map["temprature2"],
// //       "temprature3": map["temprature3"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ------------------------------------------
// // // SEPARATE TABLE: machine_data
// // // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // This is a completely independent table/endpoint pair from data_list above —
// // // it powers the Log Entry form only. The dashboard keeps reading data_list.
// // // ------------------------------------------

// // // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // // status: 1 = Start, 0 = Stop
// // Future<Map<String, dynamic>> insertMachineRecord(
// //   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// // ) async {
// //   final result = await _withRetry(() => conn.execute(
// //     Sql.named('''
// //       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// //       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2, @status)
// //       RETURNING *
// //     '''),
// //     parameters: {
// //       "motor_type": motorType,
// //       "machine_id": machineId,
// //       "test_id": testId,
// //       "operation_name": operationName,
// //       "field_1": field1,
// //       "field_2": field2,
// //       "status": status,
// //     },
// //   ));

// //   return {"success": true, "record": result.first.toColumnMap().toString()};
// // }

// // // Query Function to select all rows from target table machine_data
// // Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
// //   final result = await _withRetry(() => conn.execute(
// //     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, status, created_at FROM machine_data ORDER BY id ASC'
// //   ));

// //   return result.map((row) {
// //     final map = row.toColumnMap();
// //     return {
// //       "id": map["id"],
// //       "motor_type": map["motor_type"],
// //       "machine_id": map["machine_id"],
// //       "test_id": map["test_id"],
// //       "operation_name": map["operation_name"],
// //       "field_1": map["field_1"],
// //       "field_2": map["field_2"],
// //       "status": map["status"],
// //       "created_at": map["created_at"]?.toString(),
// //     };
// //   }).toList();
// // }

// // // ==========================================
// // // 5. MAIN SERVICE DRIVER Entrypoint
// // // ==========================================
// // Future<void> main() async {
// //   // Only Postgres is required for login/dashboard/form routes to work,
// //   // so that's the only thing we block server startup on.
// //   await connectDB();

// //   final router = Router();

// //   router.post('/login', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());
// //       String username = body['username']?.toString() ?? '';
// //       String password = body['password']?.toString() ?? '';

// //       if (username.isEmpty || password.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "Username/Password required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await loginUser(username, password);
// //       return Response(result["success"] ? 200 : 401, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   router.post('/add-machine-data', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String temprature1 = body['temprature1']?.toString() ?? '';
// //       String temprature2 = body['temprature2']?.toString() ?? '';
// //       String temprature3 = body['temprature3']?.toString() ?? '';

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || temprature1.isEmpty || temprature2.isEmpty || temprature3.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineData(motorType, machineId, testId, temprature1, temprature2, temprature3);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting data_list
// //   router.get('/get-machine-data', (Request request) async {
// //     try {
// //       final logs = await fetchLogsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // ------------------------------------------
// //   // SEPARATE TABLE ROUTES: machine_data
// //   // Used only by the Log Entry form — data_list/dashboard routes above are untouched.
// //   // ------------------------------------------
// //   router.post('/add-machine-record', (Request request) async {
// //     try {
// //       final body = jsonDecode(await request.readAsString());

// //       String motorType = body['motor_type']?.toString() ?? '';
// //       String machineId = body['machine_id']?.toString() ?? '';
// //       String testId = body['test_id']?.toString() ?? '';
// //       String operationName = body['operation_name']?.toString() ?? '';
// //       String field1 = body['field_1']?.toString() ?? '';
// //       String field2 = body['field_2']?.toString() ?? '';
// //       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
// //       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

// //       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
// //         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
// //       }

// //       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
// //       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   // GET Endpoint targeting machine_data
// //   router.get('/get-machine-records', (Request request) async {
// //     try {
// //       final logs = await fetchMachineRecordsFromDB();
// //       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
// //     } catch (e) {
// //       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
// //     }
// //   });

// //   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
// //   await io.serve(handler, '0.0.0.0', 3000);
// //   print("Server engine operational on http://Neon:3000");

// //   // Login, the form, and the dashboard never depend on this — it's purely
// //   // for the live MQTT telemetry bridge, so it runs in the background and
// //   // can never block (or re-introduce a multi-minute delay on) the routes above.
// //   unawaited(_startRealtimeBridgeInBackground());
// // }

// // Future<void> _startRealtimeBridgeInBackground() async {
// //   try {
// //     await connectMQTT();
// //     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
// //       await startPostgresListenBridge();
// //     } else {
// //       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
// //     }
// //   } catch (e) {
// //     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
// //   }
// // }



// import 'dart:async';
// import 'dart:convert';
// import 'package:postgres/postgres.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_cors_headers/shelf_cors_headers.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';

// late Connection conn;
// late Connection listenConn; 
// late MqttServerClient mqttClient;

// // ==========================================
// // 1. DATABASE CONNECTIVITY (Neon — cloud Postgres)
// // ==========================================
// final _pgEndpoint = Endpoint(
//   host: 'ep-purple-shape-aopnomz6-pooler.c-2.ap-southeast-1.aws.neon.tech',
//   port: 5432,
//   database: 'neondb',
//   username: 'neondb_owner',
//   password: 'npg_mT9C4KeOaJVN',
// );

// // Neon requires SSL — connections without it are rejected outright, unlike
// // the local setup this replaces.
// final _pgSettings = ConnectionSettings(sslMode: SslMode.require, connectTimeout: const Duration(seconds: 10));

// // Opens a single connection, retrying every 3s until it succeeds.
// // Neon's free tier auto-suspends the database after a period of
// // inactivity — the first connection after a quiet spell can take a few
// // seconds while it wakes back up, so this keeps retrying instead of
// // giving up after one failed attempt.
// Future<Connection> _openConnection() async {
//   while (true) {
//     try {
//       return await Connection.open(_pgEndpoint, settings: _pgSettings);
//     } catch (e) {
//       print("DB connection failed, retrying in 3s: $e");
//       print("  (If this persists, check your internet connection and the project status on the Neon dashboard.)");
//       await Future.delayed(const Duration(seconds: 3));
//     }
//   }
// }

// Future<void> connectDB() async {
//   conn = await _openConnection();
//   print("Connected to PostgreSQL (Query Client)");
//   listenConn = await _openConnection();
//   print("Connected to PostgreSQL (Listen Client)");
// }

// // Runs a query; if it fails because the connection has gone stale,
// // reopens just the query connection and retries the action once before giving up.
// Future<T> _withRetry<T>(Future<T> Function() action) async {
//   try {
//     return await action();
//   } catch (e) {
//     print("Query failed ($e). Reconnecting to PostgreSQL and retrying...");
//     conn = await _openConnection();
//     return await action();
//   }
// }

// // ==========================================
// // 2. MQTT CLIENT PUBLISHER
// // ==========================================
// Future<void> connectMQTT() async {
//   mqttClient = MqttServerClient('broker.hivemq.com', 'postgres_notify_bridge');
//   mqttClient.port = 1883;
//   mqttClient.logging(on: false);
//   mqttClient.keepAlivePeriod = 20;
//   mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

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
// Future<void> startPostgresListenBridge() async {
//   await listenConn.execute('LISTEN machine_channel');
//   print("PostgreSQL background loop actively listening to channel: machine_channel");

//   listenConn.channels['machine_channel'].listen((String payload) {
//     print("\n[DB NOTIFY RECEIVER] New row detected! Payload: $payload");

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
//   final result = await _withRetry(() => conn.execute(
//     Sql.named('SELECT * FROM users WHERE username=@username'),
//     parameters: {'username': username.trim()},
//   ));

//   if (result.isNotEmpty) {
//     final row = result.first;
//     String dbPassword = row[2].toString();

//     if (dbPassword == password) {
//       return {"success": true, "message": "Login successful", "username": username};
//     }
//   }
//   return {"success": false, "message": "Invalid username or password"};
// }

// // ------------------------------------------
// // TABLE: machine_sensor_data
// // (id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// // This is the live telemetry table the Dashboard now reads from — it
// // replaces the old data_list table/endpoint pair entirely. Rows are
// // expected to be written by the sensor/device pipeline (e.g. via the
// // Postgres LISTEN/NOTIFY -> MQTT bridge above), not by this app's UI.
// // ------------------------------------------

// // Query Function to select all rows from target table machine_sensor_data
// Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
//   final result = await _withRetry(() => conn.execute(
//     'SELECT id, amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at FROM machine_sensor_data ORDER BY id ASC'
//   ));

//   return result.map((row) {
//     final map = row.toColumnMap();
//     return {
//       "id": map["id"],
//       "amb_temp": map["amb_temp"],
//       "tm1_fet": map["tm1_fet"],
//       "tm1_ret": map["tm1_ret"],
//       "tm2_fet": map["tm2_fet"],
//       "tm2_ret": map["tm2_ret"],
//       "created_at": map["created_at"]?.toString(),
//     };
//   }).toList();
// }

// // ------------------------------------------
// // SEPARATE TABLE: machine_data
// // (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // This is a completely independent table/endpoint pair from
// // machine_sensor_data above — it powers the Log Entry form only. The
// // dashboard reads machine_sensor_data.
// // ------------------------------------------

// // Inserts a new row into machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// // status: 1 = Start, 0 = Stop
// Future<Map<String, dynamic>> insertMachineRecord(
//   String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
// ) async {
//   final result = await _withRetry(() => conn.execute(
//     Sql.named('''
//       INSERT INTO machine_data (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
//       VALUES (@motor_type, @machine_id, @test_id, @operation_name, @field_1, @field_2, @status)
//       RETURNING *
//     '''),
//     parameters: {
//       "motor_type": motorType,
//       "machine_id": machineId,
//       "test_id": testId,
//       "operation_name": operationName,
//       "field_1": field1,
//       "field_2": field2,
//       "status": status,
//     },
//   ));

//   return {"success": true, "record": result.first.toColumnMap().toString()};
// }

// // Query Function to select all rows from target table machine_data
// Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
//   final result = await _withRetry(() => conn.execute(
//     'SELECT id, motor_type, machine_id, test_id, operation_name, field_1, field_2, status, created_at FROM machine_data ORDER BY id ASC'
//   ));

//   return result.map((row) {
//     final map = row.toColumnMap();
//     return {
//       "id": map["id"],
//       "motor_type": map["motor_type"],
//       "machine_id": map["machine_id"],
//       "test_id": map["test_id"],
//       "operation_name": map["operation_name"],
//       "field_1": map["field_1"],
//       "field_2": map["field_2"],
//       "status": map["status"],
//       "created_at": map["created_at"]?.toString(),
//     };
//   }).toList();
// }

// // ==========================================
// // 5. MAIN SERVICE DRIVER Entrypoint
// // ==========================================
// Future<void> main() async {
//   // Only Postgres is required for login/dashboard/form routes to work,
//   // so that's the only thing we block server startup on.
//   await connectDB();

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

//   // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
//   router.get('/get-sensor-data', (Request request) async {
//     try {
//       final logs = await fetchSensorDataFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // ------------------------------------------
//   // SEPARATE TABLE ROUTES: machine_data
//   // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
//   // ------------------------------------------
//   router.post('/add-machine-record', (Request request) async {
//     try {
//       final body = jsonDecode(await request.readAsString());

//       String motorType = body['motor_type']?.toString() ?? '';
//       String machineId = body['machine_id']?.toString() ?? '';
//       String testId = body['test_id']?.toString() ?? '';
//       String operationName = body['operation_name']?.toString() ?? '';
//       String field1 = body['field_1']?.toString() ?? '';
//       String field2 = body['field_2']?.toString() ?? '';
//       // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
//       int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

//       if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
//         return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
//       }

//       final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
//       return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   // GET Endpoint targeting machine_data
//   router.get('/get-machine-records', (Request request) async {
//     try {
//       final logs = await fetchMachineRecordsFromDB();
//       return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
//     } catch (e) {
//       return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
//     }
//   });

//   final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
//   await io.serve(handler, '0.0.0.0', 3000);
//   print("Server engine operational on http://Neon:3000");

//   // Login, the form, and the dashboard never depend on this — it's purely
//   // for the live MQTT telemetry bridge, so it runs in the background and
//   // can never block (or re-introduce a multi-minute delay on) the routes above.
//   unawaited(_startRealtimeBridgeInBackground());
// }

// Future<void> _startRealtimeBridgeInBackground() async {
//   try {
//     await connectMQTT();
//     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//       await startPostgresListenBridge();
//     } else {
//       print("Skipping Postgres->MQTT bridge — MQTT broker unreachable right now.");
//     }
//   } catch (e) {
//     print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

late Db db;
late MqttServerClient mqttClient;

// ==========================================
// 1. DATABASE CONNECTIVITY (MongoDB Atlas)
// ==========================================
// SECURITY NOTE: this mirrors the pattern in the original Postgres file
// (credentials hardcoded in source), but since this URI has now been
// pasted into a chat, treat the password as compromised — rotate it in
// Atlas ("Database Access" -> edit user -> new password) and, ideally,
// load the URI from an environment variable instead of committing it:
//   final uri = Platform.environment['MONGO_URI'] ?? _mongoUri;
const String _mongoUri =
    'mongodb+srv://Railway:Erode@cluster0.uxm1j2y.mongodb.net/Railway?retryWrites=true&w=majority';

// Opens a single connection, retrying every 3s until it succeeds — same
// resilience behavior as the old _openConnection() for Neon (Atlas free
// tier doesn't auto-suspend the way Neon's does, but a transient network
// blip on first boot is still worth retrying through).
Future<Db> _openConnection() async {
  while (true) {
    try {
      final database = await Db.create(_mongoUri);
      await database.open();
      return database;
    } catch (e) {
      print("DB connection failed, retrying in 3s: $e");
      print("  (If this persists, check your internet connection and the cluster status on the Atlas dashboard.)");
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}

Future<void> connectDB() async {
  db = await _openConnection();
  print("Connected to MongoDB (database: ${db.databaseName})");
}

// Runs a query; if it fails because the connection has gone stale,
// reopens the connection and retries the action once before giving up.
Future<T> _withRetry<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (e) {
    print("Query failed ($e). Reconnecting to MongoDB and retrying...");
    db = await _openConnection();
    return await action();
  }
}

// ==========================================
// 2. MQTT CLIENT PUBLISHER
// ==========================================
Future<void> connectMQTT() async {
  mqttClient = MqttServerClient('broker.hivemq.com', 'mongo_notify_bridge');
  mqttClient.port = 1883;
  mqttClient.logging(on: false);
  mqttClient.keepAlivePeriod = 20;
  mqttClient.connectTimeoutPeriod = 8000; // ms — fail fast instead of hanging on a blocked/slow network

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
// 3. MONGODB CHANGE STREAM -> MQTT BRIDGE WORKER
// ==========================================
// Postgres LISTEN/NOTIFY has no direct MongoDB equivalent. The closest match
// is a Change Stream on the collection, which watches for inserts/updates in
// (near) real time. Change Streams require the deployment to be a replica
// set — Atlas clusters (including the free M0 tier) already are one, so
// this works without extra setup.
//
Future<void> startMongoChangeStreamBridge() async {
  final collection = db.collection('machine_sensor_data');
  // First positional arg is an aggregation pipeline to filter/shape events
  // (empty list = no filtering, receive every change). `fullDocument:
  // 'updateLookup'` makes update events include the complete document
  // instead of just the changed fields.
  final stream = collection.watch(
    <Map<String, Object>>[],
    changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'),
  );

  print("MongoDB change stream actively watching collection: machine_sensor_data");

  stream.listen((event) {
    final doc = event.fullDocument;
    if (doc == null) return;

    final payload = jsonEncode(_sensorRowToJson(doc));
    print("\n[DB CHANGE RECEIVER] New/changed document detected! Payload: $payload");

    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);

      mqttClient.publishMessage('machine/metrics', MqttQos.atLeastOnce, builder.payload!);
      print("[MQTT BRIDGE] Successfully forwarded notification data to topic: machine/metrics");
    } else {
      print("[MQTT BRIDGE ERROR] MQTT Client offline, unable to bridge broadcast.");
    }
  }, onError: (e) {
    print("[MQTT BRIDGE ERROR] Change stream error: $e");
  });
}

// ==========================================
// 4. BUSINESS LOGIC DATABASE QUERIES
// ==========================================
Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final row = await _withRetry(
    () => db.collection('Users').findOne(where.eq('username', username.trim())),
  );

  if (row != null) {
    // ASSUMPTION: the `users` collection has a `password` field (the old
    // Postgres code read column index 2 positionally). Rename this key to
    // match your actual document shape if it differs.
    final dbPassword = row['password']?.toString() ?? '';

    if (dbPassword == password) {
      return {"success": true, "message": "Login successful", "username": username};
    }
  }
  return {"success": false, "message": "Invalid username or password"};
}

// ------------------------------------------
// COLLECTION: machine_sensor_data
// (amb_temp, tm1_fet, tm1_ret, tm2_fet, tm2_ret, created_at)
// This is the live telemetry collection the Dashboard reads from. Rows are
// expected to be written by the sensor/device pipeline (e.g. via whatever
// replaces the old MQTT->Postgres path on the device side), not by this
// app's UI.
// ------------------------------------------

// Turns a raw Mongo document into the JSON shape the Flutter app expects.
// `_id` (a Mongo ObjectId) is exposed as `id` (its hex string) since the
// app just uses it as an opaque, ascending-over-time sort/display key —
// ObjectId hex strings sort lexicographically in the same order they were
// created, so ascending string sort == chronological order.
Map<String, dynamic> _sensorRowToJson(Map<String, dynamic> row) {
  return {
    "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
    "amb_temp": row["amb_temp"],
    "tm1_fet": row["tm1_fet"],
    "tm1_ret": row["tm1_ret"],
    "tm2_fet": row["tm2_fet"],
    "tm2_ret": row["tm2_ret"],
    "created_at": row["created_at"]?.toString(),
  };
}

// Query Function to select all rows from target collection machine_sensor_data
Future<List<Map<String, dynamic>>> fetchSensorDataFromDB() async {
  // Sort ascending by _id (chronological) — same intent as the old
  // `ORDER BY id ASC`.
  //
  // IMPORTANT FRONTEND NOTE: the Flutter dashboard re-sorts rows client-side
  // by parsing `id` as a number (`num.tryParse(row['id'])`). ObjectId hex
  // strings aren't numeric, so that parse will yield 0 for every row and
  // the client-side sort becomes a no-op — which is harmless *only because*
  // this query already returns rows in the correct chronological order. If
  // you ever change this query to sort differently, update the Flutter
  // sort comparator to parse `created_at` as a DateTime instead of `id`.
  final rows = await _withRetry(
    () => db.collection('machine_sensor_data').find(where.sortBy('_id')).toList(),
  );

  return rows.map(_sensorRowToJson).toList();
}

// ------------------------------------------
// SEPARATE COLLECTION: machine_data
// (motor_type, machine_id, test_id, operation_name, field_1, field_2, status)
// Completely independent from machine_sensor_data above — it powers the Log
// Entry form only. The dashboard reads machine_sensor_data.
// ------------------------------------------

// Inserts a new document into machine_data.
// status: 1 = Start, 0 = Stop
Future<Map<String, dynamic>> insertMachineRecord(
  String motorType, String machineId, String testId, String operationName, String field1, String field2, int status
) async {
  final doc = {
    "motor_type": motorType,
    "machine_id": machineId,
    "test_id": testId,
    "operation_name": operationName,
    "field_1": field1,
    "field_2": field2,
    "status": status,
    "created_at": DateTime.now().toUtc(),
  };

  final result = await _withRetry(() => db.collection('machine_data').insertOne(doc));

  return {
    "success": result.isSuccess,
    "record": {
      "id": (result.id is ObjectId) ? (result.id as ObjectId).oid : result.id?.toString(),
      ...doc,
      "created_at": doc["created_at"].toString(),
    }.toString(),
  };
}

// Query Function to select all rows from target collection machine_data
Future<List<Map<String, dynamic>>> fetchMachineRecordsFromDB() async {
  final rows = await _withRetry(
    () => db.collection('machine_data').find(where.sortBy('_id')).toList(),
  );

  return rows.map((row) {
    return {
      "id": (row["_id"] is ObjectId) ? (row["_id"] as ObjectId).oid : row["_id"]?.toString(),
      "motor_type": row["motor_type"],
      "machine_id": row["machine_id"],
      "test_id": row["test_id"],
      "operation_name": row["operation_name"],
      "field_1": row["field_1"],
      "field_2": row["field_2"],
      "status": row["status"],
      "created_at": row["created_at"]?.toString(),
    };
  }).toList();
}

// ==========================================
// 5. MAIN SERVICE DRIVER Entrypoint
// ==========================================
Future<void> main() async {
  // Only MongoDB is required for login/dashboard/form routes to work,
  // so that's the only thing we block server startup on.
  await connectDB();

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

  // GET Endpoint targeting machine_sensor_data — powers the Dashboard charts.
  router.get('/get-sensor-data', (Request request) async {
    try {
      final logs = await fetchSensorDataFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  // ------------------------------------------
  // SEPARATE COLLECTION ROUTES: machine_data
  // Used only by the Log Entry form — machine_sensor_data/dashboard routes above are untouched.
  // ------------------------------------------
  router.post('/add-machine-record', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());

      String motorType = body['motor_type']?.toString() ?? '';
      String machineId = body['machine_id']?.toString() ?? '';
      String testId = body['test_id']?.toString() ?? '';
      String operationName = body['operation_name']?.toString() ?? '';
      String field1 = body['field_1']?.toString() ?? '';
      String field2 = body['field_2']?.toString() ?? '';
      // status: 1 = Start, 0 = Stop. Defaults to 1 if missing for backward compatibility.
      int status = int.tryParse(body['status']?.toString() ?? '') ?? 1;

      if (motorType.isEmpty || machineId.isEmpty || testId.isEmpty || operationName.isEmpty || field1.isEmpty || field2.isEmpty) {
        return Response(400, body: jsonEncode({"message": "All fields are required"}), headers: {"Content-Type": "application/json"});
      }

      final result = await insertMachineRecord(motorType, machineId, testId, operationName, field1, field2, status);
      return Response(201, body: jsonEncode(result), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  // GET Endpoint targeting machine_data
  router.get('/get-machine-records', (Request request) async {
    try {
      final logs = await fetchMachineRecordsFromDB();
      return Response.ok(jsonEncode(logs), headers: {"Content-Type": "application/json"});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({"message": e.toString()}));
    }
  });

  final handler = Pipeline().addMiddleware(corsHeaders()).addMiddleware(logRequests()).addHandler(router.call);
  await io.serve(handler, '0.0.0.0', 3000);
  print("Server engine operational on http://MongoDB:3000");

  // Login, the form, and the dashboard never depend on this — it's purely
  // for the live MQTT telemetry bridge, so it runs in the background and
  // can never block (or re-introduce a multi-minute delay on) the routes above.
  unawaited(_startRealtimeBridgeInBackground());
}

Future<void> _startRealtimeBridgeInBackground() async {
  try {
    await connectMQTT();
    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      await startMongoChangeStreamBridge();
    } else {
      print("Skipping Mongo->MQTT bridge — MQTT broker unreachable right now.");
    }
  } catch (e) {
    print("Realtime bridge failed to start (non-fatal, login/dashboard unaffected): $e");
  }
}