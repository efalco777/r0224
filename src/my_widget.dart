import 'package:flutter/material.dart';
import 'data_model.dart';
import 'api_service.dart';

class MyWidget extends StatefulWidget {
  /* 
    No usage of the key parameter from parent constructor. It is generally a good practice to use it as it can be used
    to differantiate specific copies of the widget or to use with integration tests etc.
   */
  MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Future<DataModel> _dataModel;

  @override
  void initState() {
    super.initState();
_dataModel = ApiService().fetchData();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataModel>(
      future: _dataModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          /* 
            Animation starts right after initState is invoked in paralel with fetching the data.
            This will make the animation likely end before [FadeTransition] is shown.
            ---- 
            If we insit on using FutureBuilder it would be better to just run "_controller.forward()" after 
            "ApiService().fetchData()" finishes. ex.
            "
               _dataModel = ApiService().fetchData().then((value) {
                _controller.forward();
                return value;
              });
            "
          */
          // Success
          return FadeTransition(
            opacity: _animation,
            child: Text('Hello, ${snapshot.data!.name}'),
          );
        } else {
          /* 
              It is generally a better idea to keep ordering widgets top to bottom in order we expect them to show.
              In pseudo code: 
              builder: (context, snapshot) {
                1. Loading
                if(snapshot.connectionState != ConnectionState.done) return CircularProgressIndicator()
                
                1. "Golden scenario"
                if(!snapshot.hasError) return Success(snapshot.data!);

                3. Fallbacks
                return Error();
              }
           */
          return CircularProgressIndicator();
        }
      },
    );
  }
}
