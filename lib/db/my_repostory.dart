import 'package:contact_app/db/cached_contact.dart';
import 'package:contact_app/db/local_database.dart';

class MyRepository {
  static final MyRepository _instance = MyRepository._();

  factory MyRepository() {
    return _instance;
  }

  MyRepository._();

//  -----------------------------------TO DO------------------------------------------

  static Future<CachedContact> insertCachedContact(
      {required CachedContact cachedContact}) async {
    return await LocalDatabase.insertCachedContacts(cachedContact);
  }

  static Future<CachedContact> getSingleContactById({required int id}) async {
    return await LocalDatabase.getSingleContactsById(id);
  }

  static Future<List<CachedContact>> getAllCachedContact() async {
    return await LocalDatabase.getAllCachedContacts();
  }

  static Future<int> deleteCachedContactById({required int id}) async {
    return await LocalDatabase.deleteCachedConactsById(id);
  }

  static Future<int> updateCachedContactById(
      {required CachedContact cachedContact}) async {
    return await LocalDatabase.updateCachedCategory(
        cachedContact: cachedContact);
  }

  static Future<int> deleteAllCachedCategories() async {
    return await LocalDatabase.deleteAllCachedCategories();
  }
}
