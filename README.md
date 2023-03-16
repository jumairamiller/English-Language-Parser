# English-Language-Parser

This was an English Lanugage Parser Developed in Prolog. The idea is to define the lexicon foundations:
- Pronouns
- Verbs (Both Transitive and Instransitive)
- Determinants
- Nouns
- Prepositions
- Adjectives

We would then Define the rules that would serve as the grammar for the language 
so the example for the sentence would be:

```prolog
s(s(NP,VP)) --> np(Number,subject,Person,Animacy,NP), vp(Number,Person,Animacy,VP).
```
Here we can see the Sentence is defined as being made up of a noun phrase followed by a verb phrase.

For this to work I had to define the grammar for all parts of the language above so that prolog could then understand whether the sentence entered was valid.

### How To Run:

To run, install [Prolog-swi](https://www.swi-prolog.org/).

Then load the file.
