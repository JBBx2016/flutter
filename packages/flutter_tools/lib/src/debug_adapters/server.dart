// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:dds/dap.dart' hide DapServer;

import '../base/file_system.dart';
import '../base/platform.dart';
import '../debug_adapters/flutter_adapter.dart';
import '../debug_adapters/flutter_adapter_args.dart';

/// A DAP server that communicates over a [ByteStreamServerChannel], usually constructed from the processes stdin/stdout streams.
///
/// The server is intended to be single-use. It should live only for the
/// duration of a single debug session in the editor, and terminate when the
/// user stops debugging. If a user starts multiple debug sessions
/// simultaneously it is expected that the editor will start multiple debug
/// adapters.
class DapServer {
  DapServer(
    Stream<List<int>> _input,
    StreamSink<List<int>> _output, {
    required FileSystem fileSystem,
    required Platform platform,
    this.ipv6 = false,
    this.enableDds = true,
    this.enableAuthCodes = true,
    this.logger,
  }) : channel = ByteStreamServerChannel(_input, _output, logger) {
    adapter = FlutterDebugAdapter(channel,
        fileSystem: fileSystem,
        platform: platform,
        ipv6: ipv6,
        enableDds: enableDds,
        enableAuthCodes: enableAuthCodes,
        logger: logger);
  }

  final ByteStreamServerChannel channel;
  late final DartDebugAdapter<FlutterLaunchRequestArguments, FlutterAttachRequestArguments> adapter;
  final bool ipv6;
  final bool enableDds;
  final bool enableAuthCodes;
  final Logger? logger;

  void stop() {
    channel.close();
  }
}
