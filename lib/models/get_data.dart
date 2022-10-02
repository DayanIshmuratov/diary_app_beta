
class Story {
  Map<String, dynamic> getStory = {};
  Story.toMap(List result) {
    getStory = {"story": result[0], "title": result[1], "date": result[2]};
  }
}