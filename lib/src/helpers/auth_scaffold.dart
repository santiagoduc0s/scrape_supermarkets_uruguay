import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrape_supermarkets_uruguay/src/facades/facades.dart';
import 'package:scrape_supermarkets_uruguay/src/features/features.dart';

class AuthScaffold extends StatefulWidget {
  const AuthScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> {
  @override
  void initState() {
    super.initState();

    Security.instance.stream.listen((event) {
      if (!context.mounted) return;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRequiredCheckBiometric = Security.instance.isRequiredCheckBiometric;

    return Stack(
      children: [
        widget.child,
        if (isRequiredCheckBiometric)
          BlocProvider(
            lazy: false,
            create: (context) => LockBloc()..add(LockApp()),
            child: const UnlockPage(),
          ),
      ],
    );
  }
}
