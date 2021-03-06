// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TrackingScrollController saves offset',
      (WidgetTester tester) async {
    final TrackingScrollController controller = new TrackingScrollController();
    final double listItemHeight = 100.0;

    await tester.pumpWidget(
      new Directionality(
        textDirection: TextDirection.ltr,
        child: new PageView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new ListView(
              controller: controller,
              children: new List<Widget>.generate(
                10,
                (int i) => new Container(
                  height: listItemHeight,
                  child: new Text('Page$index-Item$i'),
                ),
              ).toList(),
            );
          },
        ),
      ),
    );

    expect(find.text('Page0-Item1'), findsOneWidget);
    expect(find.text('Page1-Item1'), findsNothing);
    expect(find.text('Page2-Item0'), findsNothing);
    expect(find.text('Page2-Item1'), findsNothing);

    controller.jumpTo(listItemHeight + 10);
    await (tester.pumpAndSettle());

    await tester.fling(find.text('Page0-Item1'), const Offset(-100.0, 0.0), 10000.0);
    await (tester.pumpAndSettle());

    expect(find.text('Page0-Item1'), findsNothing);
    expect(find.text('Page1-Item1'), findsOneWidget);
    expect(find.text('Page2-Item0'), findsNothing);
    expect(find.text('Page2-Item1'), findsNothing);

    await tester.fling(find.text('Page1-Item1'), const Offset(-100.0, 0.0), 10000.0);
    await (tester.pumpAndSettle());

    expect(find.text('Page0-Item1'), findsNothing);
    expect(find.text('Page1-Item1'), findsNothing);
    expect(find.text('Page2-Item0'), findsNothing);
    expect(find.text('Page2-Item1'), findsOneWidget);

    await tester.pumpWidget(const Text('Another page', textDirection: TextDirection.ltr));

    expect(controller.initialScrollOffset, 0.0);
  });
}
