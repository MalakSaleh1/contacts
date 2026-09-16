import 'dart:io';

import 'package:contact/core/app_colors.dart';
import 'package:contact/services/contact_service.dart';
import 'package:contact/widgets/custom_card.dart';
import 'package:contact/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'model/contact_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContactService service = ContactService();
  List<ContactModel> contacts = [];

  String name = "User name";
  String email = "example@gmail.com";
  String phone = "+200000000000";
  File? selectedImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24,top: 12),
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                width: 120,
                height: 40,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Expanded(
                    child: contacts.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            "assets/empty_list.json",
                            width: 260,
                            height: 240,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "There is No Contacts Added Here",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.gold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return CustomCard(
                            imagePath: contact.imagePath,
                            phone: contact.phone,
                            name: contact.name,
                            email: contact.email,
                            onDelete: () => deleteContact(contact.name),
                          );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                           mainAxisSpacing: 16,
                           childAspectRatio: 177/320),
                                              ),
                        ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Column(
                      spacing: 16,
                      children: [
                        contacts.isNotEmpty?Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Color(0xffF93E3E),
                              foregroundColor: AppColors.darkBlue,
                              onPressed: () {
                                deleteLast();
                              },
                              child:Icon(Icons.delete, color: AppColors.white),
                            ),
                          ],
                        ):SizedBox(),
                        contacts.length<6?Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: _openAddContactSheet,
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.darkBlue,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ):SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddContactSheet() {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height ,
        minHeight: MediaQuery.of(context).size.height * .6,
      ),
      backgroundColor: AppColors.darkBlue,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setSheetState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: pickImage,
                              child: Container(
                                width: 146,
                                height: 146,
                                 padding:selectedImage==null? const EdgeInsets.all(10):EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gold),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: selectedImage==null? Lottie.asset("assets/image_picker.json"): ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.file(selectedImage!,fit: BoxFit.cover,width: double.infinity,height: double.infinity,)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  name.trim().isEmpty ? "User Name" : name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.gold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Divider(color: AppColors.gold, height: 0, thickness: 1),
                                const SizedBox(height: 16),
                                Text(
                                  email.trim().isEmpty ? "example@gmail.com" : email,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.gold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Divider(color: AppColors.gold, height: 0, thickness: 1),
                                const SizedBox(height: 16),
                                Text(
                                  phone.trim().isEmpty ? "+200000000000" : phone,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.gold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          CustomTextField(
                            onChanged: (value) => setSheetState(() => name = value) ,
                            controller: nameController,
                            hint: "Enter User Name",
                            onSubmitted: (value) => setSheetState(() => name = value),
                          ),
                          const SizedBox(height: 9),
                          CustomTextField(
                            onChanged: (value) => setSheetState(() => email = value) ,
                            controller: emailController,
                            hint: "Enter User Email",
                            onSubmitted: (value) => setSheetState(() => email = value),
                          ),
                          const SizedBox(height: 9),
                          CustomTextField(
                            onChanged: (value) => setSheetState(() => phone = value) ,
                            controller: phoneController,
                            hint: "Enter User Phone",
                            onSubmitted: (value) => setSheetState(() => phone = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          addContact(
                            ContactModel(
                              imagePath: selectedImage!.path,
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            ),
                          );
                          nameController.clear();
                          emailController.clear();
                          phoneController.clear();
                          selectedImage=null;
                          name = "User name";
                          email = "example@gmail.com";
                          phone = "+200000000000";
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                        ),
                        child: Text(
                          "Enter User",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addContact(ContactModel contact) async {
    setState(() {
      contacts.add(contact);
    });
    await service.saveContacts(contacts);
  }

  Future<void> loadContacts() async {
    final loaded = await service.loadContacts();
    setState(() {
      contacts = loaded;
    });
  }

  Future<void> deleteContact(String name) async {
    setState(() {
      contacts.removeWhere((c) => c.name == name);
    });
    await service.saveContacts(contacts);
  }

  Future<void> deleteLast() async {
    if (contacts.isEmpty) return;
    setState(() {
      contacts.removeLast();
    });
    await service.saveContacts(contacts);
  }
  
  
  Future<void> pickImage()async{
    final ImagePicker picker=ImagePicker();
    final XFile? image=await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      selectedImage=File(image.path);
      setState(() {
        
      });
    }
  }
}