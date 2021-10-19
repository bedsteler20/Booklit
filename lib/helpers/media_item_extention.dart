import 'package:plexlit/plexlit.dart';

extension MediaItemGenreExt on MediaItem {
  void goTo(BuildContext context) {
    if (type == MediaItemType.offlineAudiobook) {
      context.vRouter.to("/downloads/$id", queryParameters: toMap());
    } else {
      context.vRouter.to("/${type.string}/$id", queryParameters: toMap());
    }
    // router.go(x);
  }

  IconData? get icon {
    if (type != MediaItemType.genre) return null;

    switch (title) {
      case "Architecture":
        return Icons.apartment_outlined;

      case "Art":
        return Icons.color_lens_outlined;

      case "Biography & Autobiography":
        return Icons.accessibility_new_outlined;

      case "Biography & Body, Mind & Spirit":
        return Icons.accessibility_new_outlined;

      case "Computers":
        return Icons.computer_outlined;

      case "Comics & Graphic Novels":
        return Icons.gesture_outlined;

      case "Cooking":
        return Icons.kitchen_outlined;

      case "Business & Economics":
        return Icons.corporate_fare_outlined;

      case "Design":
        return Icons.widgets_outlined;

      case "Drama":
        return Icons.theaters_outlined;

      case "Education":
        return Icons.school_outlined;

      case "Family & Relationships":
        return Icons.group_outlined;

      case "Fiction":
        return Icons.auto_stories_outlined;

      case "Young Adult Fiction":
        return Icons.auto_stories_outlined;

      case "Young Adult Nonfiction":
        return Icons.book_outlined;

      case "Foreign Language Study":
        return Icons.language_outlined;

      case "Games & Activities":
        return Icons.games_outlined;

      case "Gardening":
        return Icons.grading_outlined;

      case "Health & Fitness":
        return Icons.health_and_safety_outlined;

      case "History":
        return Icons.history_outlined;

      case "House & Home":
        return Icons.house_outlined;

      case "Humor":
        return Icons.theater_comedy_outlined;

      case "Juvenile Fiction":
        return Icons.auto_stories_outlined;

      case "Juvenile Nonfiction":
        return Icons.book_outlined;

      case "Language Arts & Disciplines":
        return Icons.language_outlined;

      case "Law":
        return Icons.receipt_long_outlined;

      case "Literary Collections":
        return Icons.collections_outlined;

      case "Literary Criticism":
        return Icons.article_outlined;

      case "Mathematics":
        return Icons.calculate_outlined;

      case "Medical":
        return Icons.local_hospital_outlined;

      case "Music":
        return Icons.music_note_outlined;

      case "Nature":
        return Icons.nature_outlined;

      case "Performing Arts":
        return Icons.theaters_outlined;

      case "Pets":
        return Icons.pets_outlined;

      case "Philosophy":
        return Icons.spa_outlined;

      case "Photography":
        return Icons.camera_outlined;

      case "Poetry":
        return Icons.article_outlined;

      case "Political Science":
        return Icons.policy_outlined;

      case "Psychology":
        return Icons.psychology_outlined;

      case "Science":
        return Icons.science_outlined;

      case "Self-Help":
        return Icons.psychology_outlined;

      case "Social Science":
        return Icons.history_edu_outlined;

      case "Sports & Recreation":
        return Icons.sports_outlined;

      case "Study Aids":
        return Icons.school_outlined;

      case "Technology & Engineering":
        return Icons.engineering_outlined;

      case "Travel":
        return Icons.airplanemode_active_outlined;

      case "True Crime":
        return Icons.local_police_outlined;
      default:
        return Icons.widgets;
    }
  }
}
