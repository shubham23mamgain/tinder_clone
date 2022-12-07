import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/provider/card_provider.dart';
import 'package:tinder_clone/widgets/tinder_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = User(
    name: "Steffi",
    age: 20,
    urlImage:
        "https://i.pinimg.com/736x/d0/7a/f6/d07af684a67cd52d2f10acd6208db98f.jpg",
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade200,
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(height: 12),
                Expanded(
                  child: buildCards(),
                ),
                const SizedBox(height: 16),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    return users.isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.resetUsers();
              },
              child: const Text(
                "Restart",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        : Stack(
            children: users
                .map(
                  (user) => TinderCard(
                    user: user,
                    isFront: users.last == user,
                  ),
                )
                .toList(),
          );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    return users.isEmpty
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.dislike();
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.superlike();
                },
                child: const Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: 36,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.like();
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.teal,
                  size: 36,
                ),
              ),
            ],
          );
  }

  Widget buildLogo() => Row(
        children: const [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(width: 4),
          Text(
            "Tinder",
            style: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
}
