import 'package:contact_app/contact_add_screen.dart';
import 'package:contact_app/contact_update_screen.dart';
import 'package:contact_app/db/cached_contact.dart';
import 'package:contact_app/db/my_repostory.dart';
import 'package:contact_app/widgets/contact_item.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<CachedContact> cachedContacts = [];

//TODO 3 Read from database
  void _init() async {
    cachedContacts = await MyRepository.getAllCachedContact();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext con) {
                      //TODO 5 Add new contact item
                      return ContactAddScreen(
                        listenerCallBack: (bool value) {
                          if (true) {
                            _init();
                          }
                        },
                      );
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          const SizedBox(width: 20),
          TextButton(
              onPressed: () {
                MyRepository.deleteAllCachedCategories();
                _init();
              },
              child: const Text(
                "Clear All",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() async {
            _init();
          });
        },
        child: ListView.builder(
            itemCount: cachedContacts.length,
            itemBuilder: (BuildContext context, index) {
              return ContactItem(
                //TODO 6 Delete contact item
                onDeleteTap: () {
                  MyRepository.deleteCachedContactById(
                      id: cachedContacts[index].id!);
                  _init();
                },
                fullName: cachedContacts[index].fullName,
                phoneNumber: cachedContacts[index].phone,
                onUpdateTap: () {
                  //TODO 4 Update contact item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext con) {
                        return ContactUpdateScreen(
                          id: cachedContacts[index].id!,
                          initialFullName: cachedContacts[index].fullName,
                          initialPhone: cachedContacts[index].phone,
                          listenerCallBack: (bool value) {
                            if (value) {
                              _init();
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
