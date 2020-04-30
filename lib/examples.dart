/*
snippets that show an implementation of SliverList and SliverGrid
 specific to my application
*/
SliverList(
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return Container(padding: EdgeInsets.all(20), child:Text(scoreTable[index]));
    },
    childCount: scoreTable.length,
  )
)

SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //maxCrossAxisExtent: 1,
    crossAxisCount: 1,
    mainAxisSpacing: 20,
    crossAxisSpacing: 20
    
  ),
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        //child: Text(scoreTable[index]),
        color: Colors.green[100],
      );
    }
  )
);
