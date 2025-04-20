export default class Name{
    constructor(
        public name: string
    ){}

    static fromString(str: string): Name {
        return new Name(str);
      }
    public toString(): string{
        return this.name as string;
    }
}