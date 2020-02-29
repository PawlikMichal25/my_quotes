import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Toast {
  static void show({
    @required String message,
    @required BuildContext context,
    Icon icon,
    Color backgroundColor = const Color(0xFF424242),
    Color textColor = Colors.white,
  }) {
    assert(message != null);
    assert(context != null);

    _show(icon, message, context, backgroundColor, textColor);
  }

  static void _show(
    Icon icon,
    String message,
    BuildContext context,
    Color backgroundColor,
    Color textColor,
  ) async {
    final overlayState = Overlay.of(context);

    final _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: _Toast(
              icon: icon,
              message: message,
              backgroundColor: backgroundColor,
              textColor: textColor,
            ),
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry);
    await Future<void>.delayed(Duration(seconds: 2000));
    _overlayEntry?.remove();
  }
}

class _Toast extends StatefulWidget {
  final Icon icon;
  final String message;
  final Color backgroundColor;
  final Color textColor;

  _Toast({
    this.icon,
    this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
    );
    _animationController.forward();
    _scheduleFadeOut();
  }

  void _scheduleFadeOut() async {
    await Future<void>.delayed(Duration(milliseconds: 1500));
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController.drive(CurveTween(curve: Curves.easeOut)),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: widget.icon == null ? _buildTextOnly() : _buildTextWithIcon(),
      ),
    );
  }

  Widget _buildTextOnly() {
    return Text(
      widget.message,
      softWrap: true,
      style: TextStyle(fontSize: 15, color: widget.textColor),
    );
  }

  Widget _buildTextWithIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.icon,
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              widget.message,
              softWrap: true,
              style: TextStyle(fontSize: 15, color: widget.textColor),
            ),
          ),
        ),
      ],
    );
  }
}
