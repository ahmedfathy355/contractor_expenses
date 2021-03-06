// Buttons

// ElevatedButton(
// child: Text('insert', style: TextStyle(fontSize: 20),),
// onPressed: _insert,
// ),
// ElevatedButton(
// child: Text('query', style: TextStyle(fontSize: 20),),
// onPressed: _query,
// ),
// ElevatedButton(
// child: Text('update', style: TextStyle(fontSize: 20),),
// onPressed: _update,
// ),
// ElevatedButton(
// child: Text('delete', style: TextStyle(fontSize: 20),),
// onPressed: _delete,
// ),



// Button onPressed methods

// void _insert() async {
//   // row to insert
//   Map<String, dynamic> row = {
//     DatabaseHelper.columnName : 'Bob',
//     DatabaseHelper.columnAge  : 23
//   };
//   final id = await dbHelper.insert(row);
//   print('inserted row id: $id');
// }
//
// void _query() async {
//   final allRows = await dbHelper.queryAllRows();
//   print('query all rows:');
//   allRows.forEach(print);
// }
//
// void _update() async {
//   // row to update
//   Map<String, dynamic> row = {
//     DatabaseHelper.columnId   : 1,
//     DatabaseHelper.columnName : 'Mary',
//     DatabaseHelper.columnAge  : 32
//   };
//   final rowsAffected = await dbHelper.update(row);
//   print('updated $rowsAffected row(s)');
// }
//
// void _delete() async {
//   // Assuming that the number of rows is the id for the last row.
//   final id = await dbHelper.queryRowCount();
//   final rowsDeleted = await dbHelper.delete(id);
//   print('deleted $rowsDeleted row(s): row $id');
// }