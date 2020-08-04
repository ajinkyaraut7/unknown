class User {

  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;

  User(
    {this.uid, this.displayName, this.email, this.phoneNumber, this.photoUrl}
    );

}


class UserData {
  final String uid;
  final String name;
  final String gender;
  final String number;
  final String email;
  final String username;
  final String aboutMe;
  final String college;
  final String year;
  final String dept;
  final String relationshipStatus;
  final String profilePicUrl;
  final String backgroundImageUrl;

  UserData(
      {
      this.backgroundImageUrl,
      this.profilePicUrl,
      this.relationshipStatus,
      this.dept,
      this.year,
      this.college,
      this.aboutMe,
      this.uid,
      this.name,
      this.gender,
      this.number,
      this.email,
      this.username});
}