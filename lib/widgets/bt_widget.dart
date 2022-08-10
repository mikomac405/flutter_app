import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Column btWidget(context, isConnecting, refresh) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orange,
          size: 200,
        )),
        ElevatedButton(
          onPressed: isConnecting ? null : refresh,
          child: const Text("Scan for devices"),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20.0))
      ],
    );
