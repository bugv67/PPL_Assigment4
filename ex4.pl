/*
 * **********************************************
 * Printing result depth
 *
 * You can enlarge it, if needed.
 * **********************************************
 */
maximum_printing_depth(100).

:- current_prolog_flag(toplevel_print_options, A),
   (select(max_depth(_), A, B), ! ; A = B),
   maximum_printing_depth(MPD),
   set_prolog_flag(toplevel_print_options, [max_depth(MPD)|B]).

% Signature: sub_list(Sublist, List)/2
% Purpose: All elements in Sublist appear in List in the same order.
% Precondition: List is fully instantiated (queries do not include variables in their second argument).





% Signature: swap_list(List, InversedList)/2
% Purpose: InversedList is the ‘mirror’ representation of List, i.e, each item in the list is recursively replaced with the item at the position, with refers to the beginning and the end of the list.   
is_my_list([]).

% חוק 2: כל דבר שמתחיל בראש וממשיך בזנב שהוא רשימה - הוא רשימה.
% השימוש ב- _ משמעו שלא אכפת לנו מה הערך של הראש (Head).
is_my_list([_ | Tail]) :-
    is_my_list(Tail).

swap_list([], []).

% 2. המקרה שלך: הראש הוא רשימה בפני עצמו.
swap_list([H | T], L) :- 
    is_list(H),             % האם הראש הוא רשימה?
    !,                      % קאט! אם כן, אל תבדוק את החוק הבא.
    swap_list(H, SW),       % הפוך את הרשימה הפנימית
    swap_list(T, SWT),      % הפוך את הזנב
    append(SWT, [SW], L).   % חבר הכל יחד

% 3. המקרה החדש: הראש הוא איבר רגיל (אטום).
% הגענו לפה רק כי ה-is_list נכשל למעלה.
swap_list([H | T], L) :- 
    swap_list(T, SWT),      % הופכים רק את הזנב (כי אין מה להפוך באיבר בודד)
    append(SWT, [H], L).    % לוקחים את הזנב ההפוך, ומוסיפים לו בסוף את האיבר הראשון




% Signature: sub_tree(Subtree, Tree)/2
% Purpose: Tree contains Subtree.
subtree(void void).    %???
subtree(subT,tree(X,L,R)):- subtree(subT, L)
subtree(subT,tree(X,L,R)):-subtree(subT, R)
subtree(tree(a,L1,R1),tree(a,L2,R2)):-subtree(R1, R2),subtree(L1, L2)




% Signature: swap_tree(Tree, InversedTree)/2
% Purpose: InversedTree is the �mirror� representation of Tree.
swap_tree(void void).   
swap_tree(SubT,tree(X,L,R)):- swap_tree(L,SWL),swap_tree(X,L). %% no no 
swap_tree(SubT,tree(X,L,R)):- swap_tree(R,SWR),swap_tree(X,R). %% no no 
swap_tree(tree(X,L1,R1),tree(X,L2,R2)):-swap_tree(L1,R2),swap_tree(R1,L2).
