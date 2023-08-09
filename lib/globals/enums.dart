enum SplashResponse {
  authenticated("authenticated", 0),
  blocked("blocked", 2),
  notAuthenticated("notAuthenticated", 1);

  final String name;
  final int code;
  const SplashResponse(this.name, this.code);
}