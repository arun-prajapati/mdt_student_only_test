class LocalServices {
  late List<String> videosList;
  late List<String> revVideosList;
  late List<String> tutorialVideos;
  late List<int> flagsForReplayVideo;
  late int indexOfVideo;
  late int videoduration = 0; //in Seconds
  static final LocalServices _instance = LocalServices._internal();

  // passes the instantiation to the _instance object
  factory LocalServices() => _instance;

  //initialize variables in here
  LocalServices._internal() {
    videosList = [];
    revVideosList = [];
    tutorialVideos = [];
    indexOfVideo = 0;
    flagsForReplayVideo = [];
    videoduration = 0;
  }

  //short getter for my variable
  List<String> getTutorialVideosList() => tutorialVideos;

  //short setter for my variable
  void setTutorialVideosList(List<String> list) => tutorialVideos = list;

  //short getter for my variable
  List<String> getVideosList() => videosList;

  //short setter for my variable
  void setVideosList(List<String> list) => videosList = list;

  //short getter for my variable
  List<String> getRevVideosList() => revVideosList;

  //short setter for my variable
  void setRevVideosList(List<String> list) => revVideosList = list;

  int getIndexOfVideo() => indexOfVideo;

  void setIndexOfVideo(int index) => indexOfVideo = index;

  //short getter for my variable
  List<int> getSelectedFlagsList() => flagsForReplayVideo;

  //short setter for my variable
  void setSelectedFlagsList(List<int> list) => flagsForReplayVideo = list;

  int getVideoDuration() => videoduration;

  void setVideoDuration(int durationInSeconds) =>
      videoduration = durationInSeconds;
}
