import {UserHandler} from "./user_handler";

export class User {
  constructor(
      private uid: string,
      private username: string,
      private email?: string,
      private profilePicture?: string
  ) {}

  static empty = new User("", "", "", "");

  toHandler(): UserHandler {
    return new UserHandler(
      this.uid,
      this.username,
      this.email ?? "",
      this.profilePicture ?? ""
    );
  }

  static fromHandler(handler : UserHandler): User {
    return new User(
      handler.getUid,
      handler.getUsername,
      handler.getEmail,
      handler.getProfilePicture
    );
  }
  // Getter untuk uid
  get getUid(): string {
    return this.uid;
  }

  // Setter untuk uid
  set setUid(value: string) {
    this.uid = value;
  }

  // Getter untuk username
  get getUsername(): string {
    return this.username;
  }

  // Setter untuk username
  set setUsername(value: string) {
    this.username = value;
  }

  // Getter untuk email
  get getEmail(): string {
    return this.email ?? "";
  }

  // Setter untuk email
  set setEmail(value: string) {
    this.email = value;
  }

  // Getter untuk profilePicture
  get getProfilePicture(): string {
    return this.profilePicture ?? "";
  }

  // Setter untuk profilePicture
  set setProfilePicture(value: string) {
    this.profilePicture = value;
  }
}

