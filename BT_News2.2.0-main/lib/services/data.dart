// category_model.dart dosyasından CategoryModel sınıfı import ediliyor
import 'package:bt_news/models/category_model.dart';


// getCategories fonksiyonu, sabit kategorileri ve ilgili görsellerini döndüren bir fonksiyondur
// Bu fonksiyon, örneğin ana sayfadaki kategori listelerini oluşturmak için kullanılabilir
List<CategoryModel>getCategories(){
  List<CategoryModel> category=[];
  CategoryModel categoryModel=new CategoryModel();

  categoryModel.categoryName="Business";
  categoryModel.image="images/business.jpg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Entertainment";
  categoryModel.image="images/entertainment.jpg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="General";
  categoryModel.image="images/general.jpg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Health";
  categoryModel.image="images/health.jpg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  categoryModel.categoryName="Sports";
  categoryModel.image="images/sport.jpg";
  category.add(categoryModel);
  categoryModel=new CategoryModel();

  return category;
}