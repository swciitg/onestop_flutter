class Endpoints {
  static const baseUrl = String.fromEnvironment('SERVER-URL');
  static const irbsBaseUrl = String.fromEnvironment('IRBS-SERVER-URL');
  static const String restaurantURL = "/getAllOutlets";
  static const String lastUpdatedURL = "/lastDataUpdate";
  static const String contactURL = "/getContacts";
  static const String timetableURL =
      "https://swc.iitg.ac.in/smartTimetable/get-my-courses";
  static const String ferryURL = '/ferryTimings';
  static const String homeImage = '/homeImage';
  static const String busURL = '/busTimings';
  static const String busStops = '/busstops';
  static const String messURL = "/hostelsMessMenu";
  static const String buyURL = '/buy';
  static const String sellURL = '/sell';
  static const String buyPath = '/buyPage';
  static const String sellPath = '/sellPage';
  static const String bnsMyAdsURL = '/bns/myads';
  static const String lnfMyAdsURL = '/lnf/myads';
  static const String deleteBuyURL = "/buy/remove";
  static const String deleteSellURL = "/sell/remove";
  static const String deleteLostURL = "/lost/remove";
  static const String deleteFoundURL = "/found/remove";
  static const String lostURL = '/lost';
  static const String lostPath = '/lostPage';
  static const String foundPath = '/foundPage';
  static const String foundURL = '/found';
  static const String claimItemURL = "/found/claim";
  static const String newsURL = "/news";
  static const String githubIssueToken =
      String.fromEnvironment('GITHUB_ISSUE_TOKEN');
  static const apiSecurityKey = String.fromEnvironment('SECURITY-KEY');
  static const feedback =
      'https://api.github.com/repos/swciitg/onestop_flutter/issues';
  static const String upspPost = '/upsp/submit-request';
  static const String uploadFileUPSP = "/upsp/file-upload";
  static const String guestLogin = "/user/guest/login";
  static const String userProfile = "/user";
  static const String userDeviceTokens = "/user/device-tokens";
  static const String userNotifPrefs = "/user/notifs/prefs";
  static const String generalNotifications = "/notification";
  static const String userNotifications = "/user/notifs";
  static const String messSubChange = "/api/sub";
  static const String messOpi = "/api/opi";
  static const String homePageUrls = '/homepage';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      'security-key': Endpoints.apiSecurityKey
    };
  }
}
