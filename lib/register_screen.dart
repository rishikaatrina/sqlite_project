import 'package:flutter/material.dart';
import 'package:sqlite_project/sql/sql_helper.dart';

import 'color/color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Map<String, dynamic>> _list = [];
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  var style = const TextStyle(
    color: InColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  );

  var focusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: InColors.blackColor, width: 2.0),
    borderRadius: BorderRadius.circular(10.0),
  );

  void _refreshList() async {
    var data = await SQLHelper.getDataItems();
    setState(() {
      _list = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
    print('..number of items $_list');
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _addDataItem() async {
    await SQLHelper.createData(
        _firstNameController.text,
        _lastNameController.text,
        _mobileController.text,
        _emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully Added Record')));
    _refreshList();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateDataItem(
        id,
        _firstNameController.text,
        _lastNameController.text,
        _mobileController.text,
        _emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully Updated A Record')));
    _refreshList();
  }

  void _deleteDataRecord(int id) async {
    await SQLHelper.deleteDataItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully Deleted A Record')));
    _refreshList();
  }

  void _form(int? userId) async {
    if (userId != null) {
      var existingList =
          _list.firstWhere((element) => element['userId'] == userId);
      _firstNameController.text = existingList['firstName'];
      _lastNameController.text = existingList['lastName'];
      _mobileController.text = existingList['mobile'];
      _emailController.text = existingList['email'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (_) => Container(
        color: InColors.blueColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(userId == null ? 'Register Details' : 'Update Details',
                      style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: style,
                        filled: true,
                        fillColor: InColors.whiteColor,
                        hintText: 'First Name',
                        hintStyle: style,
                        border: border,
                        focusedBorder: focusBorder),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: style,
                        filled: true,
                        fillColor: InColors.whiteColor,
                        hintText: 'Last Name',
                        hintStyle: style,
                        border: border,
                        focusedBorder: focusBorder),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: style,
                        filled: true,
                        fillColor: InColors.whiteColor,
                        hintText: 'Mobile Number',
                        hintStyle: style,
                        border: border,
                        focusedBorder: focusBorder),
                    validator: (value) {
                      if (value?.length != 10) {
                        return 'Please enter 10 digits Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: style,
                        filled: true,
                        fillColor: InColors.whiteColor,
                        hintText: 'Email Address',
                        hintStyle: style,
                        border: border,
                        focusedBorder: focusBorder),
                    validator: (value) {
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (userId == null) {
                                await _addDataItem();
                              }
                              if (userId != null) {
                                await _updateData(userId);
                              }
                              _firstNameController.text = '';
                              _lastNameController.text = '';
                              _mobileController.text = '';
                              _emailController.text = '';
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: InColors.whiteColor,
                            padding: const EdgeInsets.all(10),
                          ),
                          child: Text(
                            userId == null ? 'Submit' : 'Update',
                            style: const TextStyle(color: InColors.blackColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: InColors.whiteColor,
        leading: const Image(image: AssetImage('assets/images/sqlite.jpg')),
        title: const Text(
          'Sqlite',
          style: TextStyle(color: InColors.blackColor),
        ),
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          color: InColors.blueColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Table(
                children: [
                  TableRow(children: [
                    RichText(
                      text: TextSpan(
                        text: 'First Name:\n',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: _list[index]['firstName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Last Name\n',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: _list[index]['lastName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(Icons.edit, color: InColors.blackColor),
                      onTap: () {
                        _form(_list[index]['userId']);
                      },
                    ),
                  ]),
                  const TableRow(children: [
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    SizedBox(height: 20)
                  ]),
                  TableRow(children: [
                    RichText(
                      text: TextSpan(
                          text: 'Mobile No:\n',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: _list[index]['mobile'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Email ID:\n',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: _list[index]['email'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    GestureDetector(
                      child:
                          const Icon(Icons.delete, color: InColors.blackColor),
                      onTap: () {
                        setState(() {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Record'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text('Do you want to Delete this Record?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      _deleteDataRecord(_list[index]['userId']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: InColors.blueColor,
        child: const Icon(Icons.add, color: InColors.blackColor),
        onPressed: () {
          _form(null);
        },
      ),
    );
  }
}
