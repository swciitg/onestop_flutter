class Endpoints {
  static const baseUrl = 'https://swc.iitg.ac.in';
  static const String restaurantURL = "$baseUrl/onestopapi/v2/getAllOutlets";
  static const String lastUpdatedURL = "$baseUrl/onestopapi/v2/lastDataUpdate";
  static const String contactURL = "$baseUrl/onestopapi/v2/getContacts";
  static const String timetableURL = "$baseUrl/smartTimetable/get-my-courses";
  static const String ferryURL = '$baseUrl/onestopapi/v2/ferryTimings';
  static const String busURL = '$baseUrl/onestopapi/v2/busTimings';
  static const String busStops = '$baseUrl/onestopapi/v2/busstops';
  static const String messURL = "$baseUrl/onestopapi/v2/hostelsMessMenu";
  static const String buyURL = '$baseUrl/onestopapi/v2/buy';
  static const String sellURL = '$baseUrl/onestopapi/v2/sell';
  static const String sellPath = '/onestopapi/v2/sellPage';
  static const String buyPath = '/onestopapi/v2/buyPage';
  static const String bnsMyAdsURL = '$baseUrl/onestopapi/v2/bns/myads';
  static const String lnfMyAdsURL = '$baseUrl/onestopapi/v2/lnf/myads';
  static const String deleteBuyURL = "$baseUrl/onestopapi/v2/buy/remove";
  static const String deleteSellURL = "$baseUrl/onestopapi/v2/sell/remove";
  static const String deleteLostURL = "$baseUrl/onestopapi/v2/lost/remove";
  static const String deleteFoundURL = "$baseUrl/onestopapi/v2/found/remove";
  static const String lostURL = '$baseUrl/onestopapi/v2/lost';
  static const String lostPath = '/onestopapi/v2/lostPage';
  static const String foundPath = '/onestopapi/v2/foundPage';
  static const String foundURL = '$baseUrl/onestopapi/v2/found';
  static const String claimItemURL = "$baseUrl/onestopapi/v2/found/claim";
  static const String newsURL = "$baseUrl/onestopapi/v2/news";
  static const String githubIssueToken =
      String.fromEnvironment('GITHUB_ISSUE_TOKEN');
  static const apiSecurityKey = String.fromEnvironment('SECURITY-KEY');
  static const feedback =
      'https://api.github.com/repos/vrrao01/onestop_dev/issues';
  static const String upspPost = '$baseUrl/onestopapi/v2/upsp/submit-request';
  static const String uploadFileUPSP =
      "$baseUrl/onestopapi/v2/upsp/file-upload";

  static getHeader() {
    return {'Content-Type': 'application/json', 'security-key': apiSecurityKey};
  }
}
