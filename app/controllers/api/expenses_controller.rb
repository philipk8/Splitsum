class Api::ExpensesController < ApplicationController

  def create
    # debugger
    @expense = ExpenseDetail.create(expense_params)
    expense_id = @expense.id
    payees_arr = params[:expense][:friends_arr]
    payees_arr << current_user.id

    paid_by_id = params[:expense][:paid_by_id]

    payees_arr.each do |payee_id|
      ExpenseGroup.create(expense_id: expense_id, split_with_id: payee_id, paid_by_id: paid_by_id)
    end
    # render json that shows 
  end

  def index
    # all expenses related to current user
    #  return a @expenses
    #  pass @expenses with all info to the jbuilder
    # this is what the ajax request will get back
    #  ideal world, reducer just takes it lockstockbarrel
    #  and serve it up to the state

    # show everything; only when clicked, it becomes bigger to show the detail per expense 

  debugger 
    expenses_involved = current_user.split_with_expenses

    expense_ids = expenses_involved.pluck(:expense_id).uniq

    expense_details_records = ExpenseDetail.where(:id => [expense_ids])
    
    # expense_details_hash = expense_details_records.all.index_by(&:id)
    expense_details_arr = expense_details_records.as_json

    hash = {}

    expense_details_arr.each do |expense_detail|
      hash[expense_detail.id] = {
        id: expense_detail.id,
        author_id: expense_detail.author_id,
        category: expense_detail.category,
        description: expense_detail.description,
        amount: expense_detail.amount,
        notes: expense_detail.notes
      }
    end

    




# debugger
    # expense_ids.each do |expense_id|
    #   expense_detail = ExpenseDetail.find(expense_id)

    # end


  end

  def show
    # essentially no show; it;s all one long index that expands when you click on an individual item
  end

  def update
  end



  private 

  def expense_params
    params.require(:expense).permit(:author_id, :category, :description, :amount, :notes)
  end

  # def friends_arr_params
  #   params[:friends_arr]
  # end

  # def paid_by_params 
  #  params[:paid_by_id]
  # end
end