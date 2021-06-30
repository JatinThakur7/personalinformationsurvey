import 'dart:convert';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'utils/information.dart';
import 'utils/api_client.dart';

void main() async {
  runApp(FutureProvider<Information>(
    initialData: Information.formString(),
    create: (context) => ApiClient.instance.get(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final information = context.watch<Information>();
    return MaterialApp(
      title: information.title ?? '',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: _builder,
      debugShowCheckedModeBanner: false,
      home: DoubleBack(child: WelcomePage()),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: LoadingProvider(
        loadingWidgetBuilder: (_, __) => Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
            child: CupertinoActivityIndicator(),
          ),
        ),
        themeData: LoadingThemeData(),
        child: child ?? Container(),
      ),
      constraints: BoxConstraints(
        maxHeight: size.height,
        maxWidth: size.width,
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final information = context.watch<Information>();
    final welcomeScreen = information.welcomeScreen;

    ApiClient.instance.get().then(print);
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: welcomeScreen == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        welcomeScreen.title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        welcomeScreen.description ?? '',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SurveyPage()),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text('Start'),
                    ),
                  ))
                ],
              ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SurveyState();
}

class _SurveyState extends State<SurveyPage> {
  InputDecoration _decoration({
    String? errorText,
    String? hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      errorText: errorText,
      hintText: hintText ?? '',
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.all(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = kIsWeb ? 400 : MediaQuery.of(context).size.width;
    final information = context.watch<Information>();
    final fields = information.fields ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Survey',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: kIsWeb,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: fields.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (_, index) => Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 12),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: width / 2.0,
                        maxWidth: width / 1.0,
                      ),
                      child: _getInputBox(fields, index)),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                bool _error = false;
                List<Map<String, dynamic>> _list = [];
                fields.forEach((element) {
                  bool required = element.validations?.required ?? false;
                  String? controllerText = element.validations?.controllerText;
                  setState(() {
                    element.validations?.errorText = null;
                    if (required && controllerText!.isEmpty) {
                      _error = true;
                      element.validations?.errorText = 'field is required';
                    }
                  });
                  _list.add({
                    'field_id': element.id,
                    'field_data': controllerText,
                  });
                  print(
                      'id  => ${element.id}, type  => ${element.type}, required  => $required, text  => $controllerText');
                });
                var params = jsonEncode(_list);
                print('$_error ==> $params');

                if (_error) {
                  var snackBar = SnackBar(
                    content: Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Text('Please fill the required fields'),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                // uploading data
                else {
                  if (kIsWeb) {
                    showLoadingDialog();
                    ApiClient.instance.post(params);
                    hideLoadingDialog();
                  }
                  // mobile
                  else {
                    showLoadingDialog();
                    print('uploading post $params');
                    await ApiClient.instance.post(params);

                    hideLoadingDialog();
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ThankyouScreens()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[900],
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getInputBox(List<Fields> fields, int index) {
    Fields field = fields[index];

    switch (field.type ?? '') {
      case 'short_text':
        return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.text,
          controller: field.validations?.controller,
          decoration: _decoration(
            hintText: field.title,
            errorText: field.validations?.errorText,
          ),
        );
      case 'number':
        return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.number,
          controller: field.validations?.controller,
          decoration: _decoration(
            hintText: field.title,
            errorText: field.validations?.errorText,
          ),
        );
      case 'email':
        return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          controller: field.validations?.controller,
          decoration: _decoration(
            hintText: field.title,
            errorText: field.validations?.errorText,
          ),
        );
      case 'phone_number':
        return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.phone,
          controller: field.validations?.controller,
          decoration: _decoration(
            hintText: field.title,
            errorText: field.validations?.errorText,
          ),
        );
      case 'date':
        DateTime selectedDate = DateTime.now();
        return TextFormField(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101));
            if (picked != null && picked != selectedDate) selectedDate = picked;
            var structure = field.properties?.structure;
            structure = structure?.replaceAll('DD', 'dd');
            structure = structure?.replaceAll('YYYY', 'yyyy');

            DateFormat formatter = DateFormat('dd-MM-yyyy');
            String formatted = formatter.format(selectedDate);

            print('Date formatted $formatted');
            try {
              formatter = DateFormat(structure ?? 'dd-MM-yyyy');
              formatted = formatter.format(selectedDate);
            } catch (e) {
              print(e);
            }

            print('Date structure $structure');
            print('Date formatted => $formatted');
            field.validations?.controllerText = formatted;
          },
          autofocus: false,
          keyboardType: TextInputType.datetime,
          decoration: _decoration(
            hintText: field.title,
            prefixIcon: Icon(Icons.calendar_today),
            errorText: field.validations?.errorText,
          ),
          controller: field.validations?.controller,
        );
      case 'rating':
        int steps = field.properties?.steps ?? 7;
        double initialRating = steps > 4 ? 3 : 1;
        if (field.validations?.controllerText.isEmpty ?? true) {
          field.validations?.controllerText = '$initialRating';
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              field.title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            RatingBar.builder(
              initialRating: initialRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: steps,
              itemPadding: EdgeInsets.zero,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rating) {
                field.validations?.controllerText = '$rating';
                print('rating => $rating');
              },
            ),
          ],
        );
      case 'dropdown':
        List<Choices> choices = field.properties?.choices ?? [];
        if (field.properties?.alphabeticalOrder ?? false) {
          choices.sort((a, b) => (a.label ?? '').compareTo(b.label ?? ''));
        }
        return DropdownButtonFormField<Choices>(
          isExpanded: true,
          decoration: _decoration(
            hintText: field.title,
            errorText: field.validations?.errorText,
          ),
          items: choices.map((Choices value) {
            return DropdownMenuItem<Choices>(
              value: value,
              child: Text(value.label ?? 'null'),
            );
          }).toList(),
          onChanged: (value) {
            field.validations?.controllerText = value?.label ?? '';
          },
        );
      case 'yes_no':
        var initialIndex = 0;
        var labels = ['Yes', 'No'];
        if (field.validations?.controllerText.isEmpty ?? true) {
          field.validations?.controllerText = labels[initialIndex];
        }
        var width = MediaQuery.of(context).size.width;
        if (kIsWeb) {
          print('width $width');
          width = width > 400 ? 320 : width - 80;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              field.title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ToggleSwitch(
              minWidth: width / 2.4,
              initialLabelIndex: initialIndex,
              borderWidth: 1,
              borderColor: [Colors.grey],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.black,
              totalSwitches: 2,
              labels: labels,
              activeBgColors: [
                [Colors.green],
                [Colors.green],
              ],
              onToggle: (index) {
                print('switched to: $index');
                field.validations?.controllerText = labels[index];
              },
            ),
          ],
        );
      default:
        return Container(
          padding: EdgeInsets.only(bottom: 12),
          child: TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: field.validations?.controller,
            decoration: _decoration(
              hintText: 'type...',
              errorText: field.validations?.errorText,
            ),
          ),
        );
    }
  }
}

class ThankyouScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final information = context.watch<Information>();
    final thankyouScreens = information.thankyouScreens;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Center(
              child: Text(
                thankyouScreens?.title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SurveyPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey[900],
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text('again'),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
