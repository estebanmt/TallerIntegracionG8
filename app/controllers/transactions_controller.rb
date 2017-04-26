class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # PUT /trx
  def transfer
    render json: '[{
    "transaction_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "reciever": "empresa Y",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # GET /banco/cuenta/:id
  def account
    render json: '[{
    "account_id": "123",
    "balance": 5600000,
    "owner": "empresa X"
}]'
  end

  # GET /transactions
  def index
    #@transactions = Transaction.all

    #render json: @transactions
    render json: '[{
    "transaction_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "reciever": "empresa Y",
    "created_at": "2017-04-26T22:40:17.326Z"
},{
    "transaction_id": "123",
    "amount": 50000,
    "sender": "empresa X",
    "reciever": "empresa Z",
    "created_at": "2017-04-26T22:40:17.326Z"
},{
    "total": 150000
}]'

  end

  # Metodo temporal para mock de GET trx/:id
  def show_transaction
    render json: '[{
    "transaction_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "reciever": "empresa Y",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # GET /transactions/1
  # GET /trx/:id
  def show
    # render json: @transaction
    render json: '[{
    "transaction_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "reciever": "empresa Y",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:amount, :sender, :receiver)
    end
end
