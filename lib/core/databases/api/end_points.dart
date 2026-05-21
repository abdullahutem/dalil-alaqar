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
}

class ApiKey {
  static String token = "token";
  static String email = "email";
  static String password = "password";
}
