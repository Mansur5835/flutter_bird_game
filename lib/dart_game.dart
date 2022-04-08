import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DartGame extends StatefulWidget {
  const DartGame({Key? key}) : super(key: key);

  @override
  _DartGame createState() {
    return _DartGame();
  }
}

enum Case { ATACK, BIRD_SLEEPED, BIRD_DOWN }

class _DartGame extends State<DartGame> {
  double dartX = 0;
  double dartY = 2;
  double boardX = 1.4;
  double boardY = -1;

  double? stopY;

  double rukaY = 1;

  int index = 1;
  int rukaIndex = 1;
  int birdIndex = 1;
  bool tray = true;
  bool up = true;
  Enum? action;
  int decoration = Random().nextInt(4);

  bool stopG = false;
  bool atackBird = true;
  int result = 0;
  int gameOver = 0;
  double gameOpacity = 0;
  int speedGame = 0;

  atack() {
    if (atackBird) {
      action = Case.ATACK;
      dartY = 0.84;
    }
  }

  stopGame() {
    stopG = true;
    result = 0;
    setState(() {
      boardX = 1.4;
    });
  }

  startGame() {
    stopG = false;
    if (decoration == 0 || decoration == 1) {
      boardY = -1;
    } else {
      boardY = -0.5;
    }
    if (decoration == 0 || decoration == 2) {
      birdIndex = 1;
    } else {
      birdIndex = 10;
    }

    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if ((gameOver % 3 == 0) && (gameOver != 0)) {
        gameOpacity = 0.8;
        timer.cancel();
      }
      if (stopG) {
        timer.cancel();
      }
      if (action == Case.ATACK) {
        setState(() {
          dartY -= 0.18;

          index++;
          if (index >= 3) {
            index = 1;
          }

          rukaIndex = 2;
          rukaY += 0.09;

          if (decoration == 0 || decoration == 1) {
            if (dartY < -0.7) {
              dartY = 2;
              dartX = 0;
              index = 1;
              rukaIndex = 1;
              rukaY = 1;
              action = null;
              gameOver += 1;
              if ((boardX >= -0.11 && boardX <= 0.11)) {
                speedGame++;
                gameOver = 0;
                result += 10;
                birdIndex = 4;
                action = Case.BIRD_SLEEPED;
                atackBird = false;
              }
              index = 3;
            }
          } else if (decoration == 2 || decoration == 3) {
            if (dartY < -0.3) {
              dartY = 2;
              dartX = 0;
              index = 1;
              rukaIndex = 1;
              rukaY = 1;
              action = null;
              gameOver += 1;
              if ((boardX >= -0.11 && boardX <= 0.11)) {
                speedGame++;
                gameOver = 0;
                result += 10;
                birdIndex = 4;
                action = Case.BIRD_SLEEPED;
                atackBird = false;
              }
              index = 3;
            }
          }
        });
      } else if (action == Case.BIRD_SLEEPED) {
        setState(() {
          birdIndex = 4;
          up = false;
          action = Case.BIRD_DOWN;
        });
      } else if (action == Case.BIRD_DOWN) {
        setState(() {
          boardY += 0.05;
          birdIndex++;
          if (birdIndex == 6) {
            birdIndex = 4;
          }
          if (boardY > 1.1) {
            decoration = Random().nextInt(4);

            atackBird = true;
            up = true;
            tray = true;
            action = null;
            setState(() {
              if (decoration == 0) {
                boardX = -1.4;
                boardY = -1;
                birdIndex = 1;
              } else if (decoration == 1) {
                boardX = 1.4;
                boardY = -1;
                birdIndex = 10;
              } else if (decoration == 2) {
                boardX = -1.4;
                boardY = -0.5;
                birdIndex = 1;
              } else if (decoration == 3) {
                boardX = 1.4;
                boardY = -0.5;
                birdIndex = 10;
              }
            });
          }
        });
      }

      if (up) {
        if (decoration == 0 || decoration == 2) {
          if (tray) {
            setState(() {
              birdIndex++;
              if (birdIndex >= 3) {
                birdIndex = 1;
              }
              boardX += 0.05;
              if (boardX >= 1.4) {
                tray = false;
              }
            });
          } else {
            setState(() {
              boardX = -1.4;
              tray = true;
            });
          }
        } else {
          if (tray) {
            setState(() {
              birdIndex++;
              if (birdIndex > 11) {
                birdIndex = 10;
              }
              boardX -= 0.05;
              if (boardX <= -1.4) {
                tray = false;
              }
            });
          } else {
            setState(() {
              boardX = 1.4;
              tray = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    stopY = size.height / 657;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/birds/gameF.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment(boardX, boardY),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 90,
                    height: 90,
                    child: Image(
                      image: AssetImage("lib/birds/bird$birdIndex.png"),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment(-1, -0.3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      result.toString(),
                      style: TextStyle(fontSize: 40, color: Colors.yellow[900]),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      child: Image(
                        image: AssetImage("lib/birds/gold.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blueAccent.withOpacity(gameOpacity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        ((gameOver % 3 == 0) && (gameOver != 0))
                            ? "GAME OVER"
                            : "",
                        style:
                            TextStyle(fontSize: 100, color: Colors.yellow[900]),
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () {
                            gameOver = 0;
                            gameOpacity = 0;
                            speedGame = 0;
                            stopGame();
                            startGame();
                          },
                          child: Container(
                            width: 150,
                            height: 80,
                            color: Colors.green.withOpacity(gameOpacity),
                            child: Center(
                                child: Text(
                                    (gameOver % 3 == 0) && (gameOver != 0)
                                        ? "RESTART"
                                        : "")),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment(0.04, rukaY),
                child: Container(
                  child: Image(
                    image: AssetImage("lib/image/ruka$rukaIndex.png"),
                  ),
                  width: (size.width / 10),
                  height: (size.width / 10),
                ),
              ),
              Container(
                alignment: Alignment(dartX, dartY),
                child: Container(
                  child: Image(
                    image: AssetImage("lib/image/dart$index.png"),
                  ),
                  width: (size.width / 10) * 0.5,
                  height: (size.height / 10) * 0.5,
                ),
              ),
              Container(
                height: 40,
                width: 100,
                alignment: Alignment(1.5, -0.95),
                child: Image(image: AssetImage("lib/birds/flutterLogo.png")),
              ),
              GestureDetector(
                onTap: () {
                  atack();
                  if ((speedGame % 3 == 0) && speedGame != 0) {
                    startGame();
                  }
                },
                child: Container(
                  alignment: Alignment(0.8, 0.9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.withOpacity(0.8),
                      width: 60,
                      height: 40,
                      child: Center(
                        child: Text(
                          "SHOOT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: startGame,
                child: Container(
                  alignment: Alignment(-0.8, 0.9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.withOpacity(0.8),
                      width: 60,
                      height: 40,
                      child: Center(
                        child: Text(
                          "PLAY",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: stopGame,
                child: Container(
                  alignment: Alignment(-0.55, 0.9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.blueGrey.withOpacity(0.8),
                      width: 60,
                      height: 40,
                      child: Center(
                        child: Text(
                          "STOP",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
