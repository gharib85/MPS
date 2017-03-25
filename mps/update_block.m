function new_block = update_block(prev_block,M_1,O,M_2,direction)
% To be used in the block abstraction when contracting an MPS. This function
% computes the update of the new block, in the direction specified.
% The corresponding tensor diagrams are
%
%   -M_1-                                  -M_1-
%    |   \                                /  |
%   -O-   =prev_block    or    prev_block=  -O-
%    |   /                                \  |
%   -M_2-                                  -M_2-
%   
% direction == -1(right) or   direction == +1 (left)
%
% INPUT
%   prev_block:	rank-2 cell array corresponding to the set of observables
%				in MPO form. The first index corresponds to the ordering of
%				the observables, while the second index corresponds to the 
%				site (physical) index, and necessarily must match the number
%				of sites in mps
%   M_1:      	MPS element corresponding to the bra-state
%	O:			MPO element to sandwich between the MPS elements, an empty 
%				element can be provided
%   M_2:      	MPS element corresponding to the ket-state
%	direction:	direction in which the block are being updated, specify
%				left (-1) or right (+1)
% OUTPUT
%   obs:		vector corresponding to the observables associated to 

switch direction
	case +1 % Going left
		new_block = contract(M_2,3,1,prev_block,3,2);
		if ~isempty(O)
			new_block = contract(new_block,4,[2,4],O,4,[4,1]);
			new_block = contract(conj(M_1),3,[1,3],new_block,4,[2,4]);
		else
			new_block = contract(conj(M_1),3,[1,3],new_block,4,[3,2]);
		end

	case -1 % Going right
		new_block = contract(M_2,3,2,prev_block,3,2);
		if ~isempty(O)
			new_block = contract(new_block,4,[2,4],O,4,[4,2]);
			new_block = contract(conj(M_1),3,[2,3],new_block,4,[2,4]);
		else
			new_block = contract(conj(M_1),3,[2,3],new_block,4,[3,2]);
		end
end
end