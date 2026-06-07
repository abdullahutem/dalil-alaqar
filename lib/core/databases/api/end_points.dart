class EndPoints {
  static const String baserUrl = "https://dalil-alaqar.codebrains.net/api/";
  static const String kBaseImageUrl =
      'https://dalil-alaqar.codebrains.net/storage/';

  static const String login = "office/login";
  static const String logout = "office/logout";
  static const String advertisements = "public/advertisements";
  static const String properties = "public/properties";
  static String propertyDetails(int id) => "public/properties/$id";
  static const String propertyTypes = "public/data/property-types";
  static const String offerTypes = "public/data/offer-types";
  static const String governorates = "public/data/governorates";
  static String districtsByGovernorate(int governorateId) =>
      "public/data/governorates/$governorateId/districts";
  static String neighborhoodsByDistrict(int districtId) =>
      "public/data/districts/$districtId/neighborhoods";
  static const String offices = 'public/offices';
  static const String promotions = 'public/promotions';
  static const String dashboard = 'office/dashboard';
  static const String employees = 'office/employees';
  static const String officeInfo = 'office/office';
  static const String officeLogo = 'office/office/logo';
  static const String officeProperties = 'office/properties';
  static const String officePropertiesStats = 'office/properties/stats';
  static String deleteOfficeProperty(int id) => 'office/properties/$id';
  static String officePropertyDetails(int id) => 'office/properties/$id';
  static String updateOfficePropertyStatus(int id) =>
      'office/properties/$id/status';
  static String uploadPropertyImages(int id) =>
      'office/properties/$id/images/multiple';
  static String setPrimaryImage(int propertyId, int imageId) =>
      'office/properties/$propertyId/images/$imageId/primary';
  static String deletePropertyImage(int propertyId, int imageId) =>
      'office/properties/$propertyId/images/$imageId';
  static const String profile = 'office/user';
  static const String updateProfile = 'office/profile';
  static const String plans = 'office/plans';
  static String planDetails(int id) => 'office/plans/$id';
}

class ApiKey {
  static String token = "token";
  static String email = "email";
  static String password = "password";
}
