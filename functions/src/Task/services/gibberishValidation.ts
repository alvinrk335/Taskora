import nlp from "compromise";

export default function isMeaningful(text: string): boolean {
    const doc = nlp(text);
    const hasNoun = doc.has('#Noun');
    const hasVerb = doc.has('#Verb');
    const wordCount = doc.wordCount();
  
    return hasNoun && hasVerb && wordCount >= 3;
  }