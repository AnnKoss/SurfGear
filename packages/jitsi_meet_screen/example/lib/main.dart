// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:jitsi_meet_screen/jitsi_meet_screen.dart';
import 'package:permission/base/permission_manager.dart';
import 'package:permission/impl/default_permission_manager.dart';
import 'package:permission/impl/strategy/default_proceed_permission_strategy_storage.dart';
import 'package:permission/impl/strategy/proceed_permission_strategy_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final jitsiScreenController = JitsiMeetScreenController(
    // ignore: avoid_print
    () => print('join'),
    // ignore: avoid_print
    () => print('will join'),
    // ignore: avoid_print
    () => print('terminated'),
  );
  final controller = TextEditingController();

  final permissions = DefaultPermissionManager(
    DefaultProceedPermissionStrategyStorage(
      strategies: {},
      defaultStrategy: ProceedPermissionStrategyExample(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextField(
                  controller: controller,
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  final camera = await permissions.request(Permission.camera);
                  final microphone = await permissions.request(
                    Permission.microphone,
                  );
                  if (camera && microphone) {
                    // ignore: unawaited_futures
                    jitsiScreenController.joinRoom(
                      controller.value.text,
                      audioMuted: true,
                    );
                  }
                },
                child: const Text('Join room'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
