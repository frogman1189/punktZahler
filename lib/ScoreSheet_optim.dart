/* 
 Optimsed form of ScoreSheet that utilizes ChimeraText
 and lazy loading to improve performance. It also supports 
 multiaxis scrolling
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ChimeraText.dart';

class ScoreSheet_optim extends StatefulWidget {
  @override _ScoreSheet_optimState createState() => _ScoreSheet_optimState();
}

class _ScoreSheet_optimState extends State<ScoreSheet_optim> {
  List<List<String>> scoreTable;
  List<List<int>> totalTable;

  // Initialise scoresheet with dummy data for testing during development
  _ScoreSheet_optimState() {
    scoreTable = new List();
    for(int x = 0; x < 5; x++) {
      scoreTable.add(new List());
      for(int y = 0; y < 10; y++) {
        scoreTable[x].add(1.toString());
      }
    }
    totalTable = new List();
    for(int x = 0; x < scoreTable.length; x++) {
      totalTable.add(new List());
      totalTable[x].add(0);
      for(int y = 0; y < scoreTable[0].length; y++) {
        totalTable[x].add(int.parse(scoreTable[x][y]) + totalTable[x][y]);
      }
    }
    //print("-------------total table-------------");
    //print(totalTable);
  }

  // calculate new total scores for each round
  void _updateTotals() {
    setState(() {
        for(int x = 0; x < scoreTable.length; x++) {
          totalTable[x][0] = 0;
          for(int y = 0; y < scoreTable[0].length; y++) {
            print("score: " + scoreTable[x][y]);
            print("old total: " + totalTable[x][y].toString());
            totalTable[x][y+1] = int.parse(scoreTable[x][y]) + totalTable[x][y];
            print("new total: " + totalTable[x][y+1].toString());
          }
        }
    });
    print('updated');
    print(totalTable);
  }

  //build actual widget
  @override
  Widget build(BuildContext context) {
    // generate absolute name row
    List<Widget> nameRow = new List();
    for(int i = 0; i < scoreTable.length; i++) {
      nameRow.add(ChimeraText(value: "Player " + i.toString()));
    }

    return Scrollbar(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // scrollbar must be in container with fixed width otherwise errors
      child: Container(
        width:  scoreTable.length * 208.0,
        child: Scrollbar(child:CustomScrollView(
            slivers: <Widget> [
              //fixed name row
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 36,
                maxHeight: 36,
                child: Row(children: nameRow)
              )
            ),
            //score table
            SliverFixedExtentList(
              itemExtent: 30,               //height of items
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  List<Widget> rowItems = new List();
                  for(int x = 0; x < scoreTable.length; x++) {
                    // total of round
                    if(index % 2 == 0){
                      rowItems.add(
                        Container(
                          width: 200,
                          child: Text(totalTable[x][index~/2].toString()),
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: Colors.green[100]
                              ),
                              left: BorderSide(
                                width: 2,
                                color: Theme.of(context).dividerColor
                              ),
                              right: BorderSide(
                                width: 2,
                                color: Theme.of(context).dividerColor
                              ),
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.green[100]
                              ),
                            ),
                            color: Colors.green[100],
                          )
                      ));
                    }
                    else {
                      // score added of round. Editable
                      rowItems.add(
                        ChimeraText(
                          value: scoreTable[x][(index-1)~/2].toString(),
                          callback: (String value) {
                            print(scoreTable);
                            print(totalTable);
                            scoreTable[x][(index-1)~/2] = value;
                            print(scoreTable);
                            _updateTotals();
                            print(value);
                            print(scoreTable[x][(index-1)~/2]);
                          }
                        ),
                      );
                    }
                  }
                  return Row(
                    children: rowItems,
                  );
                },
                childCount: scoreTable[0].length + totalTable[0].length,
              )
)])))));
  }
}

/*
 implements abstract class SliverPersistentHeaderDelegate
 for the fixed name row. Code taken from stack overflow
*/
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({
      @required this.minHeight,
      @required this.maxHeight,
      @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
