import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  final titleController = TextEditingController();
  String petName = "No Value Entered";

  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow;
  Timer? _win;
  bool won = false;
  String? gameOver;

  void _setText() {
    setState(() {
      petName = titleController.text;
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetColor(); // Update color based on happiness
      _checkWin();
      _checkLoss();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetColor(); // Update color based on happiness
      _checkWin();
      _checkLoss();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Function to change the pet's color based on happiness level
  void _updatePetColor() {
    setState(() {
      if (happinessLevel > 70) {
        petColor = Colors.green;
      } else if (happinessLevel >= 30) {
        petColor = Colors.yellow;
      } else {
        petColor = Colors.red;
      }
    });
  }

  void _checkWin() {
    if (happinessLevel > 80 && !won) {
      _win = Timer(Duration(minutes: 3), () {
        setState(() {
          won = true;
          gameOver = "You Win!";
        });
      });
    }
  }

  void _checkLoss() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        won = true;
        gameOver = "Game Over!";
        _win?.cancel();
      });
    }
  }

  String _petMood() {
    if (happinessLevel > 70) {
      return 'Happy';
    } else if (happinessLevel >= 30) {
      return 'Neutral';
    } else {
      return 'Unhappy';
    }
  }

  String _moodEmojoi() {
    if (happinessLevel > 70) {
      return '😊';
    } else if (happinessLevel >= 30) {
      return '😐';
    } else {
      return '😢';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (gameOver != null)
              Text(
                gameOver!,
                textAlign: TextAlign.center,
              ),

            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your petname'),
            ),
            ElevatedButton(
                onPressed: _setText,
                /*style: ButtonStyle(
                    backgroundColor:Colors.amber),*/
                child: const Text('Submit')),

            // Transparent pet image with a dynamic color filter
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                petColor, // The current color for the pet based on happiness
                BlendMode.modulate, // Blend mode to overlay the color
              ),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSArtNvfXmXPL3m2NUPQYsze8TP_rJpeYMTxA&s', // Replace with your transparent pet image URL
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Mood: ${_petMood()}'),
                SizedBox(width: 5.0),
                Text(
                  _moodEmojoi(),
                  style: TextStyle(fontSize: 30.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
