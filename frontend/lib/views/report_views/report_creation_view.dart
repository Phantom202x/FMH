
import 'package:app/components/hadj_input.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/search_bar/search_engine.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class ReportCreationView extends StatefulWidget {
  const ReportCreationView({super.key});

  @override
  State<ReportCreationView> createState() => _ReportCreationViewState();
}

class _ReportCreationViewState extends State<ReportCreationView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  String nationality = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 16,
            children: [
              Image(
                image: AssetImage("assets/logo/logo.png"),
              ),
              Text(
                'Who is the missing person ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30,),
              HadjInput(
                hinttext: l10n.name_hint,
                controller:nameController,
                  icon:Icon(Icons.person_outline_rounded),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null; // Validation passed
                }, 
                  ),
              HadjInput(
                  onTap:() => showCountryPicker(
                      context: context,
                      onSelect: (Country country) => setState(() {
                        nationality = country.name;
                        nationalityController.text = country.name;
                      }),
                    ),
                  hinttext: l10n.nationality,
                  controller: nationalityController,
                  icon: Icon(Icons.flag_outlined),  
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your nationality';
                      }
                      return null; // Validation passed
                    },),
              HadjInput(
                hinttext: l10n.phone_hint,
                controller: phoneController,
                icon: Icon(Icons.phone_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null; // Validation passed
                },
              ),
              
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>SearchEngine(
                                    nationality:nationalityController.text,
                                    fullname:nameController.text,
                                    phonenumber:phoneController.text,
                                    )),
                              );
                },
                //async {
                //   if (formKey.currentState!.validate() &&
                //       nationality.isNotEmpty) {
                //     var user = await AuthServices().getUserInfos();
                //     print(user);
                //     Report report = Report(
                //       author: user["full_name"],
                //       fullName: nameController.text,
                //       phone: phoneController.text,
                //       nationality: nationality,
                //     );
                //     ReportServices().createReport(report);
                //   }
                //   if (nationality.isEmpty) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text(l10n.form_validate_nationality),
                //       ),
                //     );
                //   }
                // },
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(size.width * .7, 50),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: Text("Search"),
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Text(
              //     'Aides and Services',
              //     style: TextStyle(color: const Color(0xFF39CC20)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}













// TextFormField(
              //   decoration: InputDecoration(
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.green,
              //       ),
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     contentPadding: EdgeInsets.symmetric(
              //       horizontal: 24,
              //       vertical: 16,
              //     ),
              //     suffixIcon: Icon(Icons.person_outline_rounded),
              //     hintText: l10n.name_hint,
              //   ),
              //   controller: nameController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return l10n.form_validate_full_name;
              //     }
              //     return null;
              //   },
              // ),









// Row(
              //   spacing: 16,
              //   children: [
              //     FilledButton(
              //       onPressed: () => showCountryPicker(
              //         context: context,
              //         onSelect: (Country country) => setState(() {
              //           nationality = country.name;
              //         }),
              //       ),
              //       style: ButtonStyle(
              //         backgroundColor: WidgetStatePropertyAll(Colors.green),
              //       ),
              //       child: Text(l10n.pick_nationality),
              //     ),
              //     Text(
              //       nationality,
              //       style: TextStyle(
              //         //color: Colors.green,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),















              // TextFormField(
              //   decoration: InputDecoration(
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.green,
              //       ),
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     contentPadding: EdgeInsets.symmetric(
              //       horizontal: 24,
              //       vertical: 16,
              //     ),
              //     suffixIcon: IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.phone_outlined,
              //       ),
              //     ),
              //     hintText: l10n.phone_hint,
              //   ),
              //   controller: phoneController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return l10n.form_validate_phone;
              //     }
              //     return null;
              //   },
              // ),