// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    enum VoteStates {
        Absent,
        Yes,
        No
    }
    uint VOTE_THRESHOLD = 10;

    struct Proposal {
        address target;
        bool executed;
        bytes data;
        uint yesCount;
        uint noCount;
        mapping(address => VoteStates) voteStates;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint);

    event VoteCast(uint, address indexed);

    mapping(address => bool) members;

    constructor(address[] memory _members) {
        for (uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        members[msg.sender] = true;
    }

    function newProposal(
        address _target,
        bytes calldata _data
    ) external onlyMembers {
        emit ProposalCreated(proposals.length);
        Proposal storage proposal = proposals.push();
        proposal.target = _target;
        proposal.data = _data;
    }

    function castVote(uint _proposalId, bool _supports) external onlyMembers {
        Proposal storage proposal = proposals[_proposalId];

        if (proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        }
        if (proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        if (_supports) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }

        proposal.voteStates[msg.sender] = _supports
            ? VoteStates.Yes
            : VoteStates.No;
        emit VoteCast(_proposalId, msg.sender);

        if (proposal.yesCount == VOTE_THRESHOLD && !proposal.executed) {
            (bool success, ) = proposal.target.call(proposal.data);
            require(success);
            proposal.executed = true;
        }
    }

    modifier onlyMembers() {
        require(members[msg.sender], "you need be a member");
        _;
    }
}
