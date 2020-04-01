import 'package:flutter/material.dart';
// import 'http_exception.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import './MainScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider())
      ],
      child: Consumer<UserProvider>(builder: (ctx,data,_) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: data.isAuth ? MainScreen() : FutureBuilder(
          future: data.tryToAutoLogIn(), 
          builder: (ctx,authSnapshot) => authSnapshot.connectionState == ConnectionState.waiting ? MainScreen() : MyHomePage(title: 'Flutter Demo Home Page') ),  
      ),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  void _showErrorDialog(String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hello  Message'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            }, 
            child: Text("OK"))
        ],
      )
    );
    setState(() {
      _formKey.currentState.reset();
    });
  }
  void _submit() async
  {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      print("Form Validated");
      print(_authData);
      var res = await Provider.of<UserProvider>(context,listen: false).signin(_authData['email'], _authData['password']);
      _showErrorDialog(res);
      // setState(() {
      //   _isLoading = true;
      // });
      // try{
      //   await Provider.of<UserProvider>(context,listen: false).signin(_authData['email'], _authData['password']);
      // }on HttpException catch(error){
      //   var err  = 'Authentication failed';
      //   if(error.toString().contains('Authentication Failed')){
      //     err = "Authentication Failed. No User detected with given details";
      //   }
      //   _showErrorDialog(err);
      // }catch(error){
      //   var message = 'Could not Authenticate User' + error;
      //   _showErrorDialog(message);
      // }
      // setState(() {
      //   _isLoading = false;
      // });
    }

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(120.0, 110.0, 0.0, 0.0),
                    child: Text('CSR',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(120.0, 175.0, 0.0, 0.0),
                    child: Text('App',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(260.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  )
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value.isNotEmpty ? value.contains('@') ? null : 'Invalid Email' : 'Enter Email',
                        onSaved: (String result){
                          _authData['email'] = result;
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                        validator: (value) => value.isNotEmpty ? value.length < 5 ? 'Short Password' : null : null,
                        onSaved: (String value) {
                          _authData['password'] = value;
                        },
                      ),
                      SizedBox(height: 5.0),
                      Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        _isLoading == true ? CircularProgressIndicator() : 
                          Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {
                                _submit();
                              },
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      
                      
                    ],
                  )),
            ),
            SizedBox(height: 15.0),
            
          ],
        ));
  }
}
