import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_model.dart';

class ApiService {
  /* 
    The DataModel used here would be a model we're using in the presentation layer of the application.
    I've seen both approaches where a model we get from the backend and one we use is separate and the same.
    I think the approach with separating them is for the most part better as both of the models technically
    are made for different purposes. Additionally we may wrap some of the values returned from the backend into other objects
    that make our work easier, that way we can avoid using ex. JsonConverters. 
    Separating them out also makes writing tests easier.
   */
  Future<DataModel> fetchData() async {
    final response = await http.get(Uri.parse('http://www.mock.com/example'));

    if (response.statusCode == 200) {
      return DataModel.fromJson(json.decode(response.body));
    } else {
      /* 
        Exception that we throw here and will catch higher up provides us no specific information about what exactly failed.
        It would be a good idea to pass more information in the message or preferably create a custom exception for
        networking issues.
       */
      throw Exception('Failed to load data');
    }
  }
}
