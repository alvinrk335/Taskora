import * as admin from 'firebase-admin';
import { User } from './User';

export class UserHandler{
    constructor(
        private uid: string,
        private username: string,
        private email: string,
        private profilePicture: string
      ) {}

      static fromFirestore(data: admin.firestore.DocumentData): UserHandler {
        return new UserHandler(
          data.uid,
          data.username,
          data.email,
          data.profilePicture
        );
      }
    
      toFirestore(): admin.firestore.DocumentData {
        return {
          uid: this.uid,
          username: this.username,
          email: this.email,
          profilePicture: this.profilePicture
        };
      }
      
      toModel(): User{
        return new User(
          this.uid,
          this.username,
          this.email,
          this.profilePicture
        )
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
        return this.email;
    }

    // Setter untuk email
    set setEmail(value: string) {
        this.email = value;
    }

    // Getter untuk profilePicture
    get getProfilePicture(): string {
        return this.profilePicture;
    }

    // Setter untuk profilePicture
    set setProfilePicture(value: string) {
        this.profilePicture = value;
    }
      
}