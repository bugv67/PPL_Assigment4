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
sub_list(_,[]).
sub_list([X|SubTail], [X|ListTail]) :- sub_list(SubTail, ListTail).
sub_list(Sub, [_|ListTail]) :- sub_list(Sub, ListTail).




% Signature: swap_list(List, InversedList)/2
% Purpose: InversedList is the ‘mirror’ representation of List, i.e, each item in the list is recursively replaced with the item at the position, with refers to the beginning and the end of the list.   
swap_list([],[]).
swap_list([H|T], InversedList) :- is_list(H), !, swap_list(H, InversedHead), swap_list(T, InversedTail), append(InversedTail, [InversedHead], InversedList).
swap_list([H|T], InversedList) :- swap_list(T, InversedTail), append(InversedTail, [H], InversedList).








% Signature: sub_tree(Subtree, Tree)/2
% Purpose: Tree contains Subtree.
sub_tree(tree(X, L, R), tree(X, L, R)).
sub_tree(ST, tree(_, L, _)) :- sub_tree(ST, L).
sub_tree(ST, tree(_, _, R)) :- sub_tree(ST, R).



% Signature: swap_tree(Tree, InversedTree)/2
% Purpose: InversedTree is the �mirror� representation of Tree.
swap_tree(void, void).
swap_tree(tree(X, L, R), tree(X, RS, LS)) :- swap_tree(L, LS), swap_tree(R, RS).