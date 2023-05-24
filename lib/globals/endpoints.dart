class Endpoints {
  static const baseUrl = String.fromEnvironment('SERVER-URL');
  static const String restaurantURL = "$baseUrl/getAllOutlets";
  static const String lastUpdatedURL = "$baseUrl/lastDataUpdate";
  static const String contactURL = "$baseUrl/getContacts";
  static const String timetableURL = "$baseUrl/smartTimetable/get-my-courses";
  static const String ferryURL = '$baseUrl/ferryTimings';
  static const String busURL = '$baseUrl/busTimings';
  static const String busStops = '$baseUrl/busstops';
  static const String messURL = "$baseUrl/hostelsMessMenu";
  static const String buyURL = '$baseUrl/buy';
  static const String sellURL = '$baseUrl/sell';
  static const String sellPath = '/sellPage';
  static const String buyPath = '/buyPage';
  static const String bnsMyAdsURL = '$baseUrl/bns/myads';
  static const String lnfMyAdsURL = '$baseUrl/lnf/myads';
  static const String deleteBuyURL = "$baseUrl/buy/remove";
  static const String deleteSellURL = "$baseUrl/sell/remove";
  static const String deleteLostURL = "$baseUrl/lost/remove";
  static const String deleteFoundURL = "$baseUrl/found/remove";
  static const String lostURL = '$baseUrl/lost';
  static const String lostPath = '/lostPage';
  static const String foundPath = '/foundPage';
  static const String foundURL = '$baseUrl/found';
  static const String claimItemURL = "$baseUrl/found/claim";
  static const String newsURL = "$baseUrl/news";
  static const String githubIssueToken = String.fromEnvironment('GITHUB_ISSUE_TOKEN');
  static const apiSecurityKey = String.fromEnvironment('SECURITY-KEY');
  static const feedback = 'https://api.github.com/repos/swciitg/onestop_flutter/issues';
  static const String upspPost = '$baseUrl/upsp/submit-request';
  static const String uploadFileUPSP = "$baseUrl/upsp/file-upload";

  static getHeader() {
    return {'Content-Type': 'application/json', 'security-key': apiSecurityKey};
  }
}
