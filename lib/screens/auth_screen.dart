// Project imports:
import 'package:plexlit/plexlit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            PlexLoginButton(),
          ],
        ),
      ),
    );
  }
}
