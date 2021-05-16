/*
NOTES FOR MARKER:

1)  Sources:
        - http://cs.union.edu/~striegnk/courses/esslli04prolog/practical.day4.php?s=day4.node3.sol1

2)  Rules based on breakdown of example query and parse:

        ?- s(Tree, [the, woman, on, two, chairs, in, a, room, sees, two, tall, young, men], []).

        Tree = s(np(det(the), nbar(n(woman)), pp(prep(on), np(det(two), nbar(n(chairs)), 
        pp(prep(in), np(det(a), nbar(n(room))))))), vp(v(sees), np(det(two), nbar(jp(adj(tall), 
        jp(adj(young), n(men)))))))


    Split Parse Tree to visually see each layer of arguments:

        s(
            np(
                det(the), 
                nbar(
                    n(woman)), 
                pp(
                    prep(on), 
                    np(
                        det(two), 
                        nbar(
                            n(chairs)), 
                        pp(
                            prep(in),
                            np(
                                det(a), 
                                nbar(
                                    n(room)
                                )
                            )
                        )
                    )
                )
            ), 
            vp(
                v(sees), 
                np(
                    det(two), 
                    nbar(
                        jp(
                            adj(tall), 
                            jp(
                                adj(young), 
                                n(men)
                            )
                        )
                    )
                )
            )
        ).   


    Pseudo Rules extracted from Parse Tree:

        s -> np, vp.

        
        np -> det, nbar, pp.
        np -> det, nbar. 
        np -> nbar.
        np -> pro.
        

        pp-> prep, np.

        nbar -> n.
        nbar -> jp.

        vp -> tv, np. 
        vp -> iv. 

        jp -> adj, jp. 
        jp -> adj, n. 
*/

/* GRAMMAR PRODUCTION RULES ----------------------------------------------------------------------- */
% A sentence is composed of a noun phrase followed by a verb phrase
s(s(NP,VP)) --> np(Number,subject,Person,Animacy,NP), vp(Number,Person,Animacy,VP).


np(Number,_,_,_,np(Det,N,PP)) --> det(Number,Det), nbar(Number,_,N), pp(PP). 
np(Number,_,_,Animacy,np(Det,N)) --> det(Number,Det), nbar(Number,Animacy,N).
np(plural,_,_,_,np(N)) --> nbar(plural,_,N).
np(Number,Role,Person,_,np(Pro)) --> pro(Role,Number,Person,Pro).
 
pp(pp(Prep, NP)) --> prep(Prep), np(_,_,_,_,NP).

vp(Number,Person,Animacy,vp(V)) --> iv(Number,Person,Animacy,V). 
vp(Number,Person,Animacy,vp(V,NP)) --> tv(Number,Person,Animacy,V), np(_,object,_,_,NP). 

nbar(Number,Animacy,nbar(N)) --> n(Number,Animacy,N).
nbar(_,_,nbar(Jp)) --> jp(Jp).

jp(jp(Adj,N)) --> adj(Adj), n(_,_,N).
jp(jp(Adj,Jp)) --> adj(Adj),jp(Jp).

pro(Role,Number,Person,pro(Word)) --> [Word], {lex(Word,pro,Number,Person,Role)}.
iv(Number,Person,Animacy,v(Word)) --> [Word],{lex(Word,iv,Number,Person,Animacy)}.
tv(Number,Person,Animacy,v(Word)) --> [Word],{lex(Word,tv,Number,Person,Animacy)}.
det(Number,det(Word)) --> [Word],{lex(Word,det,Number)}.
n(Number,Animacy,n(Word)) --> [Word],{lex(Word,n,Number,Animacy)}.
prep(prep(Word)) --> [Word],{lex(Word,prep)}.
adj(adj(Word)) --> [Word],{lex(Word,adj)}.

/* LEXICON ---------------------------------------------------------------------------------- */
/* PRONOUNS */
lex(i,pro,singular,1,subject).
lex(you,pro,singular,2,subject).
lex(he,pro,singular,3,subject).
lex(she,pro,singular,3,subject).
lex(it,pro,singular,3,subject).
lex(we,pro,plural,1,subject).
lex(you,pro,plural,2,subject).
lex(they,pro,plural,3,subject).
lex(me,pro,singular,1,object).
lex(you,pro,singular,2,object).
lex(him,pro,singular,3,object).
lex(her,pro,singular,3,object).
lex(it,pro,singular,3,object).
lex(us,pro,plural,1,object).
lex(you,pro,plural,2,object).
lex(them,pro,plural,3,object).

/* VERBS - transitive and intransitive */
lex(know,tv,singular,1,animate).
lex(know,tv,singular,2,animate).
lex(knows,tv,singular,3,animate).
lex(know,tv,plural,_,animate).
lex(see,tv,singular,1,animate).
lex(see,tv,singular,2,animate).
lex(sees,tv,singular,3,animate).
lex(see,tv,plural,_,animate).
lex(hire,tv,singular,1,animate).
lex(hire,tv,singular,2,animate).
lex(hires,tv,singular,3,animate).
lex(hire,tv,plural,_,animate).
lex(fall,iv,singular,1,_).
lex(fall,iv,singular,2,_).
lex(falls,iv,singular,3,_).
lex(fall,iv,plural,_,_).
lex(sleep,iv,singular,1,animate).
lex(sleep,iv,singular,2,animate).
lex(sleeps,iv,singular,3,animate).
lex(sleep,iv,plural,_,animate).

/* DETERMINERS */
lex(the,det,_).
lex(a,det,singular).
lex(two,det,plural).

/* NOUNS */
lex(man,n,singular,animate).
lex(woman,n,singular,animate).
lex(apple,n,singular,inanimate).
lex(chair,n,singular,inanimate).
lex(room,n,singular,inanimate).
lex(men,n,plural,animate).
lex(women,n,plural,animate).
lex(apples,n,plural,inanimate).
lex(chairs,n,plural,inanimate).
lex(rooms,n,plural,inanimate).

/* PREPOSITIONS */
lex(on,prep).
lex(in,prep).
lex(under,prep).

/* ADJECTIVES */
lex(old,adj).
lex(young,adj).
lex(red,adj).
lex(short,adj).
lex(tall,adj).

/*
TEST SENTENCE QUERIES AND OUTPUTS: 
1)  ?- s(Tree,[the,woman,sees,the,apples],[]).
    Tree = s(np(det(the), nbar(n(woman))), vp(v(sees), np(det(the), nbar(n(apples))))) .

2)  ?- s(Tree,[a,woman,knows,him],[]).
    Tree = s(np(det(a), nbar(n(woman))), vp(v(knows), np(pro(him)))) .

3)  ?- s(Tree,[two,woman,hires,a,man],[]).
    false.

4)  ?- s(Tree,[two,women,hire,a,man],[]).
    Tree = s(np(det(two), nbar(n(women))), vp(v(hire), np(det(a), nbar(n(man))))) .

5)  ?- s(Tree,[she,knows,her],[]).
    Tree = s(np(pro(she)), vp(v(knows), np(pro(her)))).

6)  ?- s(Tree,[she,know,the,man],[]).
    false.

7)  ?- s(Tree,[us,see,the,apple],[]).
    false.

8   ?- s(Tree,[we,see,the,apple],[]).
    Tree = s(np(pro(we)), vp(v(see), np(det(the), nbar(n(apple))))) .

9)  ?- s(Tree,[i,know,a,short,man],[]).
    Tree = s(np(pro(i)), vp(v(know), np(det(a), nbar(jp(adj(short), n(man)))))) .

10) ?- s(Tree,[he,hires,they],[]).
    false.

11) ?- s(Tree,[two,apples,fall],[]).
    Tree = s(np(det(two), nbar(n(apples))), vp(v(fall))) .

12) ?- s(Tree,[the,apple,falls],[]).
    Tree = s(np(det(the), nbar(n(apple))), vp(v(falls))) .

13) ?- s(Tree,[the,apples,fall],[]).
    Tree = s(np(det(two), nbar(n(apples))), vp(v(fall))) .

14) ?- s(Tree,[i,sleep],[]).
    Tree = s(np(pro(i)), vp(v(sleep))) .

15) ?- s(Tree,[you,sleep],[]).
    Tree = s(np(pro(you)), vp(v(sleep))) .

16) ?- s(Tree,[she,sleeps],[]).
    Tree = s(np(pro(she)), vp(v(sleeps))) .

17) ?- s(Tree,[he,sleep],[]).
    false.

18) ?- s(Tree,[them,sleep],[]).
    false. 

19) ?- s(Tree,[a,men,sleep],[]).
    false. 

20) ?- s(Tree,[the,tall,woman,sees,the,red],[]).
    false.

21) ?- s(Tree,[the,young,tall,man,knows,the,old,short,woman],[]).
    Tree = s(np(det(the), nbar(jp(adj(young), jp(adj(tall), n(man))))), vp(v(knows), 
    np(det(the), nbar(jp(adj(old), jp(adj(short), n(woman))))))) .

22) ?- s(Tree,[a,man,tall,knows,the,short,woman],[]).
    false. 

23) ?- s(Tree,[a,man,on,a,chair,sees,a,woman,in,a,room],[]).
    Tree = s(np(det(a), nbar(n(man)), pp(prep(on), np(det(a), nbar(n(chair))))), vp(v(sees), 
    np(det(a), nbar(n(woman)), pp(prep(in), np(det(a), nbar(n(room))))))) .

24) ?- s(Tree,[a,man,on,a,chair,sees,a,woman,a,room,in],[]).
    false. 

25) ?- s(Tree,[the,tall,young,woman,in,a,room,on,the,chair,in,a,room,in,the,room,sees,the,red,apples,under,the,chair],[]).
    Tree = s(np(det(the), nbar(jp(adj(tall), jp(adj(young), n(woman)))), pp(prep(in), np(det(a), nbar(n(room)), pp(prep(on), 
    np(det(the), nbar(n(chair)), pp(prep(in), np(det(a), nbar(n(...)), pp(prep(...), np(..., ...))))))))), vp(v(sees), 
    np(det(the), nbar(jp(adj(red), n(apples))), pp(prep(under), np(det(the), nbar(n(chair))))))) .


ANIMACY TEST SENTENCE QUERIES AND OUTPUTS: 
1)  ?- s(Tree,[the,woman,sees,the,apples],[]).
    Tree = s(np(det(the), nbar(n(woman))), vp(v(sees), np(det(the), nbar(n(apples))))) .

2)  ?- s(Tree,[a,woman,knows,him],[]).
    Tree = s(np(det(a), nbar(n(woman))), vp(v(knows), np(pro(him)))) .
    
3)  ?- s(Tree,[the,man,sleeps],[]).
    Tree = s(np(det(the), nbar(n(man))), vp(v(sleeps))) .

4)  ?- s(Tree,[the,room,sleeps],[]).
    false.

5)  ?- s(Tree,[the,apple,sees,the,chair],[]).
    false.

6)  ?- s(Tree,[the,room,knows,the,man],[]).
    false.

7)  ?- s(Tree,[the,apple,falls],[]).
    Tree = s(np(det(the), nbar(n(apple))), vp(v(falls))) .

8   ?- s(Tree,[the,man,falls],[]).
    Tree = s(np(det(the), nbar(n(man))), vp(v(falls))) .
    
*/