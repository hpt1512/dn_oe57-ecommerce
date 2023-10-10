require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  let(:admin) {create :user, email: "admin1@gmal.com", is_admin: true}
  let(:user1) {create :user, email: "user1@gmal.com"}
  let!(:order1) {create :order, user_id: user1.id, status: "awaiting"}
  let!(:order2) {create :order, user_id: user1.id, status: "awaiting"}
  let(:category1) {create :category, name: "Category 1"}
  let!(:product1) {create :product, category_id: category1.id}
  let!(:order_detail_1) {create :order_detail, order_id: order1.id, product_id: product1.id, quantity_product: 1 }
  let!(:order_detail_2) {create :order_detail, order_id: order2.id, product_id: product1.id, quantity_product: 2 }
  let(:params) {{ order_ids: [order1.id, order2.id]}}



  describe 'GET#index' do
    context "When user is logged in" do
      before do
        sign_in(admin)
        get :index
      end

      context "When user is admin" do
        it "assigns @orders" do
          expect(assigns(:orders)) == ([order1])
        end

        it "render the index template" do
          expect(response).to render_template("index")
        end
      end

      context "When user is not admin" do
        let(:admin) {create :user, email: "admin2@gmal.com", is_admin: false}

        it "message user not admin" do
          expect(flash[:alert]).to eq(I18n.t("access_denied"))
        end

        it "redirect to root" do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "When user not logged in" do
      before do
        get :index
      end

      include_examples 'user_not_login'
    end
  end

  describe "POST#batch_confirm" do
    context "When user is logged in" do
      before do
        sign_in(admin)
      end

      context "When user is admin" do
        context "confirm success" do
          it do
            expect {
              post :batch_confirm, params: params
            }.to change { [order1.reload.status, order2.reload.status] }.from(["awaiting", "awaiting"]).to(["confirmed", "confirmed"])
          end
        end

        context "confirm faild" do
          let(:params) {{ order_ids: []}}

          context "orders selected empty" do
            before do
              post :batch_confirm, params: params
            end

            it "redirect to admin_orders_path" do
              expect(response).to redirect_to(admin_orders_path)
            end

            it "message no_order_selected" do
              expect(flash[:error]).to eq(I18n.t("no_order_selected"))
            end
          end
        end
      end

      context "When user is not admin" do
        let(:admin) {create :user, email: "admin2@gmail.com", is_admin: false}

        before do
          post :batch_confirm, params: params
        end

        it "redirect to root" do
          expect(response).to redirect_to(root_path)
        end

        it "message user not admin" do
          expect(flash[:alert]).to eq(I18n.t("access_denied"))
        end
      end
    end

    context "When user not logged in" do
      before do
        post :batch_confirm, params: params
      end

      include_examples 'user_not_login'
    end
  end

  describe "POST#batch_cancel" do
    let(:params) {{ order_ids: [order1.id, order2.id], reason: "The reason"}}

    context "When user is logged in" do
      before do
        sign_in(admin)
      end

      context "When user is admin" do
        context "cancel success" do
          it do
            expect {
              post :batch_cancel, params: params, format: :json
            }.to change { [order1.reload.status, order2.reload.status] }.from(["awaiting", "awaiting"]).to(["canceled", "canceled"])
          end

          it "return quantity product" do
            expect {
              post :batch_cancel, params: params, format: :json
            }.to change { product1.reload.quantity }.from(product1.quantity).to(product1.quantity +
              order_detail_1.quantity_product + order_detail_2.quantity_product)
          end
        end

        context "cancel faild" do
          let(:params) {{ order_ids: []}}

          it "order not change status" do
            expect {
              post :batch_cancel, params: params, format: :json
            }.to_not change{[order1.reload.status, order2.reload.status]}
          end

          context "orders selected empty" do
            before do
              post :batch_cancel, params: params
            end

            it "redirect to admin_orders_path" do
              expect(response).to redirect_to(admin_orders_path)
            end

            it "message no_order_selected" do
              expect(flash[:error]).to eq(I18n.t("no_order_selected"))
            end
          end
        end
      end

      context "When user is not admin" do
        let(:admin) {create :user, email: "admin2@gmail.com", is_admin: false}

        before do
          post :batch_cancel, params: params
        end

        it "redirect to root" do
          expect(response).to redirect_to(root_path)
        end

        it "message user not admin" do
          expect(flash[:alert]).to eq(I18n.t("access_denied"))
        end
      end
    end

    context "When user not logged in" do
      before do
        post :batch_cancel, params: params
      end

      include_examples 'user_not_login'
    end
  end
end
