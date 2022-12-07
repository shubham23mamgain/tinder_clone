import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user.dart';

enum CardStatus { like, dislike, superlike }

class CardProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  Size _screenSize = Size.zero;
  double _angle = 0;
  List<User> get users => _users;
  double get angle => _angle;

  void resetUsers() {
    _users = <User>[
      User(
        name: "Steffi",
        age: 20,
        urlImage:
            "https://i.pinimg.com/736x/d0/7a/f6/d07af684a67cd52d2f10acd6208db98f.jpg",
      ),
      User(
        name: "Arundati",
        age: 24,
        urlImage:
            "https://1.bp.blogspot.com/-4l0CGOzR_2s/YGAWcctx5XI/AAAAAAAAVkU/ziLQpEpGhFUyhAyz76IUgaHnEibKanltACLcBGAsYHQ/w528-h640/5.jpg",
      ),
      User(
        name: "Sapna",
        age: 24,
        urlImage:
            "https://cdn2.sharechat.com/Beautifulgirls_31677efc_1630989052561_sc_cmprsd_40.jpg",
      ),
      User(
        name: "Himani",
        age: 20,
        urlImage:
            "https://funkylife.in/wp-content/uploads/2022/09/girl-dp-image-260.jpg",
      ),
      User(
        name: "Kalpana",
        age: 18,
        urlImage:
            "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh91F8T2aDWNG2L16sE23PK0MdfxYVrQbVRQfc-kciqIP0p7yvXae451CUaTizCLEFIgAyeuO-kM_bwcXR8qrxB9EnLZZP9vI0oL7ESR8IbELB12E8muiNWLM-kLjSbqnxrBSqWPl4XLCIPb-0WTn3kHw8hsNom-SfCNc-d7aam2H3ka_LgphcyJnlC/s812/hv33.jpg",
      ),
      User(
        name: "Divya",
        age: 25,
        urlImage:
            "https://images.statusfacebook.com/profile_pictures/real-desi-girls/desi-girl-profile-pic-09.jpg",
      ),
    ].reversed.toList();

    notifyListeners();
  }

  CardProvider() {
    resetUsers();
  }
  Future _nextCard() async {
    if (_users.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superlike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;
  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void resetPosition() {
    _isDragging = false;
    _angle = 0;
    _position = Offset.zero;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
        fontSize: 36,
      );
    }
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superlike:
        superlike();
        break;
      default:
    }
    resetPosition();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;

    final forceSuperLike = x.abs() < 20;

    if (force) {
      const delta = 100;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superlike;
      }
    } else {
      const delta = 20;
      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superlike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
  }
}
