IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_budget_payment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Update_budget_payment]  
(  
     @Event_Id  bigint,  
  @Approved_budget   decimal(18,2),  
  @TotalExpense decimal(18,2),  
  @BalanceToPay decimal(18,2),  
  @flag bigint=0  
   
   
)  
As  
begin  
if(@flag=0)  
Begin  
  
 Update Tbl_BudgetPayment set ApprovedBudget=@Approved_budget,TotalExpense=@TotalExpense,BalanceToPay=@BalanceToPay where Event_Id=@Event_Id  
   
End  
  
end 

    ')
END;
