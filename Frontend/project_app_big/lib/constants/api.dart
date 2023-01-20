// ignore_for_file: constant_identifier_names

class API {
  static const String BASE_URL = 'http://tee.kru.ac.th/cs63/s09/BigFlutter/Test/';
  static const String PUTDATA = 'PutData';
  static const String PUTIMAGE = 'PutImage';

  //----------------Usr-----------------------
  static const String LOGIN = 'ApiUsers/Login';
  static const String USER = 'ApiUsers';
  static const String REGISTER = 'ApiUsers/Register';
  static const String USER_ID = 'USER_ID';
  //---------------------------------------------

  //----------------Product-----------------------
  static const String PRODUCTAll = 'ApiProducts/ProductAll/';
  static const String PRODUCTNEW = 'ApiProducts/ProductNew/';
   static const String APIPRODUCT = 'ApiProducts';
  //----------------------------------------------

  //----------------Orders-----------------------
  static const String ORDER = 'ApiOrders';
  static const String STATUSMONEY = 'ApiOrders/StatusMoney';
  static const String TOGET = 'ApiOrders/ToGet';
  static const String SUCCEED = 'ApiOrders/StatusForUser';
  //--------------------------------------------
  //--------------delivery---------------------
  static const String DELIVERY = 'ApiDeliverys';
  static const String Delivery_Data = 'Delivery_Data';
  //-------------------------------------------

  //--------------review---------------------
  static const String REVIEW = 'ApiReviews';
  //-------------------------------------------

  //--------------list------------------------
  static const String LIST = 'ApiLists';
    static const String REVIEWUSER = 'ApiReviewUser';
  //------------------------------------------
  
  //----------------ApiAddress---------------
   static const String ADDRESS = 'ApiAddress';
   static const String DATAADDRESS = 'ApiDataAddress';
  //-----------------------------------------

  //----------------ApiAddress---------------
   static const String CATEGORYPRODUCT = 'ApiCategoryProducts';
  //-----------------------------------------

   //----------------ApiAddress---------------
   static const String DETAILPRODUCT = 'ApiDetailProducts';
  //-----------------------------------------
  static const String OK = 'OK';
  static const String ISLOGIN = 'ISLOGIN';
}
