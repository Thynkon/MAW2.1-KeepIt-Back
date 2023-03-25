require 'rails_helper'

describe User do
  before do
    @user1 = User.create!(username: 'user1', email: 'user1@mail.com', password: 'password')
    @user2 = User.create!(username: 'user2', email: 'user2@mail.com', password: 'password')
  end

  after do
    @user = nil
  end

  describe 'invitations' do
    it 'sends invitation' do
      @user1.send_invitation(@user2)

      expect(@user2.invitations.map {|i|  i.user }).to include(@user1)
    end

    it 'accepts an invitation' do
      @user1.send_invitation(@user2)
      @user2.accept_invitation(@user2.invitations.first)

      expect(@user1.friends).to include(@user2)
    end

    it 'denies an invitation' do
      @user1.send_invitation(@user2)
      invitation = @user2.invitations.first
      invitations = UserHasFriend.all

      @user2.deny_invitation(invitation)

      expect(invitations).not_to include(invitation)
      expect(@user1.friends).not_to include(@user2)
    end
  end
end
