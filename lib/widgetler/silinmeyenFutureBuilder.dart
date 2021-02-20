import 'package:flutter/material.dart';

class SilinmeyenFutureBuilder extends StatefulWidget {
  final Future future;
  final AsyncWidgetBuilder builder;

  const SilinmeyenFutureBuilder({Key key, this.future, this.builder})
      : super(key: key);
  @override
  _SilinmeyenFutureBuilderState createState() =>
      _SilinmeyenFutureBuilderState();
}

class _SilinmeyenFutureBuilderState extends State<SilinmeyenFutureBuilder>
    with AutomaticKeepAliveClientMixin<SilinmeyenFutureBuilder> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      builder: widget.builder,
      future: widget.future,
    );
  }
}

/**
 *  bu kullanımda hem kaydırma yaparken sıçramalar olmaz ve başka sayfaya gidip geldiğimizde ekrandaki görüntü
 *  yukarıya gitmez kaldığımız yerden devam ederiz.
 * 
 * 
 */
