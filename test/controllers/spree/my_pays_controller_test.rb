require 'test_helper'

class Spree::MyPaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spree_my_pay = spree_my_pays(:one)
  end

  test "should get index" do
    get spree_my_pays_url
    assert_response :success
  end

  test "should get new" do
    get new_spree_my_pay_url
    assert_response :success
  end

  test "should create spree_my_pay" do
    assert_difference('Spree::MyPay.count') do
      post spree_my_pays_url, params: { spree_my_pay: { currency: @spree_my_pay.currency, event_code: @spree_my_pay.event_code, event_date: @spree_my_pay.event_date, live: @spree_my_pay.live, merchant_account_code: @spree_my_pay.merchant_account_code, merchant_reference: @spree_my_pay.merchant_reference, operations: @spree_my_pay.operations, original_reference: @spree_my_pay.original_reference, payment_method: @spree_my_pay.payment_method, processed: @spree_my_pay.processed, psp_reference: @spree_my_pay.psp_reference, reason: @spree_my_pay.reason, success: @spree_my_pay.success, value: @spree_my_pay.value } }
    end

    assert_redirected_to spree_my_pay_url(Spree::MyPay.last)
  end

  test "should show spree_my_pay" do
    get spree_my_pay_url(@spree_my_pay)
    assert_response :success
  end

  test "should get edit" do
    get edit_spree_my_pay_url(@spree_my_pay)
    assert_response :success
  end

  test "should update spree_my_pay" do
    patch spree_my_pay_url(@spree_my_pay), params: { spree_my_pay: { currency: @spree_my_pay.currency, event_code: @spree_my_pay.event_code, event_date: @spree_my_pay.event_date, live: @spree_my_pay.live, merchant_account_code: @spree_my_pay.merchant_account_code, merchant_reference: @spree_my_pay.merchant_reference, operations: @spree_my_pay.operations, original_reference: @spree_my_pay.original_reference, payment_method: @spree_my_pay.payment_method, processed: @spree_my_pay.processed, psp_reference: @spree_my_pay.psp_reference, reason: @spree_my_pay.reason, success: @spree_my_pay.success, value: @spree_my_pay.value } }
    assert_redirected_to spree_my_pay_url(@spree_my_pay)
  end

  test "should destroy spree_my_pay" do
    assert_difference('Spree::MyPay.count', -1) do
      delete spree_my_pay_url(@spree_my_pay)
    end

    assert_redirected_to spree_my_pays_url
  end
end
