/*
An older class of scoresheet that was very laggy. Kept as a reference
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Create stateful widget
class ScoreSheet extends StatefulWidget {
  @override
  _ScoreSheetState createState() => _ScoreSheetState();
}

//Create state for Scoresheet
class _ScoreSheetState extends State<ScoreSheet> {
  List<List<TextEditingController>> scoreTable = new List();
  int roundCount = 1;
  final RegExp regex = new RegExp(r'^[0-9\-][0-9]*');

  //constructs table
  // if there is no player asks to add a player
  // otherwise constructs a table of players and rounds
  Widget tableConstructor() {
    if (scoreTable.length == 0) {
      return Center(
        child: Text("Please Add at least one player"),
      );
    } else {
      List<TableRow> children = new List();
      List<Widget> rowContent = new List();

      //Add player names
      for (int i = 0; i < scoreTable.length; i++) {
        rowContent.add(TextField(
            controller: scoreTable[i][0],
            expands: false,
            textAlign: TextAlign.center,
            enableSuggestions: false,
            decoration: InputDecoration(contentPadding: EdgeInsets.all(8.0))));
      }
      children.add(TableRow(children: rowContent));

      //add rest of player scores
      List<int> partialSum = new List();
      for (int row = 0; row < roundCount; row++) {
        //initial score for this round
        rowContent = new List();
        for (int col = 0; col < scoreTable.length; col++) {
          TextEditingController toUse;
          if (row == 0) {
            partialSum.add(0);
            toUse = TextEditingController(text: "-");
          } else {
            partialSum[col] += int.parse(scoreTable[col][row].text);
            toUse = TextEditingController(text: partialSum[col].toString());
          }
          rowContent.add(TextField(
            controller: toUse,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(8.0, -8.0, 8.0, -8.0),
              border: InputBorder.none,
            ),
            enabled: false,
          ));
        }
        children.add(TableRow(children: rowContent));

        // score to add for this round
        rowContent = new List();
        for (int col = 0; col < scoreTable.length; col++) {
          rowContent.add(
            TextField(
                controller: scoreTable[col][row + 1],
                keyboardType: TextInputType.numberWithOptions(signed: true),
                textAlign: TextAlign.end,
                expands: false,
                enableSuggestions: false,
                onSubmitted: (String value) {
                  setState(() {}); /* empty func. Just want to update */
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(8.0, -8.0, 8.0, -8.0),
                  prefixText: "+",
                ),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(regex)
                ]),
          );
        }
        children.add(TableRow(children: rowContent));
      }

      //Total
      rowContent = new List();
      for (int col = 0; col < scoreTable.length; col++) {
        int score = 0;
        for (int row = 1; row < scoreTable[col].length; row++) {
          if (scoreTable[col][row].text != '-') {
            score += int.parse(scoreTable[col][row].text);
          }
        }
        rowContent.add(TextField(
          controller: TextEditingController(text: score.toString()),
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(8.0, -8.0, 8.0, -8.0),
            border: InputBorder.none,
          ),
          enabled: false,
        ));
      }

      children.add(TableRow(children: rowContent));

      return ListView(children: <Widget>[
        Table(
            border: TableBorder(
                verticalInside: BorderSide(width: 1.0, color: Colors.grey)),
            children: children,
            defaultColumnWidth:
                MaxColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(100.0)))
      ]);
    }
  }

  void _addPlayer() {
    setState(() {
      scoreTable.add(new List());
      scoreTable[scoreTable.length - 1].add(TextEditingController(
          text: "Player " + (scoreTable.length).toString()));
      for (int i = 0; i < roundCount; i++) {
        scoreTable[scoreTable.length - 1].add(TextEditingController(
          text: "0",
        ));
      }
    });
  }

  void _addRound() {
    setState(() {
      for (int col = 0; col < scoreTable.length - 1; col++) {
        scoreTable[col].add(TextEditingController(
          text: "0",
        ));
      }
      roundCount++;
    });
  }

  void _removeRound() {
    setState(() {
      for (int col = 0; col < scoreTable.length - 1; col++) {
        scoreTable[col][roundCount + 1].dispose();
        scoreTable[col].removeLast();
      }
      roundCount--;
    });
  }

  void _removePlayer() {
    setState(() {
      //for (int row = 0; row < 1; row++) {
        //scoreTable[scoreTable.length-1][row].dispose();
        scoreTable.removeAt(0);
      //}
    });
  }

  void _newGame() {
    setState(() {
      while (scoreTable.length > 0) {
        for (int row = roundCount + 1; row >= 0; row++) {
          scoreTable[scoreTable.length - 1][row].dispose();
          scoreTable[scoreTable.length - 1].removeLast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Center(
            child: tableConstructor(),
          ),
        ),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            child: Text('New Game'),
            onPressed: _newGame,
          ),
          RaisedButton(
            child: Text('Remove Player'),
            onPressed: _removePlayer,
          ),
          RaisedButton(
            child: Text('Remove Round'),
            onPressed: _removeRound,
          ),
          RaisedButton(
            child: Text('Add Player'),
            onPressed: _addPlayer,
          ),
          RaisedButton(
            child: Text('Add Round'),
            onPressed: _addRound,
          )
        ]
        /*floatingActionButton: FloatingActionButton(
      onPressed: _addPlayer,
      tooltip: 'Add Player',
      child: Icon(Icons.add),
    ),*/ // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
