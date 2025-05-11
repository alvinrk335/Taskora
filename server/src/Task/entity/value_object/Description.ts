export default class Description {
  private readonly value:string;
  constructor(value: string) {
    if (!value.trim()) {
      throw new Error("Description cannot be empty or blank");
    }
    if (value.length > 500) {
      throw new Error("Description is too long (max 500 characters)");
    }
    // if (!isMeaningful(value)) {
    //   throw new Error("Description is not clear enough");
    // }
    this.value = value;
  }

  public static fromString(desc: string): Description {
    return new Description(desc);
  }

  public toString(): string{
    return this.value;
  }
}
