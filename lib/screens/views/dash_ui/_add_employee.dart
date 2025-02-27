import 'dart:async';
import 'dart:math';
import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmbrew/data/_check_mail.dart';
import 'package:pharmbrew/domain/_generate_password.dart';
import 'package:pharmbrew/domain/_mailer.dart';
import 'package:pharmbrew/domain/_register.dart';
import 'package:pharmbrew/widgets/_add_employee_text_boxes.dart';

import '../../../domain/usecases/_get_department_and_id.dart';
import '../../../utils/_show_dialog.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  // final TextEditingController _dobController = TextEditingController();
  // final TextEditingController _designationController = TextEditingController();
  final TextEditingController _baseSalaryController = TextEditingController();

  // final TextEditingController _paymentFrequencyController = TextEditingController();
  // final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool isValid = true;

  // final TextEditingController _roleController = TextEditingController();

  final List<String> departmentNames = getAllDesignations();
  final List<String> roles = ["Employee", "HR"];

  bool verficationSent = false;

  XFile? _image;

  String dropDownValue = "";
  String dropDownValueRole = "";

  EmailOTP myauth = EmailOTP();

  DateTime birthDate = DateTime.now();
  bool selected = false;

  Future<DateTime?> _selectDate(BuildContext context, DateTime dateTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1920, 1),
      lastDate: DateTime.now(),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: CupertinoColors.activeGreen,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please wait...',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(30),
                      child: const Row(
                        children: [
                          Text(
                            'Add New Employee',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          AddEmployeeTextBoxes(
                            controller: _nameController,
                            title: 'Name',
                            hintText: 'eg. John Doe',
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'Email',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        child: TextField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. doe@gmail.com',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        height: 55,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            onPressed: () async {
                                              String email = _emailController
                                                  .text
                                                  .toString()
                                                  .trim();

                                              bool emailExists =
                                                  await CheckMail.check(email);

                                              print(email);
                                              print(emailExists);

                                              final bool isValid =
                                                  EmailValidator.validate(
                                                      email);

                                              // Check if email field is empty
                                              if (emailExists) {
                                                showCustomErrorDialog(
                                                    "Email already exists! Please enter a different email address",
                                                    context);
                                                // _emailController.clear();
                                              } else {
                                                if (email.isEmpty || !isValid) {
                                                  // Show error dialog if email field is empty
                                                  showCustomErrorDialog(
                                                      "Please enter a valid email address",
                                                      context);
                                                } else {
                                                  // Generate OTP
                                                  generatedOTP = generateOTP();
                                                  sendEmail(
                                                      email,
                                                      "Pharmabrew Verification Code",
                                                      "Dear user,\nHere is your verification code: $generatedOTP");

                                                  // Update state
                                                  setState(() {
                                                    verficationSent = true;
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                verficationSent
                                                    ? const Icon(
                                                        Icons.loop,
                                                        color: Colors.white,
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  verficationSent
                                                      ? 'Resend'
                                                      : 'Send verification code',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AddEmployeeTextBoxes(
                            controller: _verificationController,
                            title:
                                "Verification Code [Don't Forget To Check Spam Folder]",
                            hintText: 'eg. 1111',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          text: "Role",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: DropdownMenu<String>(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                      initialSelection: roles.first,
                                      onSelected: (String? value) {
                                        setState(() {
                                          dropDownValueRole = value!;
                                        });
                                      },
                                      dropdownMenuEntries: roles
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Column(
                            children: [
                              Row(children: [
                                RichText(
                                    text: const TextSpan(
                                  text: "Date of Birth",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ))
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                            await _selectDate(
                                                context, birthDate);
                                        if (pickedDate != null) {
                                          setState(() {
                                            birthDate = pickedDate;
                                            selected = true;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: !selected
                                          ? Text(
                                              'YYYY-MM-DD',
                                              style: TextStyle(
                                                  color: Colors.grey.shade700),
                                            )
                                          : Text("${birthDate.toLocal()}"
                                              .split(' ')[0]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // AddEmployeeTextBoxes(
                          //   controller: _designationController,
                          //   title: 'Designation',
                          //   hintText: 'Enter Designation',
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          AddEmployeeTextBoxes(
                            controller: _baseSalaryController,
                            title: 'Base Salary',
                            hintText: 'eg. 45000.00',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // AddEmployeeTextBoxes(
                          //   controller: _paymentFrequencyController,
                          //   title: 'Payment Frequency',
                          //   hintText: 'Enter Payment Frequency',
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // AddEmployeeTextBoxes(
                          //   controller: _departmentController,
                          //   title: 'Department',
                          //   hintText: 'Enter Department',
                          // ),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          text: "Designation",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: DropdownMenu<String>(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                      initialSelection: departmentNames.first,
                                      onSelected: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropDownValue = value!;
                                        });
                                      },
                                      dropdownMenuEntries: departmentNames
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AddEmployeeTextBoxes(
                            controller: _ratingController,
                            title: 'Rating',
                            hintText: 'eg. 5',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AddEmployeeTextBoxes(
                            controller: _phoneNumberController,
                            title: 'Phone Number',
                            hintText: 'eg. 017xxxxxxxx, 019xxxxxxxx',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AddEmployeeTextBoxes(
                            controller: _skillsController,
                            title: 'Skills',
                            hintText: 'eg. C++, Java, Python',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Text('Location: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Apartment: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _apartmentController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. #8A1',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Building: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _buildingController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. Cyrus Tower',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Street: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _streetController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. Road 1',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('City: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _cityController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. Dhaka',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Postal Code: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _postalCodeController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. 1207',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Country: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: _countryController,
                                          decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              hintText: 'eg. Bangladesh',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ImagePicker imagePicker = ImagePicker();
                                    _image = await imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      _image = _image;
                                      isSelected = true;
                                      imageName = _image!.name;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey.shade400,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: isSelected
                                      ? Text(
                                          imageName,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        )
                                      : const Text('Select Picture',
                                          style:
                                              TextStyle(color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                // width: 140,
                                height: 60,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        // bool isEmailValid = !EmailValidator.validate(
                                        //     _emailController.text.toString().trim());
                                        //
                                        // print("Validity:$isEmailValid");

                                        setState(() {
                                          isLoading = true;
                                        });

                                        String name = _nameController.text
                                            .toString()
                                            .trim();
                                        String email = _emailController.text
                                            .toString()
                                            .trim();
                                        String verificationCode =
                                            _verificationController.text
                                                .toString()
                                                .trim();
                                        String dob = birthDate.toString();
                                        // String designation =
                                        //     _designationController.text.toString().trim();
                                        String baseSalary =
                                            _baseSalaryController.text
                                                .toString()
                                                .trim();
                                        // String paymentFrequency =
                                        //     _paymentFrequencyController.text
                                        //         .toString()
                                        //         .trim();
                                        // String department =
                                        //     _departmentController.text.toString().trim();
                                        String rating = _ratingController.text
                                            .toString()
                                            .trim();
                                        String phoneNumber =
                                            _phoneNumberController.text
                                                .toString()
                                                .trim();
                                        String skills = _skillsController.text
                                            .toString()
                                            .trim();
                                        String apartment = _apartmentController
                                            .text
                                            .toString()
                                            .trim();
                                        String building = _buildingController
                                            .text
                                            .toString()
                                            .trim();
                                        String street = _streetController.text
                                            .toString()
                                            .trim();
                                        String city = _cityController.text
                                            .toString()
                                            .trim();
                                        String postalCode =
                                            _postalCodeController.text
                                                .toString()
                                                .trim();
                                        String country = _countryController.text
                                            .toString()
                                            .trim();
                                        // String role =
                                        //     _roleController.text.toString().trim();

                                        if ((_nameController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _emailController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _verificationController.text
                                                    .trim()
                                                    .isEmpty ||
                                                // _dobController.text.trim().isEmpty ||
                                                // _designationController.text.trim().isEmpty ||
                                                // _baseSalaryController.text.trim().isEmpty ||
                                                // _paymentFrequencyController.text
                                                //     .trim()
                                                //     .isEmpty ||
                                                // _departmentController.text.trim().isEmpty ||
                                                _ratingController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _phoneNumberController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _skillsController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _apartmentController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _buildingController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _streetController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _cityController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _postalCodeController.text
                                                    .trim()
                                                    .isEmpty ||
                                                _countryController.text
                                                    .trim()
                                                    .isEmpty)
                                            // _roleController.text.trim().isEmpty
                                            ) {
                                          // At least one field is empty
                                          showCustomErrorDialog(
                                              "Pleas fill all the fields!",
                                              context);
                                        } else {
                                          // All fields are filled
                                          if (generatedOTP ==
                                              verificationCode) {
                                            String password =
                                                generateRandomPassword();

                                            String? departmentId =
                                                getDepartmentIdByDesignation(
                                                    dropDownValue);

                                            bool response = await createUser(
                                                name,
                                                email,
                                                dob,
                                                dropDownValue,
                                                password,
                                                dropDownValueRole,
                                                _image,
                                                rating,
                                                departmentId.toString(),
                                                skills,
                                                "$apartment, $building, $street, $city, $postalCode, $country",
                                                phoneNumber,
                                                baseSalary,
                                                context);

                                            if (response) {
                                              //clear all the controllers
                                              _nameController.clear();
                                              _emailController.clear();
                                              _verificationController.clear();
                                              selected = false;
                                              _baseSalaryController.clear();
                                              _ratingController.clear();
                                              _phoneNumberController.clear();
                                              _skillsController.clear();
                                              _apartmentController.clear();
                                              _buildingController.clear();
                                              _streetController.clear();
                                              _cityController.clear();
                                              _postalCodeController.clear();
                                              _countryController.clear();
                                              // _roleController.clear();
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          } else {
                                            showCustomErrorDialog(
                                                "Invalid OTP!", context);
                                          }
                                        }
                                      } catch (e) {
                                        print(e);
                                        showCustomErrorDialog(
                                            "An error occurred. Please try again later.",
                                            context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text('Register Employee',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }

  late String generatedOTP;
  late String imageName;
  bool isSelected = false;

  String generateOTP() {
    Random random = Random();
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += random.nextInt(10).toString();
    }

    return code;
  }

  bool isLoading = false;
}
