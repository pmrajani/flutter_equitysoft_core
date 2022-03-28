import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
  ),
);

final Logger loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
