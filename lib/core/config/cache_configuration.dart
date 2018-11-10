class CacheConfiguration {
  int tweetCacheTimeInHours;

  CacheConfiguration(yamlDoc) {
    tweetCacheTimeInHours = yamlDoc["tweet"] != null ? yamlDoc["tweet"] : 4;
  }

  CacheConfiguration.UnitTesting() {}
}
