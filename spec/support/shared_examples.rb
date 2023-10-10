shared_examples_for 'user_not_login' do
  context 'When user logged in not yet' do
    it "message access denied" do
      expect(flash[:alert]).to eq(I18n.t("access_denied"))
    end
    it "redirect to root" do
      expect(response).to redirect_to(root_url)
    end
  end
end
