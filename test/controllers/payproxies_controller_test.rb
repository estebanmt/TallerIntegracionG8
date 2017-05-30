require 'test_helper'

class PayproxiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payproxy = payproxies(:one)
  end

  test "should get index" do
    get payproxies_url
    assert_response :success
  end

  test "should get new" do
    get new_payproxy_url
    assert_response :success
  end

  test "should create payproxy" do
    assert_difference('Payproxy.count') do
      post payproxies_url, params: { payproxy: { amount: @payproxy.amount, boleta_id: @payproxy.boleta_id } }
    end

    assert_redirected_to payproxy_url(Payproxy.last)
  end

  test "should show payproxy" do
    get payproxy_url(@payproxy)
    assert_response :success
  end

  test "should get edit" do
    get edit_payproxy_url(@payproxy)
    assert_response :success
  end

  test "should update payproxy" do
    patch payproxy_url(@payproxy), params: { payproxy: { amount: @payproxy.amount, boleta_id: @payproxy.boleta_id } }
    assert_redirected_to payproxy_url(@payproxy)
  end

  test "should destroy payproxy" do
    assert_difference('Payproxy.count', -1) do
      delete payproxy_url(@payproxy)
    end

    assert_redirected_to payproxies_url
  end
end
