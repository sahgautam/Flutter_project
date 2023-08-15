import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Midnight Mocha", status: "active", imageUrl: "https://lifeboostcoffee.com/cdn/shop/files/midnightblueberrymocha6_1200x1200.png?v=1682446677"),
        CategoryModel(categoryName: "Vanilla Bliss", status: "active", imageUrl: "https://cdn.gardengrocer.com/attachments/photos/high_res/5392.jpg?2214"),
        CategoryModel(categoryName: "Caramel Macchiato", status: "active", imageUrl: "https://c8.alamy.com/comp/G0K9P3/a-cup-of-hot-caramel-macchiato-G0K9P3.jpg"),
        CategoryModel(categoryName: "Espresso Royale", status: "active", imageUrl: "https://cloudfront-us-east-1.images.arcpublishing.com/gmg/I7GH5PB2UJD6NMNYG24NQVXHJY.jpg"),
        CategoryModel(categoryName: "Hazelnut Delight", status: "active", imageUrl: "https://m.media-amazon.com/images/I/71Jg-lSOL4L.jpg"),
      ];
  }



}