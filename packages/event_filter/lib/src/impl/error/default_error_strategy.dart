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

import 'package:event_filter/event_filter.dart';
import 'package:event_filter/src/impl/error/error_event.dart';

/// Default strategy of processing event.
class DefaultErrorStrategy extends EventStrategy<ErrorEvent> {
  @override
  void doResolve(ErrorEvent event) {
    // ignore: avoid_print
    print('DEV_ERROR ${event.data}');
  }
}
