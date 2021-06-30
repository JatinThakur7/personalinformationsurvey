import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Information {
  String? _title;
  List<Fields>? _fields;
  WelcomeScreen? _welcomeScreen;
  ThankyouScreens? _thankyouScreens;

  Information(
      {String? title,
      List<Fields>? fields,
      WelcomeScreen? welcomeScreen,
      ThankyouScreens? thankyouScreens}) {
    this._title = title;
    this._fields = fields;
    this._welcomeScreen = welcomeScreen;
    this._thankyouScreens = thankyouScreens;
  }

  String? get title => _title;

  set title(String? title) => _title = title;

  WelcomeScreen? get welcomeScreen => _welcomeScreen;

  set welcomeScreen(WelcomeScreen? welcomeScreen) =>
      _welcomeScreen = welcomeScreen;

  ThankyouScreens? get thankyouScreens => _thankyouScreens;

  set thankyouScreens(ThankyouScreens? thankyouScreens) =>
      _thankyouScreens = thankyouScreens;

  List<Fields>? get fields => _fields;

  set fields(List<Fields>? fields) => _fields = fields;

  Information.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _welcomeScreen = json['welcome_screen'] != null
        ? WelcomeScreen.fromJson(json['welcome_screen'])
        : null;
    _thankyouScreens = json['thankyou_screens'] != null
        ? ThankyouScreens.fromJson(json['thankyou_screens'])
        : null;

    _fields = [];
    if (json['fields'] != null) {
      json['fields'].forEach((v) {
        _fields?.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this._title;
    if (this._welcomeScreen != null) {
      data['welcome_screen'] = this._welcomeScreen?.toJson();
    }
    if (this._thankyouScreens != null) {
      data['thankyou_screens'] = this._thankyouScreens?.toJson();
    }
    if (this._fields != null) {
      data['fields'] = this._fields?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static formString() {
    var json = jsonDecode(
        '{"title":"Personal Information Survey","welcome_screen":{"title":"Welcome to personal information  survey. Let\'s Begin!!","description":"We are collecting information of users visiting our center"},"thankyou_screens":{"title":"Thank you for your feedback, we really appreciate your efforts for filling this response."},"fields":[{"id":"a7PPrsreuktH","title":"Enter your name","validations":{"required":true},"type":"short_text"},{"id":"a7PPrsreuH","title":"Enter your name","validations":{"required":true},"type":"short_text"},{"id":"Z2sakg81mydT","title":"Enter your gender","properties":{"alphabetical_order":false,"choices":[{"label":"Male"},{"label":"Female"},{"label":"Rather not say"}]},"validations":{"required":true},"type":"dropdown"},{"id":"peP1NwbWV5oC","title":"Enter your age","validations":{"required":true},"type":"number"},{"id":"dTYFCBZNq3Ye","title":"Enter your email address","validations":{"required":true},"type":"email"},{"id":"dTYFCBZNqe","title":"Enter your second email address","validations":{"required":true},"type":"email"},{"id":"tNU4RLSOes46","title":"Enter phone number (Optional)","validations":{"required":false},"type":"phone_number"},{"id":"UVuD3M9gjcg5","title":"How was your experience at our gaming center","properties":{"steps":7},"validations":{"required":true},"type":"rating"},{"id":"YqoIovP8Xj3H","title":"Enter date of visit","properties":{"structure":"MMDDYYYY"},"validations":{"required":true},"type":"date"},{"id":"fg0YM1yIolWp","title":"Would you consider exploring our center again","validations":{"required":true},"type":"yes_no"},{"id":"fg0YMjlkcj","title":"Would you consider exploring our center again","validations":{"required":true},"type":"yes_no"}]}');
    return kIsWeb ? Information.fromJson(json) : Information();
  }
}

class WelcomeScreen {
  String? _title;
  String? _description;

  WelcomeScreen({String? title, String? description}) {
    this._title = title;
    this._description = description;
  }

  String? get title => _title;

  set title(String? title) => _title = title;

  String? get description => _description;

  set description(String? description) => _description = description;

  WelcomeScreen.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this._title;
    data['description'] = this._description;
    return data;
  }
}

class ThankyouScreens {
  String? _title;

  ThankyouScreens({String? title}) {
    this._title = title;
  }

  String? get title => _title;

  set title(String? title) => _title = title;

  ThankyouScreens.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this._title;
    return data;
  }
}

class Fields {
  String? _id;
  String? _type;
  String? _title;
  Properties? _properties;
  Validations? _validations;

  Fields(
      {String? id,
      String? title,
      String? type,
      Properties? properties,
      Validations? validations}) {
    this._id = id;
    this._type = type;
    this._title = title;
    this._properties = properties;
    this._validations = validations;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  String? get title => _title;

  set title(String? title) => _title = title;

  Validations? get validations => _validations;

  set validations(Validations? validations) => _validations = validations;

  String? get type => _type;

  set type(String? type) => _type = type;

  Properties? get properties => _properties;

  set properties(Properties? properties) => _properties = properties;

  Fields.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _validations = json['validations'] != null
        ? Validations.fromJson(json['validations'])
        : null;
    _type = json['type'];
    _properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    if (this._validations != null) {
      data['validations'] = this._validations?.toJson();
    }
    data['type'] = this._type;
    if (this._properties != null) {
      data['properties'] = this._properties?.toJson();
    }
    return data;
  }
}

class Choices {
  String? _label;

  Choices({String? label}) {
    this._label = label;
  }

  String? get label => _label;

  set label(String? label) => _label = label;

  Choices.fromJson(Map<String, dynamic> json) {
    _label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = this._label;
    return data;
  }
}

class Properties {
  int? _steps;
  String? _structure;
  List<Choices>? _choices;
  bool? _alphabeticalOrder;

  Properties(
      {int? steps,
      String? structure,
      List<Choices>? choices,
      bool? alphabeticalOrder}) {
    this._steps = steps;
    this._choices = choices;
    this._structure = structure;
    this._alphabeticalOrder = alphabeticalOrder;
  }

  bool? get alphabeticalOrder => _alphabeticalOrder;

  set alphabeticalOrder(bool? alphabeticalOrder) =>
      _alphabeticalOrder = alphabeticalOrder;

  List<Choices>? get choices => _choices;

  set choices(List<Choices>? choices) => _choices = choices;

  int? get steps => _steps;

  set steps(int? steps) => _steps = steps;

  String? get structure => _structure;

  set structure(String? structure) => _structure = structure;

  Properties.fromJson(Map<String, dynamic> json) {
    _alphabeticalOrder = json['alphabetical_order'];

    _choices = [];
    if (json['choices'] != null) {
      json['choices'].forEach((v) {
        _choices?.add(Choices.fromJson(v));
      });
    }
    _steps = json['steps'];
    _structure = json['structure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['alphabetical_order'] = this._alphabeticalOrder;
    if (this._choices != null) {
      data['choices'] = this._choices?.map((v) => v.toJson()).toList();
    }
    data['steps'] = this._steps;
    data['structure'] = this._structure;
    return data;
  }
}

class Validations {
  bool? _required;
  String? _errorText;
  var _controller = TextEditingController();

  Validations({bool? required}) {
    this._required = required;
  }

  bool? get required => _required;

  get controller => _controller;

  String? get errorText => _errorText;

  String get controllerText => _controller.text;

  set required(bool? required) => _required = required;

  set errorText(String? errorText) => _errorText = errorText;

  set controllerText(String controller) => _controller.text = controller;

  Validations.fromJson(Map<String, dynamic> json) {
    _required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['controllerText'] = this.controllerText;
    data['required'] = this._required;
    return data;
  }
}
