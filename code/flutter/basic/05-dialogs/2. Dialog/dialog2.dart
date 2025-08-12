import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:DialogPage())); 

class DialogPage extends StatefulWidget {
  @override
  State<DialogPage> createState() => _DialogPageState();
}
  
class _DialogPageState extends State<DialogPage> {
  String info = 'No information yet';
  
  _updateString(result) {
    setState(() {info = result;});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog'),
      ),
      body: Text(this.info), // This info will be updated from the dialog
      floatingActionButton: FloatingActionButton(
        // click the button to display dialog
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return DialogUI(input:info, function:_updateString);
            }
          );
        },
        child: const Text('Dialog'),
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  final String input;
  final function;
  DialogUI({required this.input, required this.function});

  String returnValue = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Text(this.input),
            TextField(
              onChanged: (val) {returnValue = val;},
            ),
            TextButton( 
              child: Text('Done'), 
              onPressed:(){
                function(returnValue);
                Navigator.pop(context);
              } 
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed:(){ Navigator.pop(context); })
          ],
        ),
      ),
    );
  }
} 