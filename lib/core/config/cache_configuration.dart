class CacheConfiguration {
  int tweetCacheTimeInHours;

  CacheConfiguration(yamlDoc) {
    tweetCacheTimeInHours = yamlDoc["tweet"];
  }
}
