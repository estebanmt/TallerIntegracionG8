require 'test_helper'

class WarehousesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @warehouse = warehouses(:one)
  end

  test "should get index" do
    get warehouses_url, as: :json
    assert_response :success
  end

  test "should create warehouse" do
    assert_difference('Warehouse.count') do
      post warehouses_url, params: { warehouse: { dispatch: @warehouse.dispatch, id: @warehouse.id, lung: @warehouse.lung, reception: @warehouse.reception, spaceTotal: @warehouse.spaceTotal, spaceUsed: @warehouse.spaceUsed } }, as: :json
    end

    assert_response 201
  end

  test "should show warehouse" do
    get warehouse_url(@warehouse), as: :json
    assert_response :success
  end

  test "should update warehouse" do
    patch warehouse_url(@warehouse), params: { warehouse: { dispatch: @warehouse.dispatch, id: @warehouse.id, lung: @warehouse.lung, reception: @warehouse.reception, spaceTotal: @warehouse.spaceTotal, spaceUsed: @warehouse.spaceUsed } }, as: :json
    assert_response 200
  end

  test "should destroy warehouse" do
    assert_difference('Warehouse.count', -1) do
      delete warehouse_url(@warehouse), as: :json
    end

    assert_response 204
  end
end
