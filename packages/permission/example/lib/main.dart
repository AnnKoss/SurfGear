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
import 'package:permission/base/exceptions.dart';
import 'package:permission/base/permission_manager.dart';
import 'package:permission/impl/default_permission_manager.dart';
import 'package:permission/permission.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProceedPermissionStrategyStorage _strategyStorage;
  PermissionManager _permissionManager;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _strategyStorage = DefaultProceedPermissionStrategyStorage(
      strategies: {},
      defaultStrategy: ProceedPermissionStrategyExample(),
    );
    _permissionManager = DefaultPermissionManager(_strategyStorage);

    super.initState();
  }

  Future<void> _requestPermission(Permission permission) async {
    try {
      final granted = await _permissionManager.request(
        permission,
        checkRationale: true,
      );

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(granted ? 'Permission granted' : 'Permission denied'),
        ),
      );
    } on FeatureProhibitedException catch (_) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('User prohibited this feature'),
              FlatButton(
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => _permissionManager.openSettings(),
                child: const Text('Show settings'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var permission in Permission.values)
              FlatButton(
                onPressed: () => _requestPermission(permission),
                child: Text(permission.toString()),
              )
          ],
        ),
      ),
    );
  }
}
